import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';

/// Placeholder for the configuration hub.
class ConfigurationScreen extends StatelessWidget {
  /// Displays the configuration entry point.
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.configurationTitle)),
      body: Center(child: Text(l10n.configurationPlaceholder)),
    );
  }
}
