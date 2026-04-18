/// Dedicated HTTP client for the **OpenAI Whisper** `/v1/audio/transcriptions`
/// endpoint.
///
/// Handles multipart form‑data uploads, response parsing, and error mapping.
library;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/transcription_exception.dart';
import '../../../../core/utils/audio_utils.dart';
import '../../domain/models/transcription_config.dart';
import '../../domain/models/transcription_result.dart';
import '../../../../core/enums/transcription_provider.dart';

/// Low‑level client that talks exclusively to the OpenAI Whisper REST API.
class OpenAIWhisperClient {
  OpenAIWhisperClient({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: OpenAIConstants.baseUrl)) {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(minutes: 3);
  }

  final Dio _dio;
  final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Transcribes [audioFile] using the OpenAI Whisper API.
  ///
  /// The [config] must contain a valid `openAIApiKey`.
  Future<TranscriptionResult> transcribe(
    File audioFile,
    TranscriptionConfig config,
  ) async {
    final apiKey = config.openAIApiKey;
    if (apiKey == null || apiKey.isEmpty) {
      throw const MissingApiKeyException(
        'An OpenAI API key is required for cloud transcription.',
      );
    }

    // Validate the audio file before uploading.
    final errors = await AudioUtils.validate(audioFile);
    if (errors.isNotEmpty) {
      throw AudioFileException(errors.join(' '));
    }

    final mimeType = AudioUtils.mimeTypeForPath(audioFile.path) ?? 'audio/wav';
    final fileName = p.basename(audioFile.path);
    // Ignore config.modelName if it's a local model ID (base, tiny, etc.)
    final isLocalModel = ['tiny', 'base', 'small', 'medium', 'large-v1'].contains(config.modelName);
    final model = (config.modelName != null && !isLocalModel) 
        ? config.modelName! 
        : OpenAIConstants.defaultModel;

    _log.i('OpenAI Whisper → uploading "$fileName" ($mimeType) to model=$model');

    final formData = FormData.fromMap(<String, dynamic>{
      'file': await MultipartFile.fromFile(
        audioFile.path,
        filename: fileName,
        contentType: DioMediaType.parse(mimeType),
      ),
      'model': model,
      'response_format': config.responseFormat,
      if (config.language != null) 'language': config.language,
      if (config.prompt != null) 'prompt': config.prompt,
      'temperature': config.temperature,
    });

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        OpenAIConstants.transcriptionsPath,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
          contentType: 'multipart/form-data',
        ),
      );

      final data = response.data!;
      return _parseResponse(data, config);
    } on DioException catch (e, st) {
      _log.e('OpenAI API error', error: e);
      final statusCode = e.response?.statusCode;
      final body = e.response?.data;
      String detail;
      if (body is Map<String, dynamic>) {
        final errorObj = body['error'];
        if (errorObj is Map<String, dynamic>) {
          detail = (errorObj['message'] as String?) ?? '';
        } else {
          detail = body.toString();
        }
      } else {
        detail = '$body';
      }
      throw ApiException(
        'OpenAI Whisper request failed: $detail',
        statusCode: statusCode,
        cause: e,
        stackTrace: st,
      );
    }
  }

  /// Parses the `verbose_json` (or plain text) response into a
  /// [TranscriptionResult].
  TranscriptionResult _parseResponse(
    Map<String, dynamic> data,
    TranscriptionConfig config,
  ) {
    final text = (data['text'] as String?)?.trim() ?? '';
    final language = data['language'] as String?;
    final durationSec = (data['duration'] as num?)?.toDouble() ?? 0;
    final rawSegments = data['segments'] as List<dynamic>? ?? [];

    final segments = rawSegments.map<TranscriptionSegment>((s) {
      final seg = s as Map<String, dynamic>;
      return TranscriptionSegment(
        index: (seg['id'] as num?)?.toInt() ?? 0,
        startMs: (((seg['start'] as num?)?.toDouble() ?? 0) * 1000).round(),
        endMs: (((seg['end'] as num?)?.toDouble() ?? 0) * 1000).round(),
        text: (seg['text'] as String?)?.trim() ?? '',
        confidence: (seg['avg_logprob'] as num?)?.toDouble(),
      );
    }).toList();

    return TranscriptionResult(
      text: text,
      confidence: null, // OpenAI doesn't return a top‑level confidence.
      duration: Duration(milliseconds: (durationSec * 1000).round()),
      provider: TranscriptionProvider.openAIWhisper,
      segments: segments,
      language: language ?? config.language,
      completedAt: DateTime.now(),
    );
  }

  /// Clean up resources.
  void dispose() => _dio.close();
}
