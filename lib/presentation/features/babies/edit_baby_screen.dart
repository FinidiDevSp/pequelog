import 'package:flutter/material.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/l10n/app_localizations.dart';

/// Temporary placeholder screen for editing a baby profile.
class EditBabyScreen extends StatelessWidget {
  const EditBabyScreen({super.key, required this.baby});

  final Baby baby;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editBabyPlaceholderTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.editBabyPlaceholderDescription,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.72),
            ),
          ),
        ),
      ),
    );
  }
}
