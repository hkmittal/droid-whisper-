/// StateNotifier that orchestrates the full record → transcribe workflow.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../../../core/exceptions/transcription_exception.dart';
import '../../data/repositories/transcription_repository.dart';
import '../../domain/models/transcription_config.dart';
import '../../domain/models/transcription_result.dart';
import '../state/transcription_state.dart';

/// Drives the transcription UI through its five states:
///   idle → recording → transcribing → completed | error
class TranscriptionNotifier extends StateNotifier<TranscriptionState> {
  TranscriptionNotifier({
    required TranscriptionRepository repository,
    required AudioRecorder recorder,
    required TranscriptionConfig config,
  })  : _repository = repository,
        _recorder = recorder,
        _config = config,
        super(const TranscriptionState.idle());

  final TranscriptionRepository _repository;
  final AudioRecorder _recorder;
  TranscriptionConfig _config;
  final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  Timer? _elapsedTimer;
  String? _currentRecordingPath;

  /// Update config (called when settings change).
  void updateConfig(TranscriptionConfig config) => _config = config;

  // ──────────────── Recording ────────────────

  /// Begin recording audio from the device microphone.
  Future<void> startRecording() async {
    try {
      // Request microphone permission.
      final micStatus = await Permission.microphone.request();
      if (!micStatus.isGranted) {
        state = const TranscriptionState.error(
          message: 'Microphone permission denied. '
              'Please grant it in system settings.',
        );
        return;
      }

      // Determine output path.
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '${dir.path}/dw_recording_$timestamp.wav';

      _log.i('Starting recording → $_currentRecordingPath');

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: _currentRecordingPath!,
      );

      // Tick the elapsed timer every second.
      var elapsed = Duration.zero;
      state = TranscriptionState.recording(elapsed: elapsed);

      _elapsedTimer?.cancel();
      _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        elapsed += const Duration(seconds: 1);
        if (mounted) {
          state = TranscriptionState.recording(elapsed: elapsed);
        }
      });
    } catch (e, st) {
      _log.e('Failed to start recording', error: e, stackTrace: st);
      state = TranscriptionState.error(
        message: 'Failed to start recording: $e',
      );
    }
  }

  /// Stop recording and immediately begin transcription.
  Future<void> stopRecordingAndTranscribe() async {
    _elapsedTimer?.cancel();
    _elapsedTimer = null;

    try {
      final path = await _recorder.stop();
      if (path == null || path.isEmpty) {
        state = const TranscriptionState.error(
          message: 'Recording returned no audio file.',
        );
        return;
      }

      _currentRecordingPath = path;
      _log.i('Recording stopped. File: $path');

      await _transcribeFile(File(path));
    } catch (e, st) {
      _log.e('Error stopping recording', error: e, stackTrace: st);
      state = TranscriptionState.error(
        message: 'Error stopping recording: $e',
      );
    }
  }

  /// Cancel an ongoing recording without transcribing.
  Future<void> cancelRecording() async {
    _elapsedTimer?.cancel();
    _elapsedTimer = null;

    try {
      await _recorder.stop();
      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) await file.delete();
      }
    } catch (_) {
      // Best‑effort cleanup.
    }

    state = const TranscriptionState.idle();
  }

  // ──────────────── Transcription ────────────────

  /// Transcribe an existing audio [file].
  Future<void> transcribeFile(File file) => _transcribeFile(file);

  Future<void> _transcribeFile(File file) async {
    state = const TranscriptionState.transcribing();

    try {
      final rawResult = await _repository.transcribe(file, _config);
      
      // Clean garbage text such as timestamps: [00:00.000 --> 00:05.120] 
      // or [00:00.000] which whisper sometimes returns.
      final cleanText = rawResult.text
          .replaceAll(RegExp(r'\[\d{2}:\d{2}(:\d{2})?\.\d{3}(.*?\])?\s*'), '')
          .trim();
          
      final result = rawResult.copyWith(text: cleanText);

      // Automatically copy to clipboard
      try {
        await Clipboard.setData(ClipboardData(text: cleanText));
      } catch (e) {
        _log.w('Could not copy to clipboard', error: e);
      }

      if (mounted) {
        state = TranscriptionState.completed(result: result);
      }
    } on TranscriptionException catch (e) {
      _log.e('Transcription error', error: e);
      if (mounted) {
        state = TranscriptionState.error(message: e.message);
      }
    } catch (e, st) {
      _log.e('Unexpected transcription error', error: e, stackTrace: st);
      if (mounted) {
        state = TranscriptionState.error(
          message: 'Unexpected error: $e',
        );
      }
    }
  }

  /// Transcribe a file picked from the file system.
  Future<void> transcribeFromPath(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      state = TranscriptionState.error(
        message: 'File not found: $filePath',
      );
      return;
    }
    await _transcribeFile(file);
  }

  // ──────────────── Reset ────────────────

  /// Return to the idle state.
  void reset() => state = const TranscriptionState.idle();

  // ──────────────── Cleanup ────────────────

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    super.dispose();
  }
}
