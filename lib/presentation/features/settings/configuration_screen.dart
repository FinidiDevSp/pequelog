import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/app_settings.dart';
import 'package:provider/provider.dart';

/// Placeholder for the configuration hub.
class ConfigurationScreen extends StatelessWidget {
  /// Displays the configuration entry point.
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.configurationTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.configurationPlaceholder,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.72),
              ),
            ),
            const SizedBox(height: 32),
            Consumer<AppSettings>(
              builder: (context, settings, _) {
                return DropdownButtonFormField<Locale>(
                  key: const Key('configuration_language'),
                  value: settings.locale,
                  decoration: InputDecoration(
                    labelText: l10n.configurationLanguageLabel,
                    helperText: l10n.configurationLanguageHint,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (locale) {
                    if (locale != null) {
                      settings.setLocale(locale);
                    }
                  },
                  items: AppLocalizations.supportedLocales
                      .map(
                        (locale) => DropdownMenuItem<Locale>(
                          value: locale,
                          child: Text(_resolveLocaleName(l10n, locale)),
                        ),
                      )
                      .toList(growable: false),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _resolveLocaleName(AppLocalizations l10n, Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return l10n.configurationLanguageEnglish;
      case 'es':
        return l10n.configurationLanguageSpanish;
      default:
        return locale.languageCode;
    }
  }
}
