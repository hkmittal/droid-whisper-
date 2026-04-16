/// Custom exception hierarchy for the transcription feature.
library;

/// Base exception for all transcription‑related errors.
class TranscriptionException implements Exception {
  const TranscriptionException(this.message, {this.cause, this.stackTrace});

  /// Human‑readable description of what went wrong.
  final String message;

  /// Optional underlying error that triggered this exception.
  final Object? cause;

  /// Optional stack trace captured at the point of failure.
  final StackTrace? stackTrace;

  @override
  String toString() => 'TranscriptionException: $message';
}

/// Thrown when audio recording fails (permissions, hardware, etc.).
class AudioRecordingException extends TranscriptionException {
  const AudioRecordingException(super.message, {super.cause, super.stackTrace});

  @override
  String toString() => 'AudioRecordingException: $message';
}

/// Thrown when the audio file is invalid, too large, or in an
/// unsupported format.
class AudioFileException extends TranscriptionException {
  const AudioFileException(super.message, {super.cause, super.stackTrace});

  @override
  String toString() => 'AudioFileException: $message';
}

/// Thrown when a cloud API call fails (network, auth, rate‑limit, etc.).
class ApiException extends TranscriptionException {
  const ApiException(
    super.message, {
    this.statusCode,
    super.cause,
    super.stackTrace,
  });

  /// HTTP status code returned by the API, if available.
  final int? statusCode;

  @override
  String toString() =>
      'ApiException($statusCode): $message';
}

/// Thrown when the on‑device Whisper model is unavailable or fails to load.
class LocalModelException extends TranscriptionException {
  const LocalModelException(super.message, {super.cause, super.stackTrace});

  @override
  String toString() => 'LocalModelException: $message';
}

/// Thrown when a required API key is missing or invalid.
class MissingApiKeyException extends TranscriptionException {
  const MissingApiKeyException(super.message, {super.cause, super.stackTrace});

  @override
  String toString() => 'MissingApiKeyException: $message';
}
