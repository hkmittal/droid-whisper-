/// Widget that displays a [TranscriptionResult] in a scrollable, copyable
/// card with metadata chips (provider, language, duration, segments).
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/audio_utils.dart';
import '../../domain/models/transcription_result.dart';

/// Displays the full transcription result with metadata and copy support.
class TranscriptionResultCard extends StatelessWidget {
  const TranscriptionResultCard({super.key, required this.result});

  final TranscriptionResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header with copy button
            Row(
              children: [
                Icon(Icons.text_snippet_outlined,
                    color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Transcription',
                    style: theme.textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 20),
                  tooltip: 'Copy to clipboard',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: result.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
            const Divider(),

            // ── Metadata chips
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _MetaChip(
                  icon: Icons.smart_toy_outlined,
                  label: result.provider.displayName,
                ),
                if (result.language != null)
                  _MetaChip(
                    icon: Icons.language,
                    label: result.language!.toUpperCase(),
                  ),
                _MetaChip(
                  icon: Icons.timer_outlined,
                  label: AudioUtils.formatDuration(result.duration),
                ),
                if (result.segments.isNotEmpty)
                  _MetaChip(
                    icon: Icons.segment,
                    label: '${result.segments.length} segments',
                  ),
                if (result.confidence != null)
                  _MetaChip(
                    icon: Icons.verified_outlined,
                    label:
                        '${(result.confidence! * 100).toStringAsFixed(1)}% conf',
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Transcribed text (scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  result.text,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                ),
              ),
            ),

            // ── Segment timeline (if available)
            if (result.segments.isNotEmpty) ...[
              const Divider(),
              Text('Segments', style: theme.textTheme.labelMedium),
              const SizedBox(height: 4),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: result.segments.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final seg = result.segments[index];
                    return Chip(
                      avatar: CircleAvatar(
                        radius: 12,
                        child: Text(
                          '${seg.index + 1}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                      label: SizedBox(
                        width: 120,
                        child: Text(
                          seg.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Tiny metadata chip used inside the result card.
class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 11)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
