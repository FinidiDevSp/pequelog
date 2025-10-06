import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/statistics/statistics_state.dart';
import 'package:pequelog/presentation/features/statistics/widgets/comparison_widget.dart';
import 'package:pequelog/presentation/features/statistics/widgets/daily_summary_cards.dart';
import 'package:pequelog/presentation/features/statistics/widgets/weekly_bar_chart.dart';
import 'package:provider/provider.dart';

/// Main statistics screen displaying daily summary, weekly charts, and comparisons
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statisticsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.statisticsRefresh,
            onPressed: () {
              context.read<StatisticsState>().reload();
            },
          ),
        ],
      ),
      body: Consumer<StatisticsState>(
        builder: (context, state, child) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => state.reload(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // Daily Summary Cards
                  DailySummaryCards(
                    metrics: state.todayMetrics,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Weekly Bar Chart
                  WeeklyBarChart(
                    data: state.weeklyData,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Comparison: Today vs Yesterday
                  ComparisonWidget(
                    todayMetrics: state.todayMetrics,
                    yesterdayMetrics: state.yesterdayMetrics,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Empty state for no data
                  if (state.todayMetrics.feedCount == 0 &&
                      state.todayMetrics.diaperCount == 0 &&
                      state.todayMetrics.bathCount == 0)
                    _EmptyState(l10n: l10n),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.l10n,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.show_chart,
              size: 64,
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.statisticsEmptyTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.statisticsEmptyMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
