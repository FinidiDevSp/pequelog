import 'package:flutter/material.dart';

/// Basic placeholder screen used while action flows are under construction.
class BabyActionPlaceholderScreen extends StatelessWidget {
  const BabyActionPlaceholderScreen({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            description,
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
