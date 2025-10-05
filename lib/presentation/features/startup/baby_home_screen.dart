import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/babies/actions/baby_action_placeholder_screen.dart';
import 'package:pequelog/presentation/features/babies/edit_baby_screen.dart';
import 'package:pequelog/presentation/features/settings/configuration_screen.dart';

/// Placeholder screen that will host the primary baby dashboard.
class BabyHomeScreen extends StatelessWidget {
  /// Creates a baby home screen bound to the provided [baby].
  const BabyHomeScreen({super.key, required this.baby});

  /// Baby currently selected for the session.
  final Baby baby;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final materialLocalizations = MaterialLocalizations.of(context);

    final birthDate = materialLocalizations.formatMediumDate(baby.birthDateTime);
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.babyHomeBirthSummary(birthDate, birthTime),
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.babyHomeBirthStatsTitle,
                                style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.babyHomeBirthWeight(baby.birthWeightKg.toStringAsFixed(2)),
                                style: theme.textTheme.bodyMedium,
                              ),
                              Text(
                                l10n.babyHomeBirthLength(baby.birthLengthCm.toStringAsFixed(1)),
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
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ActionButton(
                  icon: Icons.local_drink_outlined,
                  tooltip: l10n.babyActionFeed,
                  onTap: () => _openAction(context, l10n.babyActionFeed, l10n.babyActionPlaceholderDescription),
                ),
                _ActionButton(
                  icon: Icons.bathtub_outlined,
                  tooltip: l10n.babyActionBath,
                  onTap: () => _openAction(context, l10n.babyActionBath, l10n.babyActionPlaceholderDescription),
                ),
                _ActionButton(
                  icon: Icons.sick_outlined,
                  tooltip: l10n.babyActionVomited,
                  onTap: () => _openAction(context, l10n.babyActionVomited, l10n.babyActionPlaceholderDescription),
                ),
                _ActionButton(
                  icon: Icons.baby_changing_station,
                  tooltip: l10n.babyActionDiaper,
                  onTap: () => _openAction(context, l10n.babyActionDiaper, l10n.babyActionPlaceholderDescription),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              l10n.babyHomeUpcomingActionTitle,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.babyHomeUpcomingActionDescription,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.72),
              ),
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
    switch (option) {
      case _BabyHomeMenuOption.edit:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => EditBabyScreen(baby: baby),
          ),
        );
        break;
      case _BabyHomeMenuOption.settings:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const ConfigurationScreen(),
          ),
        );
        break;
    }
  }

  void _openAction(
    BuildContext context,
    String title,
    String description,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BabyActionPlaceholderScreen(
          title: title,
          description: description,
        ),
      ),
    );
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
          child: Image.file(
            file,
            width: 88,
            height: 88,
            fit: BoxFit.cover,
          ),
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
