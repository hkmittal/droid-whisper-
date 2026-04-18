import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/enums/whisper_model.dart';

class LocalModelManager {
  LocalModelManager({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Models available from huggingface
  static const String _baseUrl = 'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/';

  Future<String> _getModelDir() async {
    final Directory directory = Platform.isAndroid
        ? await getApplicationSupportDirectory()
        : await getLibraryDirectory();
    return directory.path;
  }

  Future<String> getModelPath(LocalWhisperModel model) async {
    final dir = await _getModelDir();
    return '$dir/ggml-${model.id}.bin';
  }

  Future<bool> isModelDownloaded(LocalWhisperModel model) async {
    final path = await getModelPath(model);
    return File(path).existsSync();
  }

  Future<int> getLocalModelSizeBytes(LocalWhisperModel model) async {
    final path = await getModelPath(model);
    final file = File(path);
    if (!file.existsSync()) return 0;
    return file.lengthSync();
  }

  Future<void> deleteModel(LocalWhisperModel model) async {
    final path = await getModelPath(model);
    final file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
      _log.i('Deleted model: ${model.displayName}');
    }
  }

  /// Downloads the model with progress. Note: cancelToken allows cancelling mid-download.
  Future<void> downloadModel(
    LocalWhisperModel model, {
    required void Function(double progress) onProgress,
    CancelToken? cancelToken,
  }) async {
    final path = await getModelPath(model);
    final url = '${_baseUrl}ggml-${model.id}.bin';

    try {
      _log.i('Starting download for ${model.displayName} from $url');
      final tmpPath = '$path.tmp';

      await _dio.download(
        url,
        tmpPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            onProgress(progress);
          }
        },
      );

      // Rename tmp to actual when completely valid
      File(tmpPath).renameSync(path);
      _log.i('Completed download for ${model.displayName} to $path');
    } catch (e) {
      _log.e('Failed to download model ${model.displayName}', error: e);
      final tmpFile = File('$path.tmp');
      if (tmpFile.existsSync()) tmpFile.deleteSync();
      rethrow;
    }
  }
}
