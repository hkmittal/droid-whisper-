/// On‑device Whisper transcription via the `whisper_flutter_new` package.
///
/// Runs entirely offline — no API key or network required.
library;

import 'dart:io';

import 'package:logger/logger.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';

import '../../../../core/enums/transcription_provider.dart';
import '../../../../core/enums/whisper_model.dart' as core_models;
import '../../../../core/exceptions/transcription_exception.dart';
import '../../../../core/utils/audio_utils.dart';
import '../../domain/models/transcription_config.dart';
import '../../domain/models/transcription_result.dart';
import '../../domain/services/i_transcription_service.dart';
import '../services/local_model_manager.dart';

/// [ITranscriptionService] implementation that runs Whisper inference on‑device
/// using the `whisper_flutter_new` FFI bindings.
class LocalWhisperService implements ITranscriptionService {
  LocalWhisperService();

  final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  /// The underlying Whisper instance; lazily initialised.
  Whisper? _whisper;

  /// Default ggml model to use when none specified in config.
  static const WhisperModel _defaultModel = WhisperModel.base;

  // ──────────────── Lifecycle ────────────────

  /// Ensures the Whisper model is downloaded and ready.
  Future<Whisper> _ensureInitialised(TranscriptionConfig config) async {
    if (_whisper != null) return _whisper!;

    try {
      _log.i('Initialising local Whisper model…');
      final manager = LocalModelManager();
      final targetModel = core_models.LocalWhisperModel.fromId(config.modelName);

      if (!await manager.isModelDownloaded(targetModel)) {
        throw LocalModelException(
          'The ${targetModel.displayName} model is not downloaded.\n'
          'Please visit Settings -> Local Models Library to download it.',
        );
      }

      final model = _resolveModel(config.modelName);
      _whisper = Whisper(model: model, downloadHost: "");
      return _whisper!;
    } catch (e, st) {
      throw LocalModelException(
        'Failed to initialise local Whisper model: $e',
        cause: e,
        stackTrace: st,
      );
    }
  }

  /// Maps an optional model name string to a [WhisperModel] enum value.
  WhisperModel _resolveModel(String? name) {
    if (name == null || name.isEmpty) return _defaultModel;
    switch (name.toLowerCase()) {
      case 'tiny':
        return WhisperModel.tiny;
      case 'base':
        return WhisperModel.base;
      case 'small':
        return WhisperModel.small;
      case 'medium':
        return WhisperModel.medium;
      case 'large':
      case 'large-v1':
        return WhisperModel.largeV1;
      default:
        _log.w('Unknown Whisper model "$name"; falling back to base.');
        return _defaultModel;
    }
  }

  // ──────────────── ITranscriptionService ────────────────

  @override
  Future<TranscriptionResult> transcribe(
    File audioFile,
    TranscriptionConfig config,
  ) async {
    // Validate the file.
    final validationErrors = await AudioUtils.validate(audioFile);
    if (validationErrors.isNotEmpty) {
      throw AudioFileException(validationErrors.join(' '));
    }

    final whisper = await _ensureInitialised(config);
    final stopwatch = Stopwatch()..start();

    _log.i('Local Whisper → transcribing "${audioFile.path}"…');

    try {
      final transcribeRequest = TranscribeRequest(
        audio: audioFile.path,
        language: config.language ?? 'en',
        isTranslate: false,
        isNoTimestamps: !config.includeTimestamps,
        splitOnWord: true,
      );

      final result = await whisper.transcribe(
        transcribeRequest: transcribeRequest,
      );

      stopwatch.stop();

      // Extract text from TranscribeResponse object safely.
      String fullText = '';
      try {
        fullText = (result as dynamic).text?.toString().trim() ?? '';
      } catch (_) {
        // Fallback if the object schema changes.
      }
      if (fullText.isEmpty) {
        fullText = result.toString().trim();
      }

      _log.i(
        'Local Whisper → completed in ${stopwatch.elapsedMilliseconds} ms '
        '(${fullText.split(' ').length} words)',
      );

      return TranscriptionResult(
        text: fullText,
        confidence: null,
        duration: stopwatch.elapsed,
        provider: TranscriptionProvider.local,
        segments: const [],
        language: config.language,
        completedAt: DateTime.now(),
      );
    } catch (e, st) {
      stopwatch.stop();
      if (e is TranscriptionException) rethrow;
      throw TranscriptionException(
        'Local Whisper transcription failed: $e',
        cause: e,
        stackTrace: st,
      );
    }
  }

  @override
  Stream<TranscriptionResult> streamTranscribe(
    File audioFile,
    TranscriptionConfig config,
  ) async* {
    // On‑device Whisper does not natively support streaming.
    // Fall back to a single‑shot transcription emitted as one event.
    _log.w('Local Whisper does not support true streaming; '
        'falling back to batch transcription.');
    yield await transcribe(audioFile, config);
  }

  @override
  Future<List<String>> getSupportedLanguages() async {
    // Whisper supports 99+ languages.  Return a representative subset;
    // the full list lives at https://github.com/openai/whisper.
    return const [
      'en', 'es', 'fr', 'de', 'it', 'pt', 'nl', 'ja', 'zh', 'ko',
      'ru', 'ar', 'hi', 'pl', 'tr', 'sv', 'da', 'fi', 'no', 'uk',
    ];
  }

  @override
  Future<bool> isAvailable() async {
    try {
      // A lightweight check — simply try to initialise.
      await _ensureInitialised(const TranscriptionConfig());
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> dispose() async {
    _whisper = null;
    _log.i('Local Whisper service disposed.');
  }
}
