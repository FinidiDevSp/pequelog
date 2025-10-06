import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pequelog/core/utils/relative_time_formatter.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/l10n/app_localizations.dart';

/// A single timeline item displaying a baby action with visual timeline elements.
class ActionTimelineItem extends StatelessWidget {
  /// Creates a timeline item for a baby action.
  const ActionTimelineItem({
    required this.action,
    required this.isFirst,
    required this.isLast,
    this.onTap,
    super.key,
  });

  /// The action to display.
  final BabyAction action;

  /// Whether this is the first item in the timeline.
  final bool isFirst;

  /// Whether this is the last item in the timeline.
  final bool isLast;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final relativeTime = RelativeTimeFormatter.format(action.occurredAt, l10n);
    final absoluteTime = intl.DateFormat.Hm().format(action.occurredAt);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline visual (line + node)
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  // Top line (hidden for first item)
                  if (!isFirst)
                    Container(
                      width: 2,
                      height: 16,
                      color: colorScheme.outlineVariant,
                    ),
                  // Node circle
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getKindColor(colorScheme, action.kind),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.surface,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _getKindIcon(action.kind),
                        size: 8,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  // Bottom line (hidden for last item)
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time relative label (above card)
                  Text(
                    relativeTime,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Card with action details
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Absolute time + action type
                          Row(
                            children: [
                              Text(
                                absoluteTime,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _getKindLabel(l10n, action.kind),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          // Details (if any)
                          if (_getActionDetails(l10n, action).isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              _getActionDetails(l10n, action),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                          // Notes (if any)
                          if (action.notes != null && action.notes!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              action.notes!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getKindColor(ColorScheme colorScheme, BabyActionKind kind) {
    switch (kind) {
      case BabyActionKind.feed:
        return colorScheme.primaryContainer;
      case BabyActionKind.diaper:
        return colorScheme.secondaryContainer;
      case BabyActionKind.bath:
        return colorScheme.tertiaryContainer;
      case BabyActionKind.vomit:
        return colorScheme.errorContainer;
    }
  }

  IconData _getKindIcon(BabyActionKind kind) {
    switch (kind) {
      case BabyActionKind.feed:
        return Icons.restaurant;
      case BabyActionKind.diaper:
        return Icons.baby_changing_station;
      case BabyActionKind.bath:
        return Icons.bathtub;
      case BabyActionKind.vomit:
        return Icons.sick;
    }
  }

  String _getKindLabel(AppLocalizations l10n, BabyActionKind kind) {
    switch (kind) {
      case BabyActionKind.feed:
        return l10n.historyActionFeed;
      case BabyActionKind.diaper:
        return l10n.historyActionDiaper;
      case BabyActionKind.bath:
        return l10n.historyActionBath;
      case BabyActionKind.vomit:
        return l10n.historyActionVomit;
    }
  }

  String _getActionDetails(AppLocalizations l10n, BabyAction action) {
    final details = action.details;
    final parts = <String>[];

    switch (action.kind) {
      case BabyActionKind.feed:
        if (details['amountMl'] != null) {
          parts.add('${details['amountMl']} ml');
        }
        if (details['durationSeconds'] != null) {
          final duration = Duration(seconds: details['durationSeconds'] as int);
          final minutes = duration.inMinutes;
          if (minutes > 0) {
            parts.add('$minutes min');
          }
        }
        if (details['method'] != null) {
          parts.add(details['method'] as String);
        }
        break;
      case BabyActionKind.diaper:
        if (details['hasUrine'] == true) parts.add('💧 Orina');
        if (details['hasFeces'] == true) parts.add('💩 Heces');
        break;
      case BabyActionKind.bath:
        if (details['durationSeconds'] != null) {
          final duration = Duration(seconds: details['durationSeconds'] as int);
          final minutes = duration.inMinutes;
          if (minutes > 0) {
            parts.add('$minutes min');
          }
        }
        break;
      case BabyActionKind.vomit:
        if (details['severity'] != null) {
          parts.add(details['severity'] as String);
        }
        break;
    }

    return parts.join(' • ');
  }
}
