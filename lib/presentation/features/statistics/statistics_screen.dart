import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
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

          final locale = Localizations.localeOf(context);
          final dateFormatter = intl.DateFormat.yMMMd(locale.toLanguageTag());
          final currentRangeText =
              '${dateFormatter.format(state.currentRangeStart)} – ${dateFormatter.format(_stripTime(state.currentRangeEnd))}';
          final previousRangeText = state.previousRangeStart != null &&
                  state.previousRangeEnd != null
              ? '${dateFormatter.format(_stripTime(state.previousRangeStart!))} – ${dateFormatter.format(_stripTime(state.previousRangeEnd!))}'
              : null;

          final currentLabel = '${l10n.statisticsCurrentPeriod}\n$currentRangeText';
          final previousLabel = previousRangeText != null
              ? '${l10n.statisticsPreviousPeriod}\n$previousRangeText'
              : l10n.statisticsPreviousPeriod;

          return RefreshIndicator(
            onRefresh: () => state.reload(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  _StatisticsFilterBar(l10n: l10n),

                  const SizedBox(height: 16),

                  // Daily Summary Cards
                  DailySummaryCards(
                    metrics: state.currentPeriodMetrics,
                    title: l10n.statisticsPeriodSummary,
                    subtitle: l10n.statisticsRangeLabel(currentRangeText),
                  ),

                  const SizedBox(height: 32),

                  // Weekly Bar Chart
                  WeeklyBarChart(
                    data: state.weeklyData,
                  ),

                  const SizedBox(height: 32),

                  // Comparison: Today vs Yesterday
                  if (state.hasPreviousPeriod)
                    ComparisonWidget(
                      currentMetrics: state.currentPeriodMetrics,
                      previousMetrics: state.previousPeriodMetrics,
                      currentLabel: currentLabel,
                      previousLabel: previousLabel,
                      showTrends: state.hasPreviousPeriod,
                    ),

                  const SizedBox(height: 32),

                  // Empty state for no data
                  if (state.currentPeriodMetrics.feedCount == 0 &&
                      state.currentPeriodMetrics.diaperCount == 0 &&
                      state.currentPeriodMetrics.bathCount == 0)
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

  DateTime _stripTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}

class _StatisticsFilterBar extends StatelessWidget {
  const _StatisticsFilterBar({
    required this.l10n,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<StatisticsState>();
    final locale = Localizations.localeOf(context);
    final dateFormatter = intl.DateFormat.yMMMd(locale.toLanguageTag());
    final customLabel = state.customStartDate != null
        ? dateFormatter.format(state.customStartDate!)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<StatisticsRange>(
            segments: [
              ButtonSegment(
                value: StatisticsRange.last7Days,
                label: Tooltip(
                  message: l10n.statisticsRangeLast7Days,
                  child: const Icon(
                    Icons.calendar_view_week_outlined,
                    size: 20,
                  ),
                ),
              ),
              ButtonSegment(
                value: StatisticsRange.last14Days,
                label: Tooltip(
                  message: l10n.statisticsRangeLast14Days,
                  child: const Icon(
                    Icons.calendar_view_month_outlined,
                    size: 20,
                  ),
                ),
              ),
              ButtonSegment(
                value: StatisticsRange.last30Days,
                label: Tooltip(
                  message: l10n.statisticsRangeLast30Days,
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                  ),
                ),
              ),
              ButtonSegment(
                value: StatisticsRange.custom,
                label: Tooltip(
                  message: l10n.statisticsRangeCustom,
                  child: const Icon(
                    Icons.edit_calendar_outlined,
                    size: 20,
                  ),
                ),
              ),
            ],
            selected: <StatisticsRange>{state.selectedRange},
            onSelectionChanged: (selection) async {
              final selected = selection.first;
              await context.read<StatisticsState>().updateRange(selected);
            },
          ),
          if (state.selectedRange == StatisticsRange.custom)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Wrap(
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilledButton.tonal(
                    onPressed: () async {
                      final now = DateTime.now();
                      final initialDate = state.customStartDate ?? state.currentRangeStart;
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(now.year - 2),
                        lastDate: now,
                        helpText: l10n.statisticsSelectStartDate,
                      );
                      if (pickedDate != null) {
                        await context
                            .read<StatisticsState>()
                            .updateCustomStartDate(pickedDate);
                      }
                    },
                    child: Text(l10n.statisticsSelectStartDate),
                  ),
                  if (customLabel != null)
                    Text(
                      l10n.statisticsCustomStartLabel(customLabel),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
        ],
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
