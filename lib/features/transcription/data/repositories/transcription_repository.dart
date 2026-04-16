/// Repository that mediates between the presentation layer and the
/// transcription service abstractions.
///
/// It selects the correct [ITranscriptionService] implementation based on
/// [TranscriptionConfig.provider] and applies any cross‑cutting concerns such
/// as caching, analytics, or retry logic.
library;

import 'dart:io';

import 'package:logger/logger.dart';

import '../../../../core/enums/transcription_provider.dart';
import '../../../../core/exceptions/transcription_exception.dart';
import '../../domain/models/transcription_config.dart';
import '../../domain/models/transcription_result.dart';
import '../../domain/services/i_transcription_service.dart';
import '../services/cloud_api_service.dart';
import '../services/local_whisper_service.dart';

/// High‑level transcription repository used by the presentation layer.
///
/// Internally holds one [LocalWhisperService] and one [CloudApiService].
/// The caller’s [TranscriptionConfig.provider] determines which implementation
/// is invoked.
class TranscriptionRepository {
  TranscriptionRepository({
    ITranscriptionService? localService,
    ITranscriptionService? cloudService,
  })  : _local = localService ?? LocalWhisperService(),
        _cloud = cloudService ?? CloudApiService();

  final ITranscriptionService _local;
  final ITranscriptionService _cloud;
  final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  /// History of completed transcriptions (most recent first).
  final List<TranscriptionResult> _history = [];

  /// Returns an unmodifiable view of the transcription history.
  List<TranscriptionResult> get history => List.unmodifiable(_history);

  // ──────────────── Service routing ────────────────

  ITranscriptionService _serviceFor(TranscriptionProvider provider) {
    switch (provider) {
      case TranscriptionProvider.local:
        return _local;
      case TranscriptionProvider.openAIWhisper:
      case TranscriptionProvider.geminiFlash:
        return _cloud;
    }
  }

  // ──────────────── Public API ────────────────

  /// Perform a full‑file transcription.
  ///
  /// The result is appended to [history] automatically.
  Future<TranscriptionResult> transcribe(
    File audioFile,
    TranscriptionConfig config,
  ) async {
    _log.i(
      'TranscriptionRepository.transcribe() → '
      'provider=${config.provider.name}',
    );

    try {
      final service = _serviceFor(config.provider);
      final result = await service.transcribe(audioFile, config);
      _history.insert(0, result);
      _log.i(
        'Transcription complete: ${result.text.length} chars, '
        '${result.segments.length} segments.',
      );
      return result;
    } on TranscriptionException {
      rethrow;
    } catch (e, st) {
      throw TranscriptionException(
        'Unexpected error during transcription: $e',
        cause: e,
        stackTrace: st,
      );
    }
  }

  /// Stream partial transcription results.
  Stream<TranscriptionResult> streamTranscribe(
    File audioFile,
    TranscriptionConfig config,
  ) {
    final service = _serviceFor(config.provider);
    return service.streamTranscribe(audioFile, config);
  }

  /// Check provider availability.
  Future<bool> isProviderAvailable(TranscriptionProvider provider) {
    return _serviceFor(provider).isAvailable();
  }

  /// Supported languages for a given provider.
  Future<List<String>> getSupportedLanguages(TranscriptionProvider provider) {
    return _serviceFor(provider).getSupportedLanguages();
  }

  /// Clear transcription history.
  void clearHistory() {
    _history.clear();
    _log.i('Transcription history cleared.');
  }

  /// Release resources held by all services.
  Future<void> dispose() async {
    await _local.dispose();
    await _cloud.dispose();
    _log.i('TranscriptionRepository disposed.');
  }
}
