/// Immutable data model representing the outcome of a transcription request.
///
/// Uses `freezed` for value equality, `copyWith`, and JSON serialisation.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/transcription_provider.dart';

part 'transcription_result.freezed.dart';
part 'transcription_result.g.dart';

/// A single time‑aligned segment within a transcription.
@freezed
class TranscriptionSegment with _$TranscriptionSegment {
  const factory TranscriptionSegment({
    /// Zero‑based index of this segment.
    required int index,

    /// Start time offset in milliseconds.
    required int startMs,

    /// End time offset in milliseconds.
    required int endMs,

    /// Transcribed text for this segment.
    required String text,

    /// Per‑segment confidence score (0.0 – 1.0), if available.
    double? confidence,
  }) = _TranscriptionSegment;

  factory TranscriptionSegment.fromJson(Map<String, dynamic> json) =>
      _$TranscriptionSegmentFromJson(json);
}

/// Complete result returned after a transcription completes.
@freezed
class TranscriptionResult with _$TranscriptionResult {
  const factory TranscriptionResult({
    /// Full transcribed text.
    required String text,

    /// Overall confidence score (0.0 – 1.0). May be `null` when the
    /// provider does not expose one.
    double? confidence,

    /// Wall‑clock duration of the audio that was transcribed.
    required Duration duration,

    /// Which provider produced this result.
    required TranscriptionProvider provider,

    /// Time‑aligned segments, if available.
    @Default([]) List<TranscriptionSegment> segments,

    /// Detected or requested BCP‑47 language code.
    String? language,

    /// Timestamp when the transcription completed.
    DateTime? completedAt,
  }) = _TranscriptionResult;

  factory TranscriptionResult.fromJson(Map<String, dynamic> json) =>
      _$TranscriptionResultFromJson(json);
}
