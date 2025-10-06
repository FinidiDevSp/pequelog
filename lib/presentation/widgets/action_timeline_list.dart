import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/app_settings.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';
import 'package:pequelog/presentation/widgets/action_timeline_item.dart';

/// Widget displaying a timeline list of recent baby actions with configurable limit.
class ActionTimelineList extends StatefulWidget {
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
  State<ActionTimelineList> createState() => _ActionTimelineListState();
}

class _ActionTimelineListState extends State<ActionTimelineList> {
  Timer? _updateTimer;
  int _updateKey = 0;

  @override
  void initState() {
    super.initState();
    // Timer to update relative times every minute
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {
          _updateKey++;
        });
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settings = context.watch<AppSettings>();
    final actionsState = context.watch<BabyActionsState>();

    // Calculate today's average
    final todayActions = widget.actions.where((action) {
      final now = DateTime.now();
      final actionDate = action.occurredAt;
      return actionDate.year == now.year &&
          actionDate.month == now.month &&
          actionDate.day == now.day;
    }).length;

    return RefreshIndicator(
      onRefresh: () async {
        await actionsState.reload();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Card(
          margin: const EdgeInsets.all(16),
          color: colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with title, badge, and limit selector
                Row(
                  children: [
                    Text(
                      l10n.timelineRecentActions,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (todayActions > 0) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Hoy: $todayActions',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
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
                if (widget.actions.isEmpty)
                  _buildEmptyState(context, l10n, colorScheme)
                else
                  _buildTimeline(context, widget.actions),
                // View full history button
                if (widget.actions.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: widget.onViewHistory,
                    icon: const Icon(Icons.history),
                    label: Text(l10n.timelineViewFullHistory),
                  ),
                ],
              ],
            ),
          ),
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
              previousAction: i < actions.length - 1 ? actions[i + 1] : null,
              isFirst: i == 0,
              isLast: i == actions.length - 1,
              onTap: () => widget.onActionTap(actions[i]),
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
