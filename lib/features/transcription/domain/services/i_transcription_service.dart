/// Contract (abstract class) that every transcription back‑end must fulfil.
///
/// This lives in the **domain** layer so that the presentation and data layers
/// both depend on the abstraction rather than on concrete implementations.
library;

import 'dart:io';

import '../models/transcription_config.dart';
import '../models/transcription_result.dart';

/// Service interface for speech‑to‑text transcription.
abstract class ITranscriptionService {
  // ──────────────── Core transcription ────────────────

  /// Transcribe an entire [audioFile] in one shot.
  ///
  /// Throws [TranscriptionException] (or a subclass) on failure.
  Future<TranscriptionResult> transcribe(
    File audioFile,
    TranscriptionConfig config,
  );

  // ──────────────── Streaming / real‑time ────────────────

  /// Stream partial transcription results as audio is being recorded.
  ///
  /// Yields incremental [TranscriptionResult]s.  Implementations that do not
  /// support streaming should emit a single result and close.
  Stream<TranscriptionResult> streamTranscribe(
    File audioFile,
    TranscriptionConfig config,
  );

  // ──────────────── Capabilities ────────────────

  /// Returns the set of BCP‑47 language codes this service can handle.
  Future<List<String>> getSupportedLanguages();

  /// Quick health‑check.  Returns `true` when the provider is ready to accept
  /// transcription requests (model loaded / API reachable / key valid).
  Future<bool> isAvailable();

  /// Releases heavyweight resources (loaded models, open connections, etc.).
  Future<void> dispose();
}
