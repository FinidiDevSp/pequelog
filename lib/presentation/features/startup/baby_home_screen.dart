import 'package:flutter/material.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';

/// Placeholder screen that will host the primary baby dashboard.
class BabyHomeScreen extends StatelessWidget {
  /// Creates a baby home screen bound to the provided [baby].
  const BabyHomeScreen({super.key, required this.baby});

  /// Baby currently selected for the session.
  final Baby baby;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(baby.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Proxima accion',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'Muy pronto podras registrar tomas, siestas y momentos clave aqui mismo.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.72),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
