import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/whisper_model.dart';
import '../../data/services/local_model_manager.dart';

enum DownloadStatus { notDownloaded, downloading, downloaded }

class ModelDownloadState {
  const ModelDownloadState({
    required this.status,
    this.progress = 0.0,
    this.fileSizeBytes = 0,
  });

  final DownloadStatus status;
  final double progress;
  final int fileSizeBytes;

  ModelDownloadState copyWith({
    DownloadStatus? status,
    double? progress,
    int? fileSizeBytes,
  }) {
    return ModelDownloadState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
    );
  }
}

final localModelManagerProvider = Provider<LocalModelManager>((ref) {
  return LocalModelManager();
});

final localModelsMapProvider = StateNotifierProvider<LocalModelsNotifier, Map<LocalWhisperModel, ModelDownloadState>>((ref) {
  return LocalModelsNotifier(ref.watch(localModelManagerProvider));
});

class LocalModelsNotifier extends StateNotifier<Map<LocalWhisperModel, ModelDownloadState>> {
  LocalModelsNotifier(this._manager) : super({}) {
    _init();
  }

  final LocalModelManager _manager;
  final Map<LocalWhisperModel, CancelToken> _cancelTokens = {};

  Future<void> _init() async {
    final Map<LocalWhisperModel, ModelDownloadState> initialState = {};
    for (final model in LocalWhisperModel.values) {
      final isDownloaded = await _manager.isModelDownloaded(model);
      if (isDownloaded) {
        final size = await _manager.getLocalModelSizeBytes(model);
        initialState[model] = ModelDownloadState(status: DownloadStatus.downloaded, fileSizeBytes: size);
      } else {
        initialState[model] = const ModelDownloadState(status: DownloadStatus.notDownloaded);
      }
    }
    if (mounted) state = initialState;
  }

  Future<void> downloadModel(LocalWhisperModel model) async {
    if (state[model]?.status == DownloadStatus.downloading) return;

    final cancelToken = CancelToken();
    _cancelTokens[model] = cancelToken;

    state = {
      ...state,
      model: const ModelDownloadState(status: DownloadStatus.downloading, progress: 0.0),
    };

    try {
      await _manager.downloadModel(
        model,
        cancelToken: cancelToken,
        onProgress: (progress) {
          if (mounted) {
            state = {
              ...state,
              model: ModelDownloadState(status: DownloadStatus.downloading, progress: progress),
            };
          }
        },
      );
      
      final size = await _manager.getLocalModelSizeBytes(model);
      if (mounted) {
        state = {
          ...state,
          model: ModelDownloadState(status: DownloadStatus.downloaded, fileSizeBytes: size),
        };
      }
    } catch (e) {
      // Revert if cancelled or failed
      if (mounted) {
        state = {
          ...state,
          model: const ModelDownloadState(status: DownloadStatus.notDownloaded),
        };
      }
    } finally {
      _cancelTokens.remove(model);
    }
  }

  void cancelDownload(LocalWhisperModel model) {
    _cancelTokens[model]?.cancel();
    _cancelTokens.remove(model);
  }

  Future<void> deleteModel(LocalWhisperModel model) async {
    await _manager.deleteModel(model);
    state = {
      ...state,
      model: const ModelDownloadState(status: DownloadStatus.notDownloaded),
    };
  }
  
  @override
  void dispose() {
    for (var token in _cancelTokens.values) {
      token.cancel();
    }
    super.dispose();
  }
}
