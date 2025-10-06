import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/statistics/statistics_state.dart';

/// Widget that displays a comparison between the current and previous period metrics
class ComparisonWidget extends StatelessWidget {
  const ComparisonWidget({
    required this.currentMetrics,
    required this.previousMetrics,
    required this.currentLabel,
    required this.previousLabel,
    required this.showTrends,
    super.key,
  });

  final DailyMetrics currentMetrics;
  final DailyMetrics previousMetrics;
  final String currentLabel;
  final String previousLabel;
  final bool showTrends;

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
                  todayValue: '${currentMetrics.feedCount}',
                  yesterdayValue: '${previousMetrics.feedCount}',
                  showTrend: showTrends,
                  currentLabel: currentLabel,
                  previousLabel: previousLabel,
                  colorScheme: colorScheme,
                ),
                const Divider(height: 24),
                _ComparisonRow(
                  label: l10n.statisticsVolume,
                  todayValue: '${_formatMl(currentMetrics.totalMl)}ml',
                  yesterdayValue: '${_formatMl(previousMetrics.totalMl)}ml',
                  showTrend: showTrends,
                  currentLabel: currentLabel,
                  previousLabel: previousLabel,
                  colorScheme: colorScheme,
                ),
                const Divider(height: 24),
                _ComparisonRow(
                  label: l10n.statisticsAveragePerFeed,
                  todayValue: currentMetrics.averageMl > 0
                      ? '${currentMetrics.averageMl.toStringAsFixed(0)}ml'
                      : '--',
                  yesterdayValue: previousMetrics.averageMl > 0
                      ? '${previousMetrics.averageMl.toStringAsFixed(0)}ml'
                      : '--',
                  showTrend: showTrends &&
                      currentMetrics.averageMl > 0 &&
                      previousMetrics.averageMl > 0,
                  currentLabel: currentLabel,
                  previousLabel: previousLabel,
                  colorScheme: colorScheme,
                ),
                const Divider(height: 24),
                _ComparisonRow(
                  label: l10n.statisticsDiapersTitle,
                  todayValue: '${currentMetrics.diaperCount}',
                  yesterdayValue: '${previousMetrics.diaperCount}',
                  showTrend: showTrends,
                  currentLabel: currentLabel,
                  previousLabel: previousLabel,
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
    required this.currentLabel,
    required this.previousLabel,
    required this.colorScheme,
  });

  final String label;
  final String todayValue;
  final String yesterdayValue;
  final bool showTrend;
  final String currentLabel;
  final String previousLabel;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                currentLabel,
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
                previousLabel,
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

String _formatMl(double value) {
  return value.truncateToDouble() == value
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}
