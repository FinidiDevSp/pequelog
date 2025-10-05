import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/domain/baby_actions/entities/stool_texture.dart';
import 'package:pequelog/domain/baby_actions/entities/vomit_severity.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';
import 'package:pequelog/presentation/features/baby_actions/feed_timer_state.dart';
import 'package:pequelog/presentation/features/babies/actions/bath_action_screen.dart';
import 'package:pequelog/presentation/features/babies/actions/diaper_action_screen.dart';
import 'package:pequelog/presentation/features/babies/actions/feed_action_screen.dart';
import 'package:pequelog/presentation/features/babies/actions/vomit_action_screen.dart';
import 'package:pequelog/presentation/features/babies/edit_baby_screen.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/presentation/features/settings/configuration_screen.dart';
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
      body: Padding(
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
                                l10n.babyHomeBirthSummary(birthDate, birthTime),
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
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ActionButton(
                  icon: Icons.local_drink_outlined,
                  tooltip: l10n.babyActionFeed,
                  onTap: () => _openFeedAction(context),
                ),
                _ActionButton(
                  icon: Icons.bathtub_outlined,
                  tooltip: l10n.babyActionBath,
                  onTap: () => _openBathAction(context),
                ),
                _ActionButton(
                  icon: Icons.sick_outlined,
                  tooltip: l10n.babyActionVomited,
                  onTap: () => _openVomitAction(context),
                ),
                _ActionButton(
                  icon: Icons.baby_changing_station,
                  tooltip: l10n.babyActionDiaper,
                  onTap: () => _openDiaperAction(context),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _RecentActionsSection(
              datePicker: datePicker,
              timePicker: timePicker,
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuSelection(
    _BabyHomeMenuOption option,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final navigator = Navigator.of(context, rootNavigator: true);
    switch (option) {
      case _BabyHomeMenuOption.edit:
        Future<void>.microtask(() {
          navigator.push(
            MaterialPageRoute<void>(
              builder: (_) => EditBabyScreen(
                baby: baby,
                imagePicker: imagePicker,
                datePicker: datePicker,
                timePicker: timePicker,
              ),
            ),
          );
        });
        break;
      case _BabyHomeMenuOption.settings:
        Future<void>.microtask(() {
          navigator.push(
            MaterialPageRoute<void>(
              builder: (_) => const ConfigurationScreen(),
            ),
          );
        });
        break;
    }
  }

  Future<void> _openFeedAction(BuildContext context) async {
    final message = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => FeedActionScreen(
          timePicker: timePicker,
          datePicker: datePicker,
        ),
      ),
    );
    _showResultSnack(context, message);
  }

  Future<void> _openBathAction(BuildContext context) async {
    final message = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) =>
            BathActionScreen(datePicker: datePicker, timePicker: timePicker),
      ),
    );
    _showResultSnack(context, message);
  }

  Future<void> _openVomitAction(BuildContext context) async {
    final message = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) =>
            VomitActionScreen(datePicker: datePicker, timePicker: timePicker),
      ),
    );
    _showResultSnack(context, message);
  }

  Future<void> _openDiaperAction(BuildContext context) async {
    final message = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) =>
            DiaperActionScreen(datePicker: datePicker, timePicker: timePicker),
      ),
    );
    _showResultSnack(context, message);
  }

  void _showResultSnack(BuildContext context, String? message) {
    if (message == null || !context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
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

        final actions = state.recentActions;
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
                    confirmDismiss: (direction) => _handleDismiss(
                      context,
                      action,
                      direction,
                      l10n,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.1),
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
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
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
        final message = await Navigator.of(context).push<String>(
          MaterialPageRoute<String>(
            builder: (_) => FeedActionScreen(
              timePicker: timePicker,
              datePicker: datePicker,
              initialAction: action,
            ),
          ),
        );
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
    final message = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => FeedActionScreen(
          timePicker: timePicker,
          datePicker: datePicker,
        ),
      ),
    );
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
        final subtitle =
            subtitleParts.isEmpty ? null : subtitleParts.join('\n');
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: IconButton(
          constraints: const BoxConstraints.tightFor(width: 64, height: 64),
          onPressed: onTap,
          icon: Icon(icon),
          color: theme.colorScheme.primary,
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
