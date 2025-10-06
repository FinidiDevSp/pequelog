import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/history/baby_history_state.dart'
    as history_state;
import 'package:pequelog/presentation/features/history/widgets/action_history_card.dart';

/// A collapsible group of actions for a single day.
class ActionDayGroupWidget extends StatelessWidget {
  /// Creates a day group widget.
  const ActionDayGroupWidget({
    required this.group,
    required this.onToggle,
    required this.onActionTap,
    super.key,
  });

  /// The day group data.
  final history_state.ActionDayGroup group;

  /// Callback when the group is toggled.
  final VoidCallback onToggle;

  /// Callback when an action card is tapped.
  final Function(int actionId) onActionTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dayLabel = _formatDayLabel(l10n, group.date);
    final count = group.actions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Material(
          color: colorScheme.surfaceContainerHighest,
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              onToggle();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayLabel,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.historyDayCount(count),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: group.isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Actions list
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: group.isExpanded
              ? Column(
                  children: [
                    const SizedBox(height: 8),
                    ...group.actions.map((action) {
                      return ActionHistoryCard(
                        action: action,
                        onTap: () => onActionTap(action.id),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  String _formatDayLabel(AppLocalizations l10n, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) {
      return l10n.historyDayToday;
    } else if (date == yesterday) {
      return l10n.historyDayYesterday;
    } else {
      // Format as "LUNES 6 DE OCTUBRE"
      final formatted = intl.DateFormat.yMMMEd().format(date);
      return formatted.toUpperCase();
    }
  }
}
