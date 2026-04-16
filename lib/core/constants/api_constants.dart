/// Centralised API endpoint and header constants for every cloud provider
/// supported by DroidWhisper.
library;

/// Constants related to the **OpenAI Whisper** transcription API.
abstract final class OpenAIConstants {
  /// Base URL for all OpenAI REST endpoints.
  static const String baseUrl = 'https://api.openai.com';

  /// Audio transcription endpoint (multipart/form-data).
  static const String transcriptionsPath = '/v1/audio/transcriptions';

  /// Full URL for audio transcription.
  static String get transcriptionsUrl => '$baseUrl$transcriptionsPath';

  /// Default model identifier.
  static const String defaultModel = 'whisper-1';

  /// Maximum file size accepted by the API (25 MB).
  static const int maxFileSizeBytes = 25 * 1024 * 1024;

  /// Supported audio MIME types.
  static const List<String> supportedMimeTypes = [
    'audio/flac',
    'audio/mp3',
    'audio/mp4',
    'audio/mpeg',
    'audio/mpga',
    'audio/ogg',
    'audio/wav',
    'audio/webm',
  ];
}

/// Constants related to the **Google Gemini 3 Flash** multimodal API.
abstract final class GeminiConstants {
  /// Base URL for the Gemini generative‑language REST API.
  static const String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';

  /// Default model identifier for Gemini 3 Flash.
  static const String defaultModel = 'gemini-2.0-flash';

  /// Builds the `generateContent` URL for the given [model] and [apiKey].
  static String generateContentUrl({
    String model = defaultModel,
    required String apiKey,
  }) =>
      '$baseUrl/models/$model:generateContent?key=$apiKey';

  /// The system prompt used when requesting transcription from Gemini.
  static const String transcriptionSystemPrompt =
      'You are an expert speech‑to‑text transcription engine. '
      'Given the following audio, produce an accurate verbatim transcription. '
      'Output ONLY the transcribed text with no preamble, no commentary, '
      'and no markdown formatting. If the audio contains multiple speakers, '
      'prefix each turn with "Speaker N: ". '
      'If you cannot understand a segment, write "[inaudible]". '
      'Preserve punctuation and paragraph breaks faithfully.';

  /// Maximum inline audio data size (20 MB base‑64 encoded).
  static const int maxInlineDataBytes = 20 * 1024 * 1024;
}
