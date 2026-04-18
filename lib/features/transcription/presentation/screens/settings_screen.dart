/// Settings screen for API key management, provider selection, and language
/// preferences.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/transcription_provider.dart';
import '../providers/transcription_providers.dart';
import 'local_models_screen.dart';

/// Settings screen where the user configures API keys, provider, and language.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _openAIKeyController;
  late final TextEditingController _geminiKeyController;
  late final TextEditingController _promptController;

  // Whether we currently have overlay permission (refreshed on resume).
  bool _hasOverlayPermission = false;

  /// Language codes shown in the dropdown.
  static const _languages = <String, String>{
    '': 'Auto‑detect',
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'nl': 'Dutch',
    'ja': 'Japanese',
    'zh': 'Chinese',
    'ko': 'Korean',
    'ru': 'Russian',
    'ar': 'Arabic',
    'hi': 'Hindi',
  };

  @override
  void initState() {
    super.initState();
    final config = ref.read(configProvider);
    _openAIKeyController =
        TextEditingController(text: config.openAIApiKey ?? '');
    _geminiKeyController =
        TextEditingController(text: config.geminiApiKey ?? '');
    _promptController = TextEditingController(text: config.prompt ?? '');
    _refreshOverlayPermission();
  }

  Future<void> _refreshOverlayPermission() async {
    final channel = ref.read(floatingWidgetChannelProvider);
    final granted = await channel.hasOverlayPermission();
    if (mounted) setState(() => _hasOverlayPermission = granted);
  }

  @override
  void dispose() {
    _openAIKeyController.dispose();
    _geminiKeyController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final notifier = ref.read(configProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          const _LocalModelsMarketplaceTile(),
          const SizedBox(height: 24),
          const SizedBox(height: 24),

          // ──────── Language ────────
          Text('Language', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: config.language ?? '',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: _languages.entries
                .map((e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ))
                .toList(),
            onChanged: (v) =>
                notifier.setLanguage(v == null || v.isEmpty ? null : v),
          ),
          const SizedBox(height: 24),

          // ──────── OpenAI API key ────────
          Text('OpenAI API Key', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: _openAIKeyController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'sk-…',
              isDense: true,
            ),
            onChanged: (v) => notifier.setOpenAIApiKey(v.isEmpty ? null : v),
          ),
          const SizedBox(height: 16),

          // ──────── Gemini API key ────────
          Text('Gemini API Key', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: _geminiKeyController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'AIza…',
              isDense: true,
            ),
            onChanged: (v) => notifier.setGeminiApiKey(v.isEmpty ? null : v),
          ),
          const SizedBox(height: 24),

          // ──────── Prompt / context hint ────────
          Text('Prompt / Context Hint', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: _promptController,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Optional context to improve accuracy…',
              isDense: true,
            ),
            onChanged: (v) => notifier.setPrompt(v.isEmpty ? null : v),
          ),
          const SizedBox(height: 24),

          // ──────── Temperature slider ────────
          Text('Temperature: ${config.temperature.toStringAsFixed(1)}',
              style: theme.textTheme.titleSmall),
          Slider(
            value: config.temperature,
            min: 0,
            max: 1,
            divisions: 10,
            label: config.temperature.toStringAsFixed(1),
            onChanged: notifier.setTemperature,
          ),
          const SizedBox(height: 16),


          // ──────── Bluetooth Mic toggle ────────
          SwitchListTile(
            title: Text('Prefer Bluetooth Microphone', style: theme.textTheme.titleSmall),
            subtitle: const Text('Attempts to route audio from connected Bluetooth earphones (like TWS).'),
            value: ref.watch(preferBluetoothMicProvider),
            onChanged: (val) {
              ref.read(preferBluetoothMicProvider.notifier).setPreferBluetooth(val);
            },
            contentPadding: EdgeInsets.zero,
            activeColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),

          // ──────── Info card ────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('About Providers',
                          style: theme.textTheme.titleSmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Local — runs on‑device via Whisper. No data leaves '
                    'your phone.\n'
                    '• OpenAI Whisper — uploads audio to OpenAI\'s API. '
                    'Requires an API key.\n'
                    '• Gemini 3 Flash — sends audio to Google\'s Gemini API. '
                    'Requires a Gemini API key.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocalModelsMarketplaceTile extends ConsumerWidget {
  const _LocalModelsMarketplaceTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withValues(alpha: isDark ? 0.2 : 0.4),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LocalModelsScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.storefront_rounded, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Local Models Library',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage offline AI models to balance speed and accuracy.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
