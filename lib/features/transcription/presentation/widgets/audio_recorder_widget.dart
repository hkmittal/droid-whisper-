/// Floating action‑style widget that drives audio recording.
///
/// Shows a mic button when idle, a pulsing stop button when recording, and
/// is disabled during transcription.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transcription_providers.dart';
import '../state/transcription_state.dart';

/// Central recording button used on the [HomeScreen].
class AudioRecorderWidget extends ConsumerWidget {
  const AudioRecorderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txState = ref.watch(transcriptionStateProvider);
    final notifier = ref.read(transcriptionStateProvider.notifier);
    final theme = Theme.of(context);

    final bool isRecording = txState is TranscriptionRecording;
    final bool isTranscribing = txState is TranscriptionTranscribing;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Cancel button (visible only while recording)
        if (isRecording)
          _CircleButton(
            icon: Icons.close_rounded,
            size: 48,
            color: theme.colorScheme.surfaceContainerHighest,
            iconColor: theme.colorScheme.onSurfaceVariant,
            tooltip: 'Cancel recording',
            onPressed: notifier.cancelRecording,
          ),
        if (isRecording) const SizedBox(width: 24),

        // Main record / stop button
        _CircleButton(
          icon: isRecording ? Icons.stop_rounded : Icons.mic_rounded,
          size: 72,
          color: isRecording
              ? theme.colorScheme.error
              : theme.colorScheme.primary,
          iconColor: isRecording
              ? theme.colorScheme.onError
              : theme.colorScheme.onPrimary,
          tooltip: isRecording ? 'Stop & transcribe' : 'Start recording',
          onPressed: isTranscribing
              ? null
              : () {
                  if (isRecording) {
                    notifier.stopRecordingAndTranscribe();
                  } else {
                    notifier.startRecording();
                  }
                },
        ),

        // Placeholder for symmetry when recording
        if (isRecording) const SizedBox(width: 24),
        if (isRecording)
          const SizedBox(width: 48), // balance the cancel button
      ],
    );
  }
}

/// Reusable circle‑shaped icon button.
class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.size,
    required this.color,
    required this.iconColor,
    required this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final double size;
  final Color color;
  final Color iconColor;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        shape: const CircleBorder(),
        color: onPressed == null ? color.withOpacity(0.4) : color,
        elevation: 4,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, color: iconColor, size: size * 0.45),
          ),
        ),
      ),
    );
  }
}
