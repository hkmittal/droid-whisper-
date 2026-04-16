/// Enumeration of all transcription back‑ends supported by DroidWhisper.
library;

/// Represents the available speech‑to‑text providers.
enum TranscriptionProvider {
  /// On‑device Whisper inference (no network required).
  local('Local (Whisper on‑device)'),

  /// OpenAI Whisper cloud API.
  openAIWhisper('OpenAI Whisper API'),

  /// Google Gemini 3 Flash multimodal transcription.
  geminiFlash('Gemini 3 Flash');

  const TranscriptionProvider(this.displayName);

  /// Human‑readable label shown in the UI.
  final String displayName;

  /// Whether this provider requires a network connection.
  bool get requiresNetwork => this != TranscriptionProvider.local;

  /// Whether this provider requires an API key.
  bool get requiresApiKey => this != TranscriptionProvider.local;
}
