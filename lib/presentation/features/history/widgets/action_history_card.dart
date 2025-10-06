import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/l10n/app_localizations.dart';

/// A card displaying a single action in the history list.
class ActionHistoryCard extends StatelessWidget {
  /// Creates an action history card.
  const ActionHistoryCard({
    required this.action,
    this.onTap,
    super.key,
  });

  /// The action to display.
  final BabyAction action;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getKindColor(colorScheme, action.kind),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getKindIcon(action.kind),
                  size: 20,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time and kind
                    Row(
                      children: [
                        Text(
                          intl.DateFormat.Hm().format(action.occurredAt),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getKindLabel(l10n, action.kind),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Details
                    Text(
                      _getActionDetails(l10n, action),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Notes (if any)
                    if (action.notes != null && action.notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        action.notes!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
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
        return Icons.restaurant_outlined;
      case BabyActionKind.diaper:
        return Icons.baby_changing_station_outlined;
      case BabyActionKind.bath:
        return Icons.bathtub_outlined;
      case BabyActionKind.vomit:
        return Icons.sick_outlined;
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
        if (details['hasUrine'] == true) parts.add('💧');
        if (details['hasFeces'] == true) parts.add('💩');
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

    return parts.isEmpty ? '—' : parts.join(' • ');
  }
}
