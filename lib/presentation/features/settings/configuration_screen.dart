import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/app_settings.dart';
import 'package:provider/provider.dart';

import '../../theme/app_color_palettes.dart';

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
        child: SingleChildScrollView(
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<Locale>(
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
                      ),
                      const SizedBox(height: 24),
                      DropdownButtonFormField<ThemeMode>(
                        key: const Key('configuration_theme_mode'),
                        value: settings.themeMode,
                        decoration: InputDecoration(
                          labelText: l10n.configurationThemeModeLabel,
                          helperText: l10n.configurationThemeModeHint,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (mode) {
                          if (mode != null) {
                            settings.setThemeMode(mode);
                          }
                        },
                        items: ThemeMode.values
                            .map(
                              (mode) => DropdownMenuItem<ThemeMode>(
                                value: mode,
                                child: Text(
                                  _resolveThemeModeName(l10n, mode),
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 24),
                      DropdownButtonFormField<AppColorPalette>(
                        key: const Key('configuration_palette'),
                        value: settings.palette,
                        decoration: InputDecoration(
                          labelText: l10n.configurationPaletteLabel,
                          helperText: l10n.configurationPaletteHint,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (palette) {
                          if (palette != null) {
                            settings.setPalette(palette);
                          }
                        },
                        items: AppColorPalette.values
                            .map(
                              (palette) => DropdownMenuItem<AppColorPalette>(
                                value: palette,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _resolvePaletteName(l10n, palette),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    _PaletteDropdownPreview(palette: palette),
                                  ],
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 24),
                      _PalettePreview(
                        palette: settings.palette,
                        l10n: l10n,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
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

  String _resolvePaletteName(AppLocalizations l10n, AppColorPalette palette) {
    switch (palette) {
      case AppColorPalette.dawnBlush:
        return l10n.configurationPaletteDawnBlush;
      case AppColorPalette.mintWhisper:
        return l10n.configurationPaletteMintWhisper;
      case AppColorPalette.skyBreeze:
        return l10n.configurationPaletteSkyBreeze;
      case AppColorPalette.lavenderField:
        return l10n.configurationPaletteLavenderField;
    }
  }

  String _resolveThemeModeName(AppLocalizations l10n, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return l10n.configurationThemeModeSystem;
      case ThemeMode.light:
        return l10n.configurationThemeModeLight;
      case ThemeMode.dark:
        return l10n.configurationThemeModeDark;
    }
  }
}

class _PaletteDropdownPreview extends StatelessWidget {
  const _PaletteDropdownPreview({required this.palette});

  final AppColorPalette palette;

  @override
  Widget build(BuildContext context) {
    final colors = palette.colors.light;
    final borderColor = colors.onSurface.withOpacity(0.18);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PaletteColorDot(
          color: colors.background,
          borderColor: borderColor,
          size: 18,
        ),
        const SizedBox(width: 6),
        _PaletteColorDot(
          color: colors.surface,
          borderColor: borderColor,
          size: 18,
        ),
        const SizedBox(width: 6),
        _PaletteColorDot(
          color: colors.accent,
          borderColor: colors.onAccent.withOpacity(0.24),
          size: 18,
        ),
      ],
    );
  }
}

class _PalettePreview extends StatelessWidget {
  const _PalettePreview({
    required this.palette,
    required this.l10n,
  });

  final AppColorPalette palette;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.configurationPalettePreviewTitle, style: titleStyle),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 520;

            final lightCard = _PalettePreviewCard(
              title: l10n.configurationPalettePreviewLightLabel,
              variant: palette.colors.light,
              brightness: Brightness.light,
              l10n: l10n,
            );
            final darkCard = _PalettePreviewCard(
              title: l10n.configurationPalettePreviewDarkLabel,
              variant: palette.colors.dark,
              brightness: Brightness.dark,
              l10n: l10n,
            );

            if (isWide) {
              return Row(
                children: [
                  Expanded(child: lightCard),
                  const SizedBox(width: 16),
                  Expanded(child: darkCard),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                lightCard,
                const SizedBox(height: 16),
                darkCard,
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PalettePreviewCard extends StatelessWidget {
  const _PalettePreviewCard({
    required this.title,
    required this.variant,
    required this.brightness,
    required this.l10n,
  });

  final String title;
  final PaletteVariant variant;
  final Brightness brightness;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final borderColor = variant.onSurface.withOpacity(0.2);
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: variant.onBackground,
          fontWeight: FontWeight.w600,
        );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: variant.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textStyle),
          const SizedBox(height: 12),
          Row(
            children: [
              _PaletteColorDot(
                key: Key('palette_preview_${brightness.name}_background'),
                color: variant.background,
                borderColor: borderColor,
                size: 26,
              ),
              const SizedBox(width: 10),
              _PaletteColorDot(
                key: Key('palette_preview_${brightness.name}_surface'),
                color: variant.surface,
                borderColor: borderColor,
                size: 26,
              ),
              const SizedBox(width: 10),
              _PaletteColorDot(
                key: Key('palette_preview_${brightness.name}_accent'),
                color: variant.accent,
                borderColor: variant.onAccent.withOpacity(0.24),
                size: 26,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PaletteMockupScene(
            baseKey: 'palette_preview_${brightness.name}',
            variant: variant,
            l10n: l10n,
          ),
        ],
      ),
    );
  }
}

class _PaletteMockupScene extends StatelessWidget {
  const _PaletteMockupScene({
    required this.baseKey,
    required this.variant,
    required this.l10n,
  });

  final String baseKey;
  final PaletteVariant variant;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final onSurface = variant.onSurface;
    final accent = variant.accent;

    return Semantics(
      label: l10n.configurationPalettePreviewMockupLabel,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          decoration: BoxDecoration(
            color: variant.background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: onSurface.withOpacity(0.16)),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 18,
                decoration: BoxDecoration(
                  color: variant.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  key: Key('${baseKey}_mockup_surface_card'),
                  decoration: BoxDecoration(
                    color: variant.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: onSurface.withOpacity(0.1)),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        key: Key('${baseKey}_mockup_title_bar'),
                        height: 10,
                        decoration: BoxDecoration(
                          color: onSurface.withOpacity(0.24),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          key: Key('${baseKey}_mockup_content_card'),
                          decoration: BoxDecoration(
                            color: variant.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        key: Key('${baseKey}_mockup_accent_button'),
                        height: 40,
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaletteColorDot extends StatelessWidget {
  const _PaletteColorDot({
    super.key,
    required this.color,
    required this.borderColor,
    this.size = 24,
  });

  final Color color;
  final Color borderColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
    );
  }
}
