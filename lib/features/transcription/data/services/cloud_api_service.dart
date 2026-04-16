/// Cloud transcription service that delegates to either the **OpenAI Whisper**
/// or **Gemini 3 Flash** back‑end depending on the [TranscriptionConfig].
///
/// This is the single [ITranscriptionService] entry‑point the rest of the app
/// uses for all cloud‑based transcriptions.
library;

import 'dart:io';

import 'package:logger/logger.dart';

import '../../../../core/enums/transcription_provider.dart';
import '../../../../core/exceptions/transcription_exception.dart';
import '../../domain/models/transcription_config.dart';
import '../../domain/models/transcription_result.dart';
import '../../domain/services/i_transcription_service.dart';
import 'gemini_flash_client.dart';
import 'openai_whisper_client.dart';

/// Implements [ITranscriptionService] by routing cloud requests to the
/// appropriate provider client.
class CloudApiService implements ITranscriptionService {
  CloudApiService({
    OpenAIWhisperClient? openAIClient,
    GeminiFlashClient? geminiClient,
  })  : _openAI = openAIClient ?? OpenAIWhisperClient(),
        _gemini = geminiClient ?? GeminiFlashClient();

  final OpenAIWhisperClient _openAI;
  final GeminiFlashClient _gemini;
  final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  // ──────────────── ITranscriptionService ────────────────

  @override
  Future<TranscriptionResult> transcribe(
    File audioFile,
    TranscriptionConfig config,
  ) async {
    _log.i('CloudApiService → provider=${config.provider.name}');

    switch (config.provider) {
      case TranscriptionProvider.openAIWhisper:
        return _openAI.transcribe(audioFile, config);

      case TranscriptionProvider.geminiFlash:
        return _gemini.transcribe(audioFile, config);

      case TranscriptionProvider.local:
        throw const TranscriptionException(
          'CloudApiService cannot handle local transcription. '
          'Use LocalWhisperService instead.',
        );
    }
  }

  @override
  Stream<TranscriptionResult> streamTranscribe(
    File audioFile,
    TranscriptionConfig config,
  ) async* {
    // Neither OpenAI Whisper nor Gemini currently expose a streaming
    // transcription endpoint.  Emit a single batch result.
    _log.w(
      'Cloud providers do not support true streaming; '
      'falling back to batch transcription.',
    );
    yield await transcribe(audioFile, config);
  }

  @override
  Future<List<String>> getSupportedLanguages() async {
    // Both OpenAI Whisper and Gemini support a wide range.  Return the
    // intersection of commonly supported languages.
    return const [
      'en', 'es', 'fr', 'de', 'it', 'pt', 'nl', 'ja', 'zh', 'ko',
      'ru', 'ar', 'hi', 'pl', 'tr', 'sv', 'da', 'fi', 'no', 'uk',
    ];
  }

  @override
  Future<bool> isAvailable() async {
    // A simple connectivity check could go here (e.g. HEAD request).
    // For now we just confirm the client objects exist.
    return true;
  }

  @override
  Future<void> dispose() async {
    _openAI.dispose();
    _gemini.dispose();
    _log.i('CloudApiService disposed.');
  }
}
