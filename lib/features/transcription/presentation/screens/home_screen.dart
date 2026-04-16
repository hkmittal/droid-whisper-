/// Main screen of DroidWhisper.
///
/// Displays the record button, current provider badge, and transcription
/// results.  All state is driven by [transcriptionStateProvider].
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/audio_utils.dart';
import '../providers/transcription_providers.dart';
import '../state/transcription_state.dart';
import '../widgets/audio_recorder_widget.dart';
import '../widgets/provider_selector_widget.dart';
import '../widgets/transcription_result_card.dart';
import 'settings_screen.dart';

/// The home screen of the DroidWhisper app.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Listen for native → Flutter recording requests from the floating widget.
    WidgetsBinding.instance.addPostFrameCallback((_) => _setupWidgetListeners());
  }

  void _setupWidgetListeners() {
    final channel  = ref.read(floatingWidgetChannelProvider);

    channel.onWidgetStartRecording.listen((_) async {
      print('Floating widget: onWidgetStartRecording received!');
      try {
        // Apply the widget’s default provider before recording.
        final widgetProvider = ref.read(widgetProviderNotifierProvider);
        ref.read(configProvider.notifier).setProvider(widgetProvider);
        
        final notifier = ref.read(transcriptionStateProvider.notifier);
        await notifier.startRecording();
        print('Floating widget: startRecording completed, notifying native...');
        await channel.notifyRecordingStarted();
      } catch (e, st) {
        print('Floating widget error on start: $e\n$st');
      }
    });

    channel.onWidgetStopRecording.listen((_) async {
      print('Floating widget: onWidgetStopRecording received!');
      try {
        final notifier = ref.read(transcriptionStateProvider.notifier);
        print('Floating widget: notifying native overlay to close early...');
        await channel.notifyRecordingStopped();
        await notifier.stopRecordingAndTranscribe();
      } catch (e, st) {
        print('Floating widget error on stop: $e\n$st');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final txState = ref.watch(transcriptionStateProvider);
    final config  = ref.watch(configProvider);
    final theme   = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DroidWhisper'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // ── Provider selector chip row
              const ProviderSelectorWidget(),
              const SizedBox(height: 24),

              // ── Central content area (expands)
              Expanded(
                child: Center(
                  child: switch (txState) {
                    TranscriptionIdle() => _IdleView(theme: theme),
                    TranscriptionRecording(:final elapsed) =>
                      _RecordingView(elapsed: elapsed, theme: theme),
                    TranscriptionTranscribing(:final progress) =>
                      _TranscribingView(progress: progress, theme: theme),
                    TranscriptionCompleted(:final result) =>
                      TranscriptionResultCard(result: result),
                    TranscriptionError(:final message) =>
                      _ErrorView(message: message, theme: theme),
                  },
                ),
              ),

              const SizedBox(height: 16),

              // ── Record / stop button
              const AudioRecorderWidget(),
              const SizedBox(height: 12),

              // ── Provider info footer
              Text(
                'Provider: ${config.provider.displayName}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
// Private sub‑views
// ────────────────────────────────────────────────────────────────

class _IdleView extends StatelessWidget {
  const _IdleView({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.mic_none_rounded,
          size: 96,
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
        const SizedBox(height: 16),
        Text(
          'Tap the mic to start recording',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _RecordingView extends StatelessWidget {
  const _RecordingView({required this.elapsed, required this.theme});
  final Duration elapsed;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.fiber_manual_record_rounded,
          size: 80,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: 12),
        Text(
          AudioUtils.formatDuration(elapsed),
          style: theme.textTheme.headlineLarge?.copyWith(
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Recording…',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _TranscribingView extends StatelessWidget {
  const _TranscribingView({required this.progress, required this.theme});
  final double? progress;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 6,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Transcribing…',
          style: theme.textTheme.titleMedium,
        ),
        if (progress != null) ...
          [
            const SizedBox(height: 4),
            Text(
              '${(progress! * 100).toStringAsFixed(0)}%',
              style: theme.textTheme.bodySmall,
            ),
          ],
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.theme});
  final String message;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline_rounded,
          size: 64,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      ],
    );
  }
}
