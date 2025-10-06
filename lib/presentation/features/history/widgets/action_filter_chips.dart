import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/l10n/app_localizations.dart';

/// Horizontal scrollable filter chips for action types.
class ActionFilterChips extends StatelessWidget {
  /// Creates a filter chips widget.
  const ActionFilterChips({
    required this.selectedFilters,
    required this.onFilterToggle,
    required this.onClearFilters,
    super.key,
  });

  /// Currently selected filters.
  final Set<BabyActionKind> selectedFilters;

  /// Callback when a filter is toggled.
  final ValueChanged<BabyActionKind> onFilterToggle;

  /// Callback when all filters are cleared.
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final allSelected = selectedFilters.isEmpty;

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All" chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(l10n.historyFilterAll),
              selected: allSelected,
              onSelected: (_) {
                HapticFeedback.selectionClick();
                onClearFilters();
              },
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.onPrimaryContainer,
            ),
          ),
          // Individual filter chips
          ...BabyActionKind.values.map((kind) {
            final isSelected = selectedFilters.contains(kind);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_getKindLabel(l10n, kind)),
                selected: isSelected,
                onSelected: (_) {
                  HapticFeedback.selectionClick();
                  onFilterToggle(kind);
                },
                avatar: isSelected
                    ? null
                    : Icon(_getKindIcon(kind), size: 18),
                selectedColor: colorScheme.secondaryContainer,
                checkmarkColor: colorScheme.onSecondaryContainer,
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getKindLabel(AppLocalizations l10n, BabyActionKind kind) {
    switch (kind) {
      case BabyActionKind.feed:
        return l10n.historyFilterFeed;
      case BabyActionKind.diaper:
        return l10n.historyFilterDiaper;
      case BabyActionKind.bath:
        return l10n.historyFilterBath;
      case BabyActionKind.vomit:
        return l10n.historyFilterVomit;
    }
  }

  IconData _getKindIcon(BabyActionKind kind) {
    switch (kind) {
      case BabyActionKind.feed:
        return Icons.restaurant_outlined;
      case BabyActionKind.diaper:
        return Icons.baby_changing_station_outlined;
      case BabyActionKind.bath:
        return Icons.bathtub_outlined;
      case BabyActionKind.vomit:
        return Icons.sick_outlined;
    }
  }
}
