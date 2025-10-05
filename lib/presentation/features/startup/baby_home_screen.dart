import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/domain/baby_actions/entities/feed_method.dart';
import 'package:pequelog/domain/baby_actions/entities/stool_texture.dart';
import 'package:pequelog/domain/baby_actions/entities/vomit_severity.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';
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
            const _RecentActionsSection(),
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
    switch (option) {
      case _BabyHomeMenuOption.edit:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => EditBabyScreen(
              baby: baby,
              imagePicker: imagePicker,
              datePicker: datePicker,
              timePicker: timePicker,
            ),
          ),
        );
        break;
      case _BabyHomeMenuOption.settings:
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const ConfigurationScreen()),
        );
        break;
    }
  }

  Future<void> _openFeedAction(BuildContext context) async {
    final message = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) =>
            FeedActionScreen(datePicker: datePicker, timePicker: timePicker),
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
  const _RecentActionsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Consumer<BabyActionsState>(
      builder: (context, state, _) {
        final title = Text(
          l10n.recentActionsTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        );

        if (state.isLoading && state.recentActions.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 12),
              const Center(child: CircularProgressIndicator()),
            ],
          );
        }

        if (state.recentActions.isEmpty) {
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
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 4),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final action = state.recentActions[index];
                  final summary = _ActionSummary.fromAction(
                    action,
                    l10n,
                    material,
                    locale,
                  );
                  return ListTile(
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
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: state.recentActions.length,
              ),
            ),
          ],
        );
      },
    );
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
        final methodName = details['method'] as String?;
        final amount = (details['amountMl'] as num?)?.toDouble() ?? 0;
        final feedMethod = methodName != null
            ? FeedMethod.values.firstWhere(
                (method) => method.name == methodName,
                orElse: () => FeedMethod.bottle,
              )
            : FeedMethod.bottle;
        final numberFormat = NumberFormat('#.##', locale.toLanguageTag());
        final amountText = numberFormat.format(amount);
        final amountDisplay = '$amountText ml';
        final description = l10n.recentActionFeed(
          timeText,
          _feedMethodLabel(feedMethod, l10n),
          amountDisplay,
        );
        final subtitle = notes == null ? null : l10n.recentActionNotes(notes);
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

String _feedMethodLabel(FeedMethod method, AppLocalizations l10n) {
  switch (method) {
    case FeedMethod.breast:
      return l10n.feedMethodBreast;
    case FeedMethod.bottle:
      return l10n.feedMethodBottle;
    case FeedMethod.mixed:
      return l10n.feedMethodMixed;
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
