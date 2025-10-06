import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/statistics/statistics_state.dart';

/// Widget that displays a comparison between today's and yesterday's metrics
class ComparisonWidget extends StatelessWidget {
  const ComparisonWidget({
    required this.todayMetrics,
    required this.yesterdayMetrics,
    super.key,
  });

  final DailyMetrics todayMetrics;
  final DailyMetrics yesterdayMetrics;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            l10n.statisticsComparisonTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
          color: colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _ComparisonRow(
                  label: l10n.statisticsFeedingTitle,
                  todayValue: '${todayMetrics.feedCount}',
                  yesterdayValue: '${yesterdayMetrics.feedCount}',
                  showTrend: true,
                  colorScheme: colorScheme,
                ),
                const Divider(height: 24),
                _ComparisonRow(
                  label: l10n.statisticsVolume,
                  todayValue: '${todayMetrics.totalMl}ml',
                  yesterdayValue: '${yesterdayMetrics.totalMl}ml',
                  showTrend: true,
                  colorScheme: colorScheme,
                ),
                const Divider(height: 24),
                _ComparisonRow(
                  label: l10n.statisticsAveragePerFeed,
                  todayValue: todayMetrics.averageMl > 0
                      ? '${todayMetrics.averageMl.toStringAsFixed(0)}ml'
                      : '--',
                  yesterdayValue: yesterdayMetrics.averageMl > 0
                      ? '${yesterdayMetrics.averageMl.toStringAsFixed(0)}ml'
                      : '--',
                  showTrend: todayMetrics.averageMl > 0 && yesterdayMetrics.averageMl > 0,
                  colorScheme: colorScheme,
                ),
                const Divider(height: 24),
                _ComparisonRow(
                  label: l10n.statisticsDiapersTitle,
                  todayValue: '${todayMetrics.diaperCount}',
                  yesterdayValue: '${yesterdayMetrics.diaperCount}',
                  showTrend: true,
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.label,
    required this.todayValue,
    required this.yesterdayValue,
    required this.showTrend,
    required this.colorScheme,
  });

  final String label;
  final String todayValue;
  final String yesterdayValue;
  final bool showTrend;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Parse numeric values for trend calculation
    final todayNum = _parseNumber(todayValue);
    final yesterdayNum = _parseNumber(yesterdayValue);

    Widget? trendIcon;
    Color? trendColor;

    if (showTrend && todayNum != null && yesterdayNum != null) {
      if (todayNum > yesterdayNum) {
        trendIcon = Icon(Icons.trending_up, size: 20, color: colorScheme.primary);
        trendColor = colorScheme.primary;
      } else if (todayNum < yesterdayNum) {
        trendIcon = Icon(Icons.trending_down, size: 20, color: colorScheme.error);
        trendColor = colorScheme.error;
      } else {
        trendIcon = Icon(Icons.trending_flat, size: 20, color: colorScheme.onSurfaceVariant);
        trendColor = colorScheme.onSurfaceVariant;
      }
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                todayValue,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: trendColor,
                ),
              ),
              Text(
                l10n.statisticsToday,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (trendIcon != null) ...[
          const SizedBox(width: 8),
          trendIcon,
        ],
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                yesterdayValue,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                l10n.statisticsYesterday,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double? _parseNumber(String value) {
    // Remove 'ml' suffix and other non-numeric characters except '.'
    final cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned);
  }
}
