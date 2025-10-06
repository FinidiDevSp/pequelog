import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/statistics/statistics_state.dart';
import 'package:pequelog/presentation/features/statistics/widgets/metric_card.dart';

/// Widget that displays daily summary cards with key metrics
class DailySummaryCards extends StatelessWidget {
  const DailySummaryCards({
    required this.metrics,
    required this.title,
    this.subtitle,
    super.key,
  });

  final DailyMetrics metrics;
  final String title;
  final String? subtitle;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Grid of metric cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Responsive: 2 columns on narrow screens, 4 on wide screens
              final isWide = constraints.maxWidth > 600;
              final crossAxisCount = isWide ? 4 : 2;
              final childAspectRatio = isWide ? 1.1 : 0.9;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: childAspectRatio,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Feeding card
                  MetricCard(
                    icon: Icons.restaurant,
                    title: l10n.statisticsFeedingTitle,
                    mainValue: _formatMl(metrics.totalMl),
                    mainLabel: 'ml',
                    secondaryValue: metrics.feedCount > 0
                        ? l10n.statisticsFeedingCount(metrics.feedCount)
                        : null,
                    secondaryLabel: metrics.feedCount > 0 && metrics.averageMl > 0
                        ? '• ${l10n.statisticsAverage}: ${metrics.averageMl.toStringAsFixed(0)}ml'
                        : null,
                    color: colorScheme.primaryContainer,
                  ),
                  // Diapers card
                  MetricCard(
                    icon: Icons.child_care,
                    title: l10n.statisticsDiapersTitle,
                    mainValue: '${metrics.diaperCount}',
                    mainLabel: l10n.statisticsDiapersLabel,
                    secondaryValue: metrics.diaperCount > 0
                        ? '${metrics.fecesCount} ${l10n.statisticsFeces}'
                        : null,
                    secondaryLabel: metrics.diaperCount > 0
                        ? '• ${metrics.urineCount} ${l10n.statisticsUrine}'
                        : null,
                    color: colorScheme.secondaryContainer,
                  ),
                  // Baths card
                  MetricCard(
                    icon: Icons.bathtub,
                    title: l10n.statisticsBathsTitle,
                    mainValue: '${metrics.bathCount}',
                    mainLabel: metrics.bathCount == 1
                        ? l10n.statisticsBathSingular
                        : l10n.statisticsBathPlural,
                    secondaryValue: metrics.vomitCount > 0
                        ? l10n.statisticsVomitCount(metrics.vomitCount)
                        : null,
                    color: colorScheme.tertiaryContainer,
                  ),
                  // Intervals card
                  MetricCard(
                    icon: Icons.schedule,
                    title: l10n.statisticsIntervalsTitle,
                    mainValue: metrics.averageInterval != null
                        ? _formatDuration(metrics.averageInterval!)
                        : '--',
                    mainLabel: l10n.statisticsAverageInterval,
                    secondaryValue: metrics.minInterval != null && metrics.maxInterval != null
                        ? '${_formatDuration(metrics.minInterval!)} - ${_formatDuration(metrics.maxInterval!)}'
                        : null,
                    secondaryLabel: metrics.minInterval != null
                        ? l10n.statisticsRange
                        : null,
                    color: colorScheme.primaryContainer.withOpacity(0.7),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}min';
    } else {
      return '${minutes}min';
    }
  }
}

String _formatMl(double value) {
  return value.truncateToDouble() == value
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}
