import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/app_settings.dart';
import 'package:pequelog/presentation/widgets/action_timeline_item.dart';

/// Widget displaying a timeline list of recent baby actions with configurable limit.
class ActionTimelineList extends StatelessWidget {
  /// Creates a timeline list widget.
  const ActionTimelineList({
    required this.actions,
    required this.onActionTap,
    required this.onViewHistory,
    super.key,
  });

  /// List of actions to display.
  final List<BabyAction> actions;

  /// Callback when an action is tapped.
  final ValueChanged<BabyAction> onActionTap;

  /// Callback when "View full history" button is tapped.
  final VoidCallback onViewHistory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settings = context.watch<AppSettings>();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with title and limit selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.timelineRecentActions,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Limit selector dropdown
                _LimitSelector(
                  currentLimit: settings.recentActionsLimit,
                  onLimitChanged: (limit) {
                    settings.setRecentActionsLimit(limit);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Timeline list or empty state
            if (actions.isEmpty)
              _buildEmptyState(context, l10n, colorScheme)
            else
              _buildTimeline(context, actions),
            // View full history button
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onViewHistory,
                icon: const Icon(Icons.history),
                label: Text(l10n.timelineViewFullHistory),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(
            Icons.timeline,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.timelineNoActions,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, List<BabyAction> actions) {
    return Column(
      children: [
        for (var i = 0; i < actions.length; i++)
          SizedBox(
            height: i == actions.length - 1 ? null : 120,
            child: ActionTimelineItem(
              action: actions[i],
              isFirst: i == 0,
              isLast: i == actions.length - 1,
              onTap: () => onActionTap(actions[i]),
            ),
          ),
      ],
    );
  }
}

/// Dropdown selector for the number of recent actions to display.
class _LimitSelector extends StatelessWidget {
  const _LimitSelector({
    required this.currentLimit,
    required this.onLimitChanged,
  });

  final int currentLimit;
  final ValueChanged<int> onLimitChanged;

  static const List<int> _limits = [3, 5, 10, 15];
  static const int _showAllValue = -1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return DropdownButton<int>(
      value: currentLimit > 15 ? _showAllValue : currentLimit,
      underline: const SizedBox.shrink(),
      icon: const Icon(Icons.arrow_drop_down),
      style: theme.textTheme.bodyMedium,
      items: [
        ..._limits.map((limit) {
          return DropdownMenuItem<int>(
            value: limit,
            child: Text(l10n.timelineShowCount(limit)),
          );
        }),
        DropdownMenuItem<int>(
          value: _showAllValue,
          child: Text(l10n.timelineShowAll),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          // "Show All" maps to a large number (e.g., 100)
          onLimitChanged(value == _showAllValue ? 100 : value);
        }
      },
    );
  }
}
