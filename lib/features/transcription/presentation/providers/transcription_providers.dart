/// Central Riverpod provider declarations for the transcription feature.
///
/// These are plain providers (no code‑gen) for clarity — migrate to
/// `riverpod_generator` annotations when the team is ready.
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

/// Manages the user’s transcription preferences and persists them securely.
class ConfigNotifier extends StateNotifier<TranscriptionConfig> {
  ConfigNotifier()
      : super(
          TranscriptionConfig(
            provider: _defaultProvider(),
            language: dotenv.env['DEFAULT_LANGUAGE'],
            openAIApiKey: dotenv.env['OPENAI_API_KEY'],
            geminiApiKey: dotenv.env['GEMINI_API_KEY'],
          ),
        ) {
    _loadFromDisk();
  }

  static const _kProviderKey = 'default_provider';
  static const _kLanguageKey = 'language';
  static const _kModelNameKey = 'model_name';
  static const _kOpenAIApiKey = 'openai_api_key';
  static const _kGeminiApiKey = 'gemini_api_key';

  final _secureStorage = const FlutterSecureStorage();

  Future<void> _loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final openaiKey = await _secureStorage.read(key: _kOpenAIApiKey);
    final geminiKey = await _secureStorage.read(key: _kGeminiApiKey);
    
    final rawProv = prefs.getString(_kProviderKey) ?? '';
    final prov = _isValidProvider(rawProv) ? _fromRaw(rawProv) : _defaultProvider();
    
    state = state.copyWith(
      provider: prov,
      language: prefs.getString(_kLanguageKey) ?? state.language,
      modelName: prefs.getString(_kModelNameKey) ?? state.modelName,
      openAIApiKey: (openaiKey?.isNotEmpty == true) ? openaiKey : state.openAIApiKey,
      geminiApiKey: (geminiKey?.isNotEmpty == true) ? geminiKey : state.geminiApiKey,
    );
  }

  static TranscriptionProvider _defaultProvider() {
    final raw = dotenv.env['DEFAULT_PROVIDER'] ?? 'local';
    return _isValidProvider(raw) ? _fromRaw(raw) : TranscriptionProvider.local;
  }

  static bool _isValidProvider(String raw) {
    return raw == 'openai_whisper' || raw == 'gemini_flash' || raw == 'local';
  }

  static TranscriptionProvider _fromRaw(String raw) {
    switch (raw) {
      case 'openai_whisper':
        return TranscriptionProvider.openAIWhisper;
      case 'gemini_flash':
        return TranscriptionProvider.geminiFlash;
      default:
        return TranscriptionProvider.local;
    }
  }

  static String _toRaw(TranscriptionProvider p) {
    switch (p) {
      case TranscriptionProvider.openAIWhisper:
        return 'openai_whisper';
      case TranscriptionProvider.geminiFlash:
        return 'gemini_flash';
      case TranscriptionProvider.local:
        return 'local';
    }
  }

  Future<void> setProvider(TranscriptionProvider provider) async {
    state = state.copyWith(provider: provider);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kProviderKey, _toRaw(provider));
  }

  Future<void> setLanguage(String? language) async {
    state = state.copyWith(language: language);
    final prefs = await SharedPreferences.getInstance();
    if (language == null) {
      await prefs.remove(_kLanguageKey);
    } else {
      await prefs.setString(_kLanguageKey, language);
    }
  }

  Future<void> setOpenAIApiKey(String? key) async {
    state = state.copyWith(openAIApiKey: key);
    if (key == null || key.isEmpty) {
      await _secureStorage.delete(key: _kOpenAIApiKey);
    } else {
      await _secureStorage.write(key: _kOpenAIApiKey, value: key);
    }
  }

  Future<void> setGeminiApiKey(String? key) async {
    state = state.copyWith(geminiApiKey: key);
    if (key == null || key.isEmpty) {
      await _secureStorage.delete(key: _kGeminiApiKey);
    } else {
      await _secureStorage.write(key: _kGeminiApiKey, value: key);
    }
  }

  Future<void> setModelName(String? name) async {
    state = state.copyWith(modelName: name);
    final prefs = await SharedPreferences.getInstance();
    if (name == null) {
      await prefs.remove(_kModelNameKey);
    } else {
      await prefs.setString(_kModelNameKey, name);
    }
  }

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
    preferBluetoothMic: ref.watch(preferBluetoothMicProvider),
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
// Bluetooth / Audio Source Config
// ────────────────────────────────────────────────────────────────

/// Provides the user's preference for using the Bluetooth microphone (AudioSource.voiceCommunication).
final preferBluetoothMicProvider =
    StateNotifierProvider<PreferBluetoothMicNotifier, bool>((ref) {
  return PreferBluetoothMicNotifier();
});

class PreferBluetoothMicNotifier extends StateNotifier<bool> {
  PreferBluetoothMicNotifier() : super(false) {
    _load();
  }

  static const _kKey = 'prefer_bluetooth_mic';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_kKey) ?? false;
  }

  Future<void> setPreferBluetooth(bool prefer) async {
    state = prefer;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kKey, prefer);
  }
}
