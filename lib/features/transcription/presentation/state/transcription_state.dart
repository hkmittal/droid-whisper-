/// Immutable state representation for the transcription workflow.
///
/// Built with `freezed` for sealed‑union style pattern matching.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/transcription_result.dart';

part 'transcription_state.freezed.dart';

/// Represents every possible phase of the transcription UI.
@freezed
sealed class TranscriptionState with _$TranscriptionState {
  /// No activity — the app is waiting for user input.
  const factory TranscriptionState.idle() = TranscriptionIdle;

  /// The microphone is active and recording audio.
  const factory TranscriptionState.recording({
    /// Elapsed recording time.
    required Duration elapsed,
  }) = TranscriptionRecording;

  /// Audio has been captured; transcription is in progress.
  const factory TranscriptionState.transcribing({
    /// Optional progress fraction (0.0 – 1.0), when the provider reports it.
    double? progress,
  }) = TranscriptionTranscribing;

  /// Transcription finished successfully.
  const factory TranscriptionState.completed({
    required TranscriptionResult result,
  }) = TranscriptionCompleted;

  /// Something went wrong.
  const factory TranscriptionState.error({
    required String message,

    /// Optional previous result so the user doesn’t lose their last output.
    TranscriptionResult? previousResult,
  }) = TranscriptionError;
}
