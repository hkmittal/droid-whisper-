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
import 'package:permission_handler/permission_handler.dart';
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Default Provider Title
              Text(
                'Default Transcription Provider',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // ── Provider selector chip row
              const ProviderSelectorWidget(),
              const SizedBox(height: 32),

              // ── Floating Widget Toggle
              const _FloatingWidgetToggleTile(),
              const SizedBox(height: 32),

              // ── Central content area (expands)
              Expanded(
                child: Center(
                  child: switch (txState) {
                    TranscriptionCompleted(:final result) =>
                      TranscriptionResultCard(result: result),
                    TranscriptionError(:final message) =>
                      _ErrorView(message: message, theme: theme),
                    _ => const SizedBox.shrink(),
                  },
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

/// Tile that enables/disables the floating widget and automatically handles overlay permission.
class _FloatingWidgetToggleTile extends ConsumerStatefulWidget {
  const _FloatingWidgetToggleTile();

  @override
  ConsumerState<_FloatingWidgetToggleTile> createState() => _FloatingWidgetToggleTileState();
}

class _FloatingWidgetToggleTileState extends ConsumerState<_FloatingWidgetToggleTile> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final isActive = ref.watch(floatingWidgetActiveProvider);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Enable Floating Widget', style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: const Text('Show the circular mic bubble over other apps'),
      trailing: _loading
          ? const CircularProgressIndicator()
          : Switch(
              value: isActive,
              onChanged: (val) async {
                setState(() => _loading = true);
                final channel = ref.read(floatingWidgetChannelProvider);
                try {
                  if (val) {
                    // Start of necessary permissions check
                    final micStatus = await Permission.microphone.request();
                    if (!micStatus.isGranted) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Microphone permission required for floating widget.')),
                        );
                      }
                      return;
                    }
                    if (Theme.of(context).platform == TargetPlatform.android) {
                      await Permission.notification.request();
                    }
                    // End of necessary permissions check

                    final hasPerm = await channel.hasOverlayPermission();
                    if (!hasPerm) {
                      await channel.requestOverlayPermission();
                      final granted = await channel.onOverlayPermissionResult.first
                          .timeout(const Duration(seconds: 30), onTimeout: () => false);
                      if (!granted) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Overlay permission denied.')),
                          );
                        }
                        return;
                      }
                    }
                    await channel.startFloatingWidget();
                    ref.read(floatingWidgetActiveProvider.notifier).state = true;
                  } else {
                    await channel.stopFloatingWidget();
                    ref.read(floatingWidgetActiveProvider.notifier).state = false;
                  }
                } finally {
                  if (mounted) setState(() => _loading = false);
                }
              },
            ),
    );
  }
}
