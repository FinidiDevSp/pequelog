import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/statistics/statistics_state.dart';

/// Widget that displays a weekly bar chart for feeding statistics
class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({
    required this.data,
    super.key,
  });

  final List<WeeklyData> data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    // Find max value for scaling
    final maxMl = data.fold<double>(
      0,
      (max, item) => item.totalMl > max ? item.totalMl : max,
    );
    final maxCount = data.fold<int>(
      0,
      (max, item) => item.feedCount > max ? item.feedCount : max,
    );

    final locale = Localizations.localeOf(context);
    final formatter = intl.DateFormat.Md(locale.toLanguageTag());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            l10n.statisticsTrendChartTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(
                color: colorScheme.primary,
                label: l10n.statisticsVolume,
              ),
              const SizedBox(width: 24),
              _LegendItem(
                color: colorScheme.secondary,
                label: l10n.statisticsFeeds,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Bar chart
        SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const barWidth = 56.0;
                final contentWidth = barWidth * data.length;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: contentWidth <= constraints.maxWidth
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.start,
                      children: data.map((dayData) {
                        final label = formatter.format(dayData.date);
                        return SizedBox(
                          width: barWidth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: _BarItem(
                              dayLabel: label,
                              mlValue: dayData.totalMl,
                              countValue: dayData.feedCount,
                              maxMl: maxMl,
                              maxCount: maxCount,
                              primaryColor: colorScheme.primary,
                              secondaryColor: colorScheme.secondary,
                              isToday: _isToday(dayData.date),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.dayLabel,
    required this.mlValue,
    required this.countValue,
    required this.maxMl,
    required this.maxCount,
    required this.primaryColor,
    required this.secondaryColor,
    required this.isToday,
  });

  final String dayLabel;
  final double mlValue;
  final int countValue;
  final double maxMl;
  final int maxCount;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate heights (min 10% for visibility, max 100%)
    final mlHeight = maxMl > 0 ? (mlValue / maxMl * 0.9 + 0.1) : 0.0;
    final countHeight = maxCount > 0 ? (countValue / maxCount * 0.9 + 0.1) : 0.0;

    // Use the larger of the two for the overall height
    final barHeight = mlHeight > countHeight ? mlHeight : countHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Values above bars
        if (mlValue > 0 || countValue > 0) ...[
          Column(
            children: [
              if (mlValue > 0)
                Text(
                  '${_formatMl(mlValue)}ml',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (countValue > 0)
                Text(
                  '$countValue',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        // Bars container
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: barHeight.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor,
                      secondaryColor,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                  border: isToday
                      ? Border.all(
                          color: colorScheme.onSurface,
                          width: 2,
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Day label
        Text(
          dayLabel,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

String _formatMl(double value) {
  return value.truncateToDouble() == value
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}
