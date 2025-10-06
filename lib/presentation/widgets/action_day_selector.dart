import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';

/// Shared selector that displays a day carousel with previous/next controls.
class ActionDaySelector extends StatelessWidget {
  /// Creates a reusable day selector carousel.
  const ActionDaySelector({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onPickDay,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.previousTooltip,
    required this.nextTooltip,
    required this.pickerTooltip,
    this.previousButtonKey,
    this.nextButtonKey,
  });

  /// Title displayed above the selector.
  final String label;

  /// Day currently highlighted by the carousel.
  final DateTime selectedDate;

  /// Callback triggered when the central day chip is tapped.
  final VoidCallback onPickDay;

  /// Callback for the previous day button.
  final VoidCallback onPreviousDay;

  /// Callback for the next day button.
  final VoidCallback onNextDay;

  /// Tooltip shown when hovering the previous button.
  final String previousTooltip;

  /// Tooltip shown when hovering the next button.
  final String nextTooltip;

  /// Tooltip displayed when tapping the central chip.
  final String pickerTooltip;

  /// Optional key for the previous button (useful in tests).
  final Key? previousButtonKey;

  /// Optional key for the next button (useful in tests).
  final Key? nextButtonKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final material = MaterialLocalizations.of(context);

    final dayLabel = _formatDayLabel(
      selectedDate,
      material,
      l10n,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                IconButton(
                  key: previousButtonKey,
                  tooltip: previousTooltip,
                  onPressed: onPreviousDay,
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Tooltip(
                    message: pickerTooltip,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onPickDay,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            dayLabel,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  key: nextButtonKey,
                  tooltip: nextTooltip,
                  onPressed: onNextDay,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _formatDayLabel(
    DateTime selectedDate,
    MaterialLocalizations material,
    AppLocalizations l10n,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final normalized = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final difference = normalized.difference(today).inDays;
    if (difference == 0) {
      return l10n.actionDayToday;
    }
    if (difference == -1) {
      return l10n.actionDayYesterday;
    }
    return material.formatMediumDate(selectedDate).toUpperCase();
  }
}

