/// Configuration model that controls how a transcription request is executed.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/transcription_provider.dart';

part 'transcription_config.freezed.dart';
part 'transcription_config.g.dart';

/// Immutable configuration object passed to every transcription call.
@freezed
class TranscriptionConfig with _$TranscriptionConfig {
  const factory TranscriptionConfig({
    /// The transcription back‑end to use.
    @Default(TranscriptionProvider.local)
    TranscriptionProvider provider,

    /// BCP‑47 language hint (e.g. `'en'`, `'es'`).  `null` = auto‑detect.
    String? language,

    /// Personal API key used for OpenAI Whisper requests.
    String? openAIApiKey,

    /// Personal API key used for Gemini Flash requests.
    String? geminiApiKey,

    /// Model identifier override.  Each provider has a sensible default.
    String? modelName,

    /// Whether to request word‑level or segment‑level timestamps.
    @Default(true) bool includeTimestamps,

    /// Optional prompt / context hint supplied to the model.
    String? prompt,

    /// Response format for OpenAI (`json`, `text`, `srt`, `verbose_json`,
    /// `vtt`).  Defaults to `verbose_json` for richest data.
    @Default('verbose_json') String responseFormat,

    /// Temperature (0.0 – 1.0) for sampling. Lower = more deterministic.
    @Default(0.0) double temperature,
  }) = _TranscriptionConfig;

  factory TranscriptionConfig.fromJson(Map<String, dynamic> json) =>
      _$TranscriptionConfigFromJson(json);
}
