import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/transcription_provider.dart';
import '../../../../core/enums/whisper_model.dart';
import '../providers/local_models_provider.dart';
import '../providers/transcription_providers.dart';

class LocalModelsScreen extends ConsumerWidget {
  const LocalModelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final modelsMap = ref.watch(localModelsMapProvider);
    final currentConfig = ref.watch(configProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Models Marketplace'),
      ),
      body: modelsMap.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: LocalWhisperModel.values.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final model = LocalWhisperModel.values[index];
                final state = modelsMap[model] ?? const ModelDownloadState(status: DownloadStatus.notDownloaded);
                final isActive = currentConfig.modelName == model.id;

                return _ModelListTile(
                  model: model,
                  state: state,
                  isActive: isActive,
                  onDownload: () => ref.read(localModelsMapProvider.notifier).downloadModel(model),
                  onCancel: () => ref.read(localModelsMapProvider.notifier).cancelDownload(model),
                  onDelete: () => _confirmDelete(context, ref, model),
                  onSelect: () {
                    // Switch to Local provider if not already
                    ref.read(configProvider.notifier).setProvider(
                          TranscriptionProvider.local,
                        );
                    ref.read(configProvider.notifier).setModelName(model.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${model.displayName} activated!')),
                    );
                  },
                );
              },
            ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, LocalWhisperModel model) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Model?'),
        content: Text('Are you sure you want to delete the ${model.displayName} model? You will need to download it again to use it.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (delete == true) {
      ref.read(localModelsMapProvider.notifier).deleteModel(model);
      // If active model is deleted, revert to base or null
      if (ref.read(configProvider).modelName == model.id) {
        ref.read(configProvider.notifier).setModelName('base');
      }
    }
  }
}

class _ModelListTile extends StatelessWidget {
  const _ModelListTile({
    required this.model,
    required this.state,
    required this.isActive,
    required this.onDownload,
    required this.onCancel,
    required this.onDelete,
    required this.onSelect,
  });

  final LocalWhisperModel model;
  final ModelDownloadState state;
  final bool isActive;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onDelete;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget trailingObj;
    switch (state.status) {
      case DownloadStatus.notDownloaded:
        trailingObj = IconButton.filledTonal(
          icon: const Icon(Icons.download_rounded),
          onPressed: onDownload,
          tooltip: 'Download ${model.displayName}',
        );
        break;
      case DownloadStatus.downloading:
        trailingObj = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${(state.progress * 100).toInt()}%', style: theme.textTheme.bodySmall),
            const SizedBox(width: 8),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(value: state.progress, strokeWidth: 3),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onCancel,
              tooltip: 'Cancel Download',
            ),
          ],
        );
        break;
      case DownloadStatus.downloaded:
        trailingObj = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              color: theme.colorScheme.error,
              tooltip: 'Delete Model',
            ),
            FilledButton.tonal(
              onPressed: isActive ? null : onSelect,
              child: Text(isActive ? 'Active' : 'Select'),
            ),
          ],
        );
        break;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(model.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(model.description),
          const SizedBox(height: 4),
          Text(
            state.status == DownloadStatus.downloaded 
               ? 'Size: ${(state.fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB'
               : 'Est. Size: ${model.estimatedSizeString}',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
          ),
        ],
      ),
      trailing: trailingObj,
      isThreeLine: true,
      tileColor: isActive ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
    );
  }
}
