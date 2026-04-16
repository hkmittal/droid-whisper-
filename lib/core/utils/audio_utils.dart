/// Utility helpers for audio file validation and manipulation.
library;

import 'dart:io';

import 'package:path/path.dart' as p;

import '../constants/api_constants.dart';

/// Collection of pure/static helpers for working with audio files.
abstract final class AudioUtils {
  // ───────────── Extension / MIME helpers ─────────────

  /// Recognised audio file extensions.
  static const Set<String> supportedExtensions = {
    '.flac',
    '.mp3',
    '.mp4',
    '.mpeg',
    '.mpga',
    '.m4a',
    '.ogg',
    '.wav',
    '.webm',
  };

  /// Maps file extensions to MIME types expected by cloud APIs.
  static const Map<String, String> extensionToMime = {
    '.flac': 'audio/flac',
    '.mp3': 'audio/mpeg',
    '.mp4': 'audio/mp4',
    '.mpeg': 'audio/mpeg',
    '.mpga': 'audio/mpeg',
    '.m4a': 'audio/mp4',
    '.ogg': 'audio/ogg',
    '.wav': 'audio/wav',
    '.webm': 'audio/webm',
  };

  /// Returns `true` if the file at [path] has a supported audio extension.
  static bool isSupportedFormat(String path) {
    final ext = p.extension(path).toLowerCase();
    return supportedExtensions.contains(ext);
  }

  /// Returns the MIME type for a given file [path], or `null` if unknown.
  static String? mimeTypeForPath(String path) {
    final ext = p.extension(path).toLowerCase();
    return extensionToMime[ext];
  }

  // ───────────── File validation ─────────────

  /// Validates that [file] exists, has a supported extension, and does not
  /// exceed [maxBytes] (defaults to OpenAI’s 25 MB limit).
  ///
  /// Returns a list of human‑readable error strings. An empty list means the
  /// file is valid.
  static Future<List<String>> validate(
    File file, {
    int maxBytes = OpenAIConstants.maxFileSizeBytes,
  }) async {
    final errors = <String>[];

    if (!file.existsSync()) {
      errors.add('File does not exist: ${file.path}');
      return errors; // no point checking further
    }

    if (!isSupportedFormat(file.path)) {
      errors.add(
        'Unsupported format "${p.extension(file.path)}". '
        'Accepted: ${supportedExtensions.join(", ")}',
      );
    }

    final size = await file.length();
    if (size == 0) {
      errors.add('Audio file is empty (0 bytes).');
    } else if (size > maxBytes) {
      final sizeMB = (size / (1024 * 1024)).toStringAsFixed(1);
      final limitMB = (maxBytes / (1024 * 1024)).toStringAsFixed(0);
      errors.add('File too large ($sizeMB MB). Maximum is $limitMB MB.');
    }

    return errors;
  }

  // ───────────── Duration estimation ─────────────

  /// Rough duration estimate for an audio file based on its byte size and
  /// assumed average bitrate.  This is intentionally imprecise — use a
  /// proper decoder for exact durations.
  static Duration estimateDuration(int fileSizeBytes, {int kbps = 128}) {
    if (fileSizeBytes <= 0 || kbps <= 0) return Duration.zero;
    final seconds = fileSizeBytes / (kbps * 1000 / 8);
    return Duration(milliseconds: (seconds * 1000).round());
  }

  /// Formats a [Duration] as `mm:ss` (or `hh:mm:ss` if ≥ 1 hour).
  static String formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) return '$hours:$minutes:$seconds';
    return '$minutes:$seconds';
  }
}
