/// Central Riverpod provider declarations for the transcription feature.
///
/// These are plain providers (no code‑gen) for clarity — migrate to
/// `riverpod_generator` annotations when the team is ready.
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/enums/transcription_provider.dart';
import '../../data/repositories/transcription_repository.dart';
import '../../data/services/cloud_api_service.dart';
import '../../data/services/local_whisper_service.dart';
import '../../domain/models/transcription_config.dart';
import '../../domain/services/i_transcription_service.dart';
import '../notifiers/transcription_notifier.dart';
import '../state/transcription_state.dart';
import '../widgets/floating_widget_channel.dart';

// ────────────────────────────────────────────────────────────────
// Service providers
// ────────────────────────────────────────────────────────────────

/// Provides the on‑device Whisper transcription service.
final localWhisperServiceProvider = Provider<ITranscriptionService>((ref) {
  final service = LocalWhisperService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provides the cloud‑backed transcription service (OpenAI + Gemini).
final cloudApiServiceProvider = Provider<ITranscriptionService>((ref) {
  final service = CloudApiService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Family provider: returns the correct [ITranscriptionService] for a given
/// [TranscriptionProvider].
final transcriptionServiceProvider =
    Provider.family<ITranscriptionService, TranscriptionProvider>(
  (ref, provider) {
    switch (provider) {
      case TranscriptionProvider.local:
        return ref.watch(localWhisperServiceProvider);
      case TranscriptionProvider.openAIWhisper:
      case TranscriptionProvider.geminiFlash:
        return ref.watch(cloudApiServiceProvider);
    }
  },
);

// ────────────────────────────────────────────────────────────────
// Repository
// ────────────────────────────────────────────────────────────────

/// Provides the [TranscriptionRepository] singleton.
final transcriptionRepositoryProvider = Provider<TranscriptionRepository>(
  (ref) {
    final repo = TranscriptionRepository(
      localService: ref.watch(localWhisperServiceProvider),
      cloudService: ref.watch(cloudApiServiceProvider),
    );
    ref.onDispose(() => repo.dispose());
    return repo;
  },
);

// ────────────────────────────────────────────────────────────────
// Audio recorder
// ────────────────────────────────────────────────────────────────

/// Provides a shared [AudioRecorder] instance.
final audioRecorderProvider = Provider<AudioRecorder>((ref) {
  final recorder = AudioRecorder();
  ref.onDispose(() => recorder.dispose());
  return recorder;
});

// ────────────────────────────────────────────────────────────────
// Config
// ────────────────────────────────────────────────────────────────

/// Mutable configuration state.  Seeded from `.env` defaults.
final configProvider =
    StateNotifierProvider<ConfigNotifier, TranscriptionConfig>(
  (ref) => ConfigNotifier(),
);

/// Manages the user’s transcription preferences.
class ConfigNotifier extends StateNotifier<TranscriptionConfig> {
  ConfigNotifier()
      : super(
          TranscriptionConfig(
            provider: _defaultProvider(),
            language: dotenv.env['DEFAULT_LANGUAGE'],
            openAIApiKey: dotenv.env['OPENAI_API_KEY'],
            geminiApiKey: dotenv.env['GEMINI_API_KEY'],
          ),
        );

  static TranscriptionProvider _defaultProvider() {
    final raw = dotenv.env['DEFAULT_PROVIDER'] ?? 'local';
    switch (raw) {
      case 'openai_whisper':
        return TranscriptionProvider.openAIWhisper;
      case 'gemini_flash':
        return TranscriptionProvider.geminiFlash;
      default:
        return TranscriptionProvider.local;
    }
  }

  void setProvider(TranscriptionProvider provider) =>
      state = state.copyWith(provider: provider);

  void setLanguage(String? language) =>
      state = state.copyWith(language: language);

  void setOpenAIApiKey(String? key) => state = state.copyWith(openAIApiKey: key);

  void setGeminiApiKey(String? key) => state = state.copyWith(geminiApiKey: key);

  void setModelName(String? name) => state = state.copyWith(modelName: name);

  void setTemperature(double temp) =>
      state = state.copyWith(temperature: temp);

  void setPrompt(String? prompt) => state = state.copyWith(prompt: prompt);

  /// Bulk‑update from the settings screen.
  void updateConfig(TranscriptionConfig newConfig) => state = newConfig;
}

// ────────────────────────────────────────────────────────────────
// Transcription workflow state
// ────────────────────────────────────────────────────────────────

/// Provides the [TranscriptionNotifier] (main workflow controller).
final transcriptionStateProvider =
    StateNotifierProvider<TranscriptionNotifier, TranscriptionState>(
  (ref) => TranscriptionNotifier(
    repository: ref.watch(transcriptionRepositoryProvider),
    recorder: ref.watch(audioRecorderProvider),
    config: ref.watch(configProvider),
  ),
);
// ────────────────────────────────────────────────────────────────
// Floating widget channel
// ────────────────────────────────────────────────────────────────

/// Provides the singleton [FloatingWidgetChannel] that bridges Flutter↔native.
final floatingWidgetChannelProvider = Provider<FloatingWidgetChannel>((ref) {
  final ch = FloatingWidgetChannel();
  ref.onDispose(ch.dispose);
  return ch;
});

/// Tracks whether the floating widget is currently active/visible.
final floatingWidgetActiveProvider = StateProvider<bool>((ref) => false);

// ────────────────────────────────────────────────────────────────
// Widget default provider (persisted)
// ────────────────────────────────────────────────────────────────

const _kWidgetProviderKey = 'widget_default_provider';

/// Persists the user’s chosen transcription provider for the floating widget.
final widgetProviderNotifierProvider = StateNotifierProvider<
    WidgetProviderNotifier, TranscriptionProvider>(
  (ref) => WidgetProviderNotifier(),
);

/// Manages and persists the floating-widget’s default [TranscriptionProvider].
class WidgetProviderNotifier
    extends StateNotifier<TranscriptionProvider> {
  WidgetProviderNotifier() : super(TranscriptionProvider.local) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw   = prefs.getString(_kWidgetProviderKey);
    if (raw != null) {
      state = _fromRaw(raw);
    }
  }

  Future<void> setProvider(TranscriptionProvider provider) async {
    state = provider;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kWidgetProviderKey, _toRaw(provider));
  }

  static TranscriptionProvider _fromRaw(String raw) {
    switch (raw) {
      case 'openai_whisper': return TranscriptionProvider.openAIWhisper;
      case 'gemini_flash':   return TranscriptionProvider.geminiFlash;
      default:               return TranscriptionProvider.local;
    }
  }

  static String _toRaw(TranscriptionProvider p) {
    switch (p) {
      case TranscriptionProvider.openAIWhisper: return 'openai_whisper';
      case TranscriptionProvider.geminiFlash:   return 'gemini_flash';
      case TranscriptionProvider.local:         return 'local';
    }
  }
}
