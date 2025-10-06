import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/app_settings.dart';
import 'package:pequelog/presentation/theme/app_color_palettes.dart';
import 'package:provider/provider.dart';

/// Simple configuration screen for language and color palette selection.
class ConfigurationScreen extends StatelessWidget {
  /// Creates the configuration screen.
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.configurationTitle),
      ),
      body: Consumer<AppSettings>(
        builder: (context, settings, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.configurationLanguageLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _LanguageOption(
                  title: l10n.configurationLanguageSpanish,
                  locale: const Locale('es'),
                  isSelected: settings.locale.languageCode == 'es',
                  onTap: () => settings.setLocale(const Locale('es')),
                ),
                const SizedBox(height: 8),
                _LanguageOption(
                  title: l10n.configurationLanguageEnglish,
                  locale: const Locale('en'),
                  isSelected: settings.locale.languageCode == 'en',
                  onTap: () => settings.setLocale(const Locale('en')),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.configurationPaletteLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _PaletteOption(
                  title: l10n.configurationPaletteDawnBlush,
                  palette: AppColorPalette.dawnBlush,
                  isSelected: settings.palette == AppColorPalette.dawnBlush,
                  onTap: () => settings.setPalette(AppColorPalette.dawnBlush),
                ),
                const SizedBox(height: 8),
                _PaletteOption(
                  title: l10n.configurationPaletteMintWhisper,
                  palette: AppColorPalette.mintWhisper,
                  isSelected: settings.palette == AppColorPalette.mintWhisper,
                  onTap: () => settings.setPalette(AppColorPalette.mintWhisper),
                ),
                const SizedBox(height: 8),
                _PaletteOption(
                  title: l10n.configurationPaletteSkyBreeze,
                  palette: AppColorPalette.skyBreeze,
                  isSelected: settings.palette == AppColorPalette.skyBreeze,
                  onTap: () => settings.setPalette(AppColorPalette.skyBreeze),
                ),
                const SizedBox(height: 8),
                _PaletteOption(
                  title: l10n.configurationPaletteLavenderField,
                  palette: AppColorPalette.lavenderField,
                  isSelected: settings.palette == AppColorPalette.lavenderField,
                  onTap: () => settings.setPalette(AppColorPalette.lavenderField),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.title,
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final Locale locale;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: isSelected
          ? theme.colorScheme.primary.withOpacity(0.12)
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withOpacity(0.87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaletteOption extends StatelessWidget {
  const _PaletteOption({
    required this.title,
    required this.palette,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final AppColorPalette palette;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = palette.colors.light;

    return Material(
      color: isSelected
          ? theme.colorScheme.primary.withOpacity(0.12)
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withOpacity(0.87),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ColorDot(color: colors.background),
                  const SizedBox(width: 6),
                  _ColorDot(color: colors.surface),
                  const SizedBox(width: 6),
                  _ColorDot(color: colors.accent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black.withOpacity(0.12),
          width: 1,
        ),
      ),
    );
  }
}
