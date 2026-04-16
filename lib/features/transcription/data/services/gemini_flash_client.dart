/// Dedicated HTTP client for **Google Gemini 3 Flash** multimodal
/// transcription.
///
/// Sends the audio as inline base‑64 data within a `generateContent` request
/// and parses the textual transcription from the response.
library;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/enums/transcription_provider.dart';
import '../../../../core/exceptions/transcription_exception.dart';
import '../../../../core/utils/audio_utils.dart';
import '../../domain/models/transcription_config.dart';
import '../../domain/models/transcription_result.dart';

/// Low‑level client that talks exclusively to the Gemini `generateContent` API
/// for audio transcription.
class GeminiFlashClient {
  GeminiFlashClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(minutes: 5);
  }

  final Dio _dio;
  final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Transcribes [audioFile] by sending it as inline base‑64 data to the
  /// Gemini `generateContent` endpoint.
  ///
  /// The [config] must contain a valid `geminiApiKey`.
  Future<TranscriptionResult> transcribe(
    File audioFile,
    TranscriptionConfig config,
  ) async {
    final apiKey = config.geminiApiKey;
    if (apiKey == null || apiKey.isEmpty) {
      throw const MissingApiKeyException(
        'A Gemini API key is required for Gemini Flash transcription.',
      );
    }

    // Validate the audio file.
    final errors = await AudioUtils.validate(
      audioFile,
      maxBytes: GeminiConstants.maxInlineDataBytes,
    );
    if (errors.isNotEmpty) {
      throw AudioFileException(errors.join(' '));
    }

    final mimeType = AudioUtils.mimeTypeForPath(audioFile.path) ?? 'audio/wav';
    final audioBytes = await audioFile.readAsBytes();
    final audioBase64 = base64Encode(audioBytes);
    final model = config.modelName ?? GeminiConstants.defaultModel;
    final url = GeminiConstants.generateContentUrl(
      model: model,
      apiKey: apiKey,
    );

    _log.i(
      'Gemini Flash → sending ${p.basename(audioFile.path)} '
      '(${(audioBytes.length / 1024).toStringAsFixed(0)} KB, $mimeType) '
      'to model=$model',
    );

    // Build the language hint suffix for the prompt.
    final languageHint = config.language != null
        ? ' The audio is in ${config.language}.'
        : '';

    final body = <String, dynamic>{
      'contents': [
        {
          'parts': [
            // System/instruction text part.
            {
              'text':
                  '${GeminiConstants.transcriptionSystemPrompt}$languageHint',
            },
            // Inline audio data part.
            {
              'inline_data': {
                'mime_type': mimeType,
                'data': audioBase64,
              },
            },
          ],
        },
      ],
      'generationConfig': {
        'temperature': config.temperature,
        'maxOutputTokens': 8192,
      },
    };

    try {
      final stopwatch = Stopwatch()..start();

      final response = await _dio.post<Map<String, dynamic>>(
        url,
        data: body,
        options: Options(contentType: 'application/json'),
      );

      stopwatch.stop();

      final data = response.data!;
      return _parseResponse(data, config, stopwatch.elapsed);
    } on DioException catch (e, st) {
      _log.e('Gemini API error', error: e);
      final statusCode = e.response?.statusCode;
      final body = e.response?.data;
      String detail;
      if (body is Map) {
        detail = (body['error']?['message'] as String?) ?? body.toString();
      } else {
        detail = '$body';
      }
      throw ApiException(
        'Gemini Flash request failed: $detail',
        statusCode: statusCode,
        cause: e,
        stackTrace: st,
      );
    }
  }

  /// Extracts transcribed text from the Gemini `generateContent` response.
  TranscriptionResult _parseResponse(
    Map<String, dynamic> data,
    TranscriptionConfig config,
    Duration elapsed,
  ) {
    // Navigate: candidates[0].content.parts[0].text
    final candidates = data['candidates'] as List<dynamic>? ?? [];
    if (candidates.isEmpty) {
      throw const ApiException(
        'Gemini returned no candidates in the response.',
      );
    }

    final firstCandidate = candidates.first as Map<String, dynamic>;
    final content = firstCandidate['content'] as Map<String, dynamic>? ?? {};
    final parts = content['parts'] as List<dynamic>? ?? [];

    final textBuffer = StringBuffer();
    for (final part in parts) {
      if (part is Map<String, dynamic> && part.containsKey('text')) {
        textBuffer.write(part['text']);
      }
    }

    final transcribedText = textBuffer.toString().trim();
    if (transcribedText.isEmpty) {
      throw const ApiException(
        'Gemini returned an empty transcription.',
      );
    }

    return TranscriptionResult(
      text: transcribedText,
      confidence: null, // Gemini does not provide a confidence score.
      duration: elapsed,
      provider: TranscriptionProvider.geminiFlash,
      segments: const [], // Gemini doesn't return time‑aligned segments.
      language: config.language,
      completedAt: DateTime.now(),
    );
  }

  /// Clean up resources.
  void dispose() => _dio.close();
}
