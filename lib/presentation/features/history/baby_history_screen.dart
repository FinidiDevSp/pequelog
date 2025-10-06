import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/history/baby_history_state.dart';
import 'package:pequelog/presentation/features/history/widgets/action_filter_chips.dart';
import 'package:pequelog/presentation/features/history/widgets/action_day_group_widget.dart';

/// Screen displaying the complete history of baby actions with filters.
class BabyHistoryScreen extends StatefulWidget {
  /// Creates a history screen.
  const BabyHistoryScreen({super.key});

  @override
  State<BabyHistoryScreen> createState() => _BabyHistoryScreenState();
}

class _BabyHistoryScreenState extends State<BabyHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when near the bottom
      context.read<BabyHistoryState>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filters (sticky at top)
          Consumer<BabyHistoryState>(
            builder: (context, state, _) {
              return ActionFilterChips(
                selectedFilters: state.selectedFilters,
                onFilterToggle: (kind) => state.toggleFilter(kind),
                onClearFilters: () => state.clearFilters(),
              );
            },
          ),
          const Divider(height: 1),
          // Content
          Expanded(
            child: Consumer<BabyHistoryState>(
              builder: (context, state, _) {
                // Empty state
                if (state.isEmpty) {
                  return _buildEmptyState(context, state);
                }

                // Content with groups
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  itemCount: state.dayGroups.length + (state.hasMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Day groups
                    if (index < state.dayGroups.length) {
                      final group = state.dayGroups[index];
                      return ActionDayGroupWidget(
                        group: group,
                        onToggle: () => state.toggleDayGroup(group.date),
                        onActionTap: (actionId) => _onActionTap(actionId),
                      );
                    }

                    // Loading indicator at bottom
                    if (state.isLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Column(
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 8),
                              Text(
                                l10n.historyLoadingMore,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, BabyHistoryState state) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasFilters = state.hasActiveFilters;
    final title = hasFilters ? l10n.historyEmptyFilterMessage : l10n.historyEmptyTitle;
    final message = hasFilters ? '' : l10n.historyEmptyMessage;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.filter_list_off : Icons.history,
              size: 80,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (message.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _onActionTap(int actionId) {
    // TODO: Navigate to action detail/edit screen
    debugPrint('Action tapped: $actionId');
  }
}
