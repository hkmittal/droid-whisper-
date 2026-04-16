/// Horizontal chip row that lets the user quickly switch between
/// transcription providers.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/transcription_provider.dart';
import '../providers/transcription_providers.dart';

/// Displays a row of [ChoiceChip]s — one per [TranscriptionProvider].
class ProviderSelectorWidget extends ConsumerWidget {
  const ProviderSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentProvider = ref.watch(configProvider).provider;
    final notifier = ref.read(configProvider.notifier);
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      alignment: WrapAlignment.center,
      children: TranscriptionProvider.values.map((provider) {
        final selected = provider == currentProvider;
        return ChoiceChip(
          label: Text(
            provider.displayName,
            style: TextStyle(
              fontSize: 12,
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          avatar: Icon(
            _iconFor(provider),
            size: 18,
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
          ),
          selected: selected,
          selectedColor: theme.colorScheme.primary,
          onSelected: (_) => notifier.setProvider(provider),
        );
      }).toList(),
    );
  }

  IconData _iconFor(TranscriptionProvider p) => switch (p) {
        TranscriptionProvider.local => Icons.phone_android_rounded,
        TranscriptionProvider.openAIWhisper => Icons.cloud_outlined,
        TranscriptionProvider.geminiFlash => Icons.auto_awesome_outlined,
      };
}
