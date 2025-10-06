import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pequelog/core/routing/app_router.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/domain/baby_actions/entities/stool_texture.dart';
import 'package:pequelog/domain/baby_actions/entities/vomit_severity.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';
import 'package:pequelog/presentation/features/baby_actions/feed_timer_state.dart';

import 'package:provider/provider.dart';

/// Placeholder screen that will host the primary baby dashboard.
class BabyHomeScreen extends StatelessWidget {
  /// Creates a baby home screen bound to the provided [baby].
  const BabyHomeScreen({
    super.key,
    required this.baby,
    required this.imagePicker,
    this.datePicker,
    this.timePicker,
  });

  /// Baby currently selected for the session.
  final Baby baby;
  final ImagePickerService imagePicker;
  final DatePickerLauncher? datePicker;
  final TimePickerLauncher? timePicker;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final materialLocalizations = MaterialLocalizations.of(context);

    final birthDate = materialLocalizations.formatMediumDate(
      baby.birthDateTime,
    );
    final birthTime = materialLocalizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(baby.birthDateTime),
      alwaysUse24HourFormat: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(baby.name),
        actions: [
          PopupMenuButton<_BabyHomeMenuOption>(
            onSelected: (option) => _handleMenuSelection(option, context, l10n),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _BabyHomeMenuOption.edit,
                child: Text(l10n.babyHomeMenuEdit),
              ),
              PopupMenuItem(
                value: _BabyHomeMenuOption.settings,
                child: Text(l10n.babyHomeMenuSettings),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openHistory(context),
        tooltip: l10n.historyTitle,
        child: const Icon(Icons.history),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: theme.colorScheme.surface,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _BabyPhoto(
                            path: baby.photoPath,
                            placeholder: l10n.babyHomePhotoPlaceholder,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.babyHomeBirthSectionTitle,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${birthDate} · ${birthTime}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.babyHomeBirthStatsTitle,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.babyHomeBirthWeight(
                                    baby.birthWeightKg.toStringAsFixed(2),
                                  ),
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  l10n.babyHomeBirthLength(
                                    baby.birthLengthCm.toStringAsFixed(1),
                                  ),
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.babyHomeActionsTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _ActionsCarousel(
                onFeed: () => _openFeedAction(context),
                onBath: () => _openBathAction(context),
                onVomit: () => _openVomitAction(context),
                onDiaper: () => _openDiaperAction(context),
                onHistory: () => _openHistory(context),
                onStatistics: () => _openStatistics(context),
                onAskPediatrician: () => _openAskPediatrician(context),
                onMedicalAgenda: () => _openMedicalAgenda(context),
                onGrowth: () => _openGrowth(context),
              ),
              const SizedBox(height: 24),
              const _LatestEventsOverview(),
              const SizedBox(height: 32),
              _RecentActionsSection(
                datePicker: datePicker,
                timePicker: timePicker,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuSelection(
    _BabyHomeMenuOption option,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    switch (option) {
      case _BabyHomeMenuOption.edit:
        context.goToEditBaby();
        break;
      case _BabyHomeMenuOption.settings:
        context.goToSettings();
        break;
    }
  }

  Future<void> _openFeedAction(BuildContext context) async {
    final message = await context.goToFeedAction();
    if (!context.mounted) return;
    _showResultSnack(context, message);
  }

  Future<void> _openBathAction(BuildContext context) async {
    final message = await context.goToBathAction();
    if (!context.mounted) return;
    _showResultSnack(context, message);
  }

  Future<void> _openVomitAction(BuildContext context) async {
    final message = await context.goToVomitAction();
    if (!context.mounted) return;
    _showResultSnack(context, message);
  }

  Future<void> _openDiaperAction(BuildContext context) async {
    final message = await context.goToDiaperAction();
    if (!context.mounted) return;
    _showResultSnack(context, message);
  }

  void _openHistory(BuildContext context) {
    context.goToHistory();
  }

  void _openStatistics(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _openFeatureComingSoon(context, l10n.babyActionStatistics);
  }

  void _openAskPediatrician(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _openFeatureComingSoon(context, l10n.babyActionAskPediatrician);
  }

  void _openMedicalAgenda(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _openFeatureComingSoon(context, l10n.babyActionMedicalAgenda);
  }

  void _openGrowth(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _openFeatureComingSoon(context, l10n.babyActionGrowth);
  }

  void _openFeatureComingSoon(BuildContext context, String feature) {
    final l10n = AppLocalizations.of(context)!;
    _showSnack(context, l10n.babyHomeFeatureComingSoon(feature));
  }

  void _showResultSnack(BuildContext context, String? message) {
    _showSnack(context, message);
  }
}

class _LatestEventsOverview extends StatelessWidget {
  const _LatestEventsOverview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Consumer<BabyActionsState>(
      builder: (context, state, _) {
        final material = MaterialLocalizations.of(context);
        final now = DateTime.now();

        final entries = <_HighlightEntry>[
          _HighlightEntry(
            icon: Icons.local_drink_outlined,
            label: l10n.babyHomeHighlightsFeed,
            action: _findLatestAction(state.recentActions, BabyActionKind.feed),
          ),
          _HighlightEntry(
            icon: Icons.baby_changing_station,
            label: l10n.babyHomeHighlightsDiaper,
            action: _findLatestAction(
              state.recentActions,
              BabyActionKind.diaper,
            ),
          ),
          _HighlightEntry(
            icon: Icons.bathtub_outlined,
            label: l10n.babyHomeHighlightsBath,
            action: _findLatestAction(state.recentActions, BabyActionKind.bath),
          ),
          _HighlightEntry(
            icon: Icons.sick_outlined,
            label: l10n.babyHomeHighlightsVomit,
            action: _findLatestAction(
              state.recentActions,
              BabyActionKind.vomit,
            ),
          ),
        ];

        final hasData = entries.any((entry) => entry.action != null);

        if (state.isLoading && !hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.babyHomeHighlightsTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              const Center(child: CircularProgressIndicator()),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.babyHomeHighlightsTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: theme.colorScheme.surface,
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _buildHighlightTile(entry, theme, l10n, material, now);
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHighlightTile(
    _HighlightEntry entry,
    ThemeData theme,
    AppLocalizations l10n,
    MaterialLocalizations material,
    DateTime reference,
  ) {
    final action = entry.action;
    final subtitle = action == null
        ? l10n.babyHomeHighlightsNoData
        : l10n.babyHomeHighlightsEntry(
            material.formatMediumDate(action.occurredAt),
            material.formatTimeOfDay(
              TimeOfDay.fromDateTime(action.occurredAt),
              alwaysUse24HourFormat: true,
            ),
            _formatElapsedSince(action.occurredAt, reference),
          );

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
        foregroundColor: theme.colorScheme.primary,
        child: Icon(entry.icon),
      ),
      title: Text(
        entry.label,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
    );
  }
}

class _HighlightEntry {
  const _HighlightEntry({required this.icon, required this.label, this.action});

  final IconData icon;
  final String label;
  final BabyAction? action;
}

BabyAction? _findLatestAction(
  Iterable<BabyAction> actions,
  BabyActionKind kind,
) {
  for (final action in actions) {
    if (action.kind == kind) {
      return action;
    }
  }
  return null;
}

String _formatElapsedSince(DateTime occurredAt, DateTime reference) {
  final difference = reference.difference(occurredAt);
  if (difference.isNegative) {
    return '0s';
  }
  final days = difference.inDays;
  final hours = difference.inHours.remainder(24);
  final minutes = difference.inMinutes.remainder(60);
  final seconds = difference.inSeconds.remainder(60);

  final parts = <String>[];
  if (days > 0) {
    parts.add('${days}d');
  }
  if (hours > 0) {
    parts.add('${hours}h');
  }
  if (minutes > 0) {
    parts.add('${minutes}m');
  }
  if (parts.isEmpty) {
    parts.add('${seconds}s');
  }

  return parts.join(' ');
}

class _RecentActionsSection extends StatelessWidget {
  const _RecentActionsSection({this.datePicker, this.timePicker});

  final DatePickerLauncher? datePicker;
  final TimePickerLauncher? timePicker;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Consumer2<BabyActionsState, FeedTimerState>(
      builder: (context, state, timerState, _) {
        final title = Text(
          l10n.recentActionsTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        );

        // Sort actions by occurredAt descending (most recent first)
        final actions = List<BabyAction>.from(state.recentActions)
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
        final hasTimer = timerState.isVisible;

        if (state.isLoading && actions.isEmpty && !hasTimer) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 12),
              const Center(child: CircularProgressIndicator()),
            ],
          );
        }

        if (!hasTimer && actions.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 12),
              Text(
                l10n.recentActionsEmpty,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.72),
                ),
              ),
            ],
          );
        }

        final locale = Localizations.localeOf(context);
        final material = MaterialLocalizations.of(context);
        final itemCount = actions.length + (hasTimer ? 1 : 0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: theme.colorScheme.surface,
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 4),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (hasTimer && index == 0) {
                    return _buildActiveTimerTile(
                      context,
                      l10n,
                      theme,
                      timerState,
                    );
                  }

                  final actionIndex = hasTimer ? index - 1 : index;
                  final action = actions[actionIndex];
                  final summary = _ActionSummary.fromAction(
                    action,
                    l10n,
                    material,
                    locale,
                  );

                  return Dismissible(
                    key: ValueKey<int>(action.id),
                    background: _buildDismissBackground(
                      color: theme.colorScheme.errorContainer,
                      foreground: theme.colorScheme.onErrorContainer,
                      icon: Icons.delete_outline,
                      label: l10n.recentActionDeleteLabel,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 24),
                    ),
                    secondaryBackground: _buildDismissBackground(
                      color: theme.colorScheme.primaryContainer,
                      foreground: theme.colorScheme.onPrimaryContainer,
                      icon: Icons.edit_outlined,
                      label: l10n.recentActionEditLabel,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                    ),
                    confirmDismiss: (direction) =>
                        _handleDismiss(context, action, direction, l10n),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary.withOpacity(
                          0.1,
                        ),
                        foregroundColor: theme.colorScheme.primary,
                        child: Icon(summary.icon),
                      ),
                      title: Text(
                        summary.description,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: summary.subtitle == null
                          ? Text(summary.dateLabel)
                          : Text('${summary.dateLabel}\n${summary.subtitle}'),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: itemCount,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActiveTimerTile(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    FeedTimerState timerState,
  ) {
    final elapsed = _formatDuration(timerState.elapsed);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
        foregroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.timer_outlined),
      ),
      title: Text(
        l10n.recentActionFeedInProgressTitle,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(l10n.recentActionFeedInProgressSubtitle(elapsed)),
      onTap: () => _openActiveFeed(context),
    );
  }

  Widget _buildDismissBackground({
    required Color color,
    required Color foreground,
    required IconData icon,
    required String label,
    required AlignmentGeometry alignment,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return Container(
      alignment: alignment,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: foreground, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Future<bool> _handleDismiss(
    BuildContext context,
    BabyAction action,
    DismissDirection direction,
    AppLocalizations l10n,
  ) async {
    if (direction == DismissDirection.startToEnd) {
      final confirmed = await _confirmDeletion(context, l10n);
      if (!confirmed) {
        return false;
      }
      try {
        await context.read<BabyActionsState>().deleteAction(action.id);
        if (!context.mounted) {
          return true;
        }
        _showSnack(context, l10n.recentActionDeleteSuccess);
        return true;
      } catch (_) {
        if (context.mounted) {
          _showSnack(context, l10n.recentActionDeleteError);
        }
        return false;
      }
    } else {
      await _openEditAction(context, action);
      return false;
    }
  }

  Future<bool> _confirmDeletion(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.recentActionDeleteConfirmTitle),
          content: Text(l10n.recentActionDeleteConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.recentActionDeleteConfirmCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.recentActionDeleteConfirmAccept),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<void> _openEditAction(BuildContext context, BabyAction action) async {
    final l10n = AppLocalizations.of(context)!;
    switch (action.kind) {
      case BabyActionKind.feed:
        final message = await context.goToFeedAction(initialAction: action);
        if (!context.mounted) {
          return;
        }
        _showSnack(context, message);
        break;
      default:
        _showSnack(context, l10n.recentActionEditUnsupported);
    }
  }

  Future<void> _openActiveFeed(BuildContext context) async {
    final message = await context.goToFeedAction();
    if (!context.mounted) {
      return;
    }
    _showSnack(context, message);
  }

  void _showSnack(BuildContext context, String? message) {
    if (message == null || !context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ActionSummary {
  _ActionSummary({
    required this.icon,
    required this.description,
    required this.dateLabel,
    this.subtitle,
  });

  final IconData icon;
  final String description;
  final String dateLabel;
  final String? subtitle;

  factory _ActionSummary.fromAction(
    BabyAction action,
    AppLocalizations l10n,
    MaterialLocalizations material,
    Locale locale,
  ) {
    final timeText = material.formatTimeOfDay(
      TimeOfDay.fromDateTime(action.occurredAt),
      alwaysUse24HourFormat: true,
    );
    final dateText = material.formatMediumDate(action.occurredAt);
    final notes = action.notes;

    switch (action.kind) {
      case BabyActionKind.feed:
        final details = action.details;
        final amount = (details['amountMl'] as num?)?.toDouble() ?? 0;
        final durationSeconds = details['durationSeconds'] as int?;
        final numberFormat = NumberFormat('#.##', locale.toLanguageTag());
        final amountText = numberFormat.format(amount);
        final amountDisplay = '$amountText ml';
        final description = l10n.recentActionFeed(timeText, amountDisplay);
        final durationLabel = durationSeconds == null
            ? null
            : l10n.recentActionFeedDuration(
                _formatDuration(Duration(seconds: durationSeconds)),
              );
        final subtitleParts = <String>[];
        if (durationLabel != null) {
          subtitleParts.add(durationLabel);
        }
        if (notes != null) {
          subtitleParts.add(l10n.recentActionNotes(notes));
        }
        final subtitle = subtitleParts.isEmpty
            ? null
            : subtitleParts.join('\n');
        return _ActionSummary(
          icon: Icons.local_drink_outlined,
          description: description,
          dateLabel: dateText,
          subtitle: subtitle,
        );
      case BabyActionKind.bath:
        final duration = action.details['durationMinutes'] as int?;
        final description = duration == null
            ? l10n.recentActionBath(timeText)
            : l10n.recentActionBathWithDuration(timeText, '$duration min');
        final subtitle = notes == null ? null : l10n.recentActionNotes(notes);
        return _ActionSummary(
          icon: Icons.bathtub_outlined,
          description: description,
          dateLabel: dateText,
          subtitle: subtitle,
        );
      case BabyActionKind.vomit:
        final severityValue = action.details['severity'] as String?;
        final severity = severityValue != null
            ? VomitSeverity.values.firstWhere(
                (value) => value.name == severityValue,
                orElse: () => VomitSeverity.moderate,
              )
            : VomitSeverity.moderate;
        final description = l10n.recentActionVomit(
          timeText,
          _vomitSeverityLabel(severity, l10n),
        );
        final subtitle = notes == null ? null : l10n.recentActionNotes(notes);
        return _ActionSummary(
          icon: Icons.sick_outlined,
          description: description,
          dateLabel: dateText,
          subtitle: subtitle,
        );
      case BabyActionKind.diaper:
        final textureValue = action.details['texture'] as String?;
        final texture = textureValue != null
            ? StoolTexture.values.firstWhere(
                (value) => value.name == textureValue,
                orElse: () => StoolTexture.soft,
              )
            : StoolTexture.soft;
        final hadPee = action.details['hadPee'] == true;
        final description = hadPee
            ? l10n.recentActionDiaperWithPee(
                timeText,
                _diaperTextureLabel(texture, l10n),
                l10n.diaperPeeTag,
              )
            : l10n.recentActionDiaper(
                timeText,
                _diaperTextureLabel(texture, l10n),
              );
        final subtitle = notes == null ? null : l10n.recentActionNotes(notes);
        return _ActionSummary(
          icon: Icons.baby_changing_station,
          description: description,
          dateLabel: dateText,
          subtitle: subtitle,
        );
    }
  }
}

String _vomitSeverityLabel(VomitSeverity severity, AppLocalizations l10n) {
  switch (severity) {
    case VomitSeverity.mild:
      return l10n.vomitSeverityMild;
    case VomitSeverity.moderate:
      return l10n.vomitSeverityModerate;
    case VomitSeverity.intense:
      return l10n.vomitSeverityIntense;
  }
}

String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  if (hours > 0) {
    final hoursLabel = hours.toString().padLeft(2, '0');
    final minutesLabel = minutes.toString().padLeft(2, '0');
    final secondsLabel = seconds.toString().padLeft(2, '0');
    return '$hoursLabel:$minutesLabel:$secondsLabel';
  }
  final minutesLabel = minutes.toString().padLeft(2, '0');
  final secondsLabel = seconds.toString().padLeft(2, '0');
  return '$minutesLabel:$secondsLabel';
}

String _diaperTextureLabel(StoolTexture texture, AppLocalizations l10n) {
  switch (texture) {
    case StoolTexture.liquid:
      return l10n.diaperTextureLiquid;
    case StoolTexture.soft:
      return l10n.diaperTextureSoft;
    case StoolTexture.solid:
      return l10n.diaperTextureSolid;
  }
}

class _ActionsCarousel extends StatelessWidget {
  const _ActionsCarousel({
    required this.onFeed,
    required this.onBath,
    required this.onVomit,
    required this.onDiaper,
    required this.onHistory,
    required this.onStatistics,
    required this.onAskPediatrician,
    required this.onMedicalAgenda,
    required this.onGrowth,
  });

  final VoidCallback onFeed;
  final VoidCallback onBath;
  final VoidCallback onVomit;
  final VoidCallback onDiaper;
  final VoidCallback onHistory;
  final VoidCallback onStatistics;
  final VoidCallback onAskPediatrician;
  final VoidCallback onMedicalAgenda;
  final VoidCallback onGrowth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final actions = <_CarouselAction>[
      _CarouselAction(
        icon: Icons.local_drink_outlined,
        tooltip: l10n.babyActionFeed,
        onTap: onFeed,
      ),
      _CarouselAction(
        icon: Icons.bathtub_outlined,
        tooltip: l10n.babyActionBath,
        onTap: onBath,
      ),
      _CarouselAction(
        icon: Icons.sick_outlined,
        tooltip: l10n.babyActionVomited,
        onTap: onVomit,
      ),
      _CarouselAction(
        icon: Icons.baby_changing_station,
        tooltip: l10n.babyActionDiaper,
        onTap: onDiaper,
      ),
      _CarouselAction(
        icon: Icons.history_toggle_off,
        tooltip: l10n.babyActionHistory,
        onTap: onHistory,
      ),
      _CarouselAction(
        icon: Icons.bar_chart_outlined,
        tooltip: l10n.babyActionStatistics,
        onTap: onStatistics,
      ),
      _CarouselAction(
        icon: Icons.contact_support_outlined,
        tooltip: l10n.babyActionAskPediatrician,
        onTap: onAskPediatrician,
      ),
      _CarouselAction(
        icon: Icons.event_note_outlined,
        tooltip: l10n.babyActionMedicalAgenda,
        onTap: onMedicalAgenda,
      ),
      _CarouselAction(
        icon: Icons.show_chart_outlined,
        tooltip: l10n.babyActionGrowth,
        onTap: onGrowth,
      ),
    ];

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          final action = actions[index];
          return _ActionButton(
            icon: action.icon,
            tooltip: action.tooltip,
            onTap: action.onTap,
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: actions.length,
      ),
    );
  }
}

class _CarouselAction {
  const _CarouselAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: tooltip,
      child: SizedBox.square(
        dimension: 72,
        child: Material(
          color: theme.colorScheme.primary.withOpacity(0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Center(
              child: Icon(icon, color: theme.colorScheme.primary, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}

class _BabyPhoto extends StatelessWidget {
  const _BabyPhoto({required this.path, required this.placeholder});

  final String? path;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget avatar;

    if (path != null && path!.isNotEmpty && !kIsWeb) {
      final file = File(path!);
      if (file.existsSync()) {
        avatar = ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(file, width: 88, height: 88, fit: BoxFit.cover),
        );
      } else {
        avatar = _PlaceholderBox(placeholder: placeholder, theme: theme);
      }
    } else {
      avatar = _PlaceholderBox(placeholder: placeholder, theme: theme);
    }

    return avatar;
  }
}

class _PlaceholderBox extends StatelessWidget {
  const _PlaceholderBox({required this.placeholder, required this.theme});

  final String placeholder;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.24)),
      ),
      alignment: Alignment.center,
      child: Text(
        placeholder,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}

enum _BabyHomeMenuOption { edit, settings }

void _showSnack(BuildContext context, String? message) {
  if (message == null || !context.mounted) {
    return;
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
