import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  l10n.configurationThemeModeLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _ThemeModeSegmentedButton(
                  currentMode: settings.themeMode,
                  onModeChanged: (mode) {
                    HapticFeedback.selectionClick();
                    settings.setThemeMode(mode);
                    final modeName = mode == ThemeMode.light
                        ? l10n.configurationThemeModeLight
                        : mode == ThemeMode.dark
                            ? l10n.configurationThemeModeDark
                            : l10n.configurationThemeModeSystem;
                    _showChangeSnackBar(context, modeName);
                  },
                ),
                const SizedBox(height: 32),
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
                  onTap: () {
                    HapticFeedback.selectionClick();
                    settings.setLocale(const Locale('es'));
                    _showChangeSnackBar(context, l10n.configurationLanguageSpanish);
                  },
                ),
                const SizedBox(height: 8),
                _LanguageOption(
                  title: l10n.configurationLanguageEnglish,
                  locale: const Locale('en'),
                  isSelected: settings.locale.languageCode == 'en',
                  onTap: () {
                    HapticFeedback.selectionClick();
                    settings.setLocale(const Locale('en'));
                    _showChangeSnackBar(context, l10n.configurationLanguageEnglish);
                  },
                ),
                const SizedBox(height: 16),
                _LanguagePreviewCard(locale: settings.locale),
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
                  onTap: () {
                    HapticFeedback.selectionClick();
                    settings.setPalette(AppColorPalette.dawnBlush);
                    _showChangeSnackBar(context, l10n.configurationPaletteDawnBlush);
                  },
                ),
                const SizedBox(height: 8),
                _PaletteOption(
                  title: l10n.configurationPaletteMintWhisper,
                  palette: AppColorPalette.mintWhisper,
                  isSelected: settings.palette == AppColorPalette.mintWhisper,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    settings.setPalette(AppColorPalette.mintWhisper);
                    _showChangeSnackBar(context, l10n.configurationPaletteMintWhisper);
                  },
                ),
                const SizedBox(height: 8),
                _PaletteOption(
                  title: l10n.configurationPaletteSkyBreeze,
                  palette: AppColorPalette.skyBreeze,
                  isSelected: settings.palette == AppColorPalette.skyBreeze,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    settings.setPalette(AppColorPalette.skyBreeze);
                    _showChangeSnackBar(context, l10n.configurationPaletteSkyBreeze);
                  },
                ),
                const SizedBox(height: 8),
                _PaletteOption(
                  title: l10n.configurationPaletteLavenderField,
                  palette: AppColorPalette.lavenderField,
                  isSelected: settings.palette == AppColorPalette.lavenderField,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    settings.setPalette(AppColorPalette.lavenderField);
                    _showChangeSnackBar(context, l10n.configurationPaletteLavenderField);
                  },
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

    return Semantics(
      label: '$title ${isSelected ? 'selected' : 'not selected'}',
      hint: 'Double tap to select this language',
      selected: isSelected,
      button: true,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event.logicalKey.keyLabel == 'Enter' ||
              event.logicalKey.keyLabel == ' ') {
            onTap();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Material(
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

    return Tooltip(
      message: '$title color palette',
      child: Semantics(
        label: '$title palette ${isSelected ? 'selected' : 'not selected'}',
        hint: 'Double tap to select this color palette',
        selected: isSelected,
        button: true,
        child: Focus(
          onKeyEvent: (node, event) {
            if (event.logicalKey.keyLabel == 'Enter' ||
                event.logicalKey.keyLabel == ' ') {
              onTap();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: Material(
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

/// Preview card showing example text in the selected language.
class _LanguagePreviewCard extends StatelessWidget {
  const _LanguagePreviewCard({required this.locale});

  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSpanish = locale.languageCode == 'es';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.translate_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                isSpanish ? 'Vista previa' : 'Preview',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isSpanish ? '¡Hola! Bienvenido a PequeLog' : 'Hello! Welcome to PequeLog',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isSpanish
                ? 'Registra las actividades diarias de tu bebé'
                : 'Track your baby\'s daily activities',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isSpanish
                ? 'Comida, pañales, baños y más'
                : 'Feeding, diapers, baths and more',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Segmented button for theme mode selection with animated icons.
class _ThemeModeSegmentedButton extends StatelessWidget {
  const _ThemeModeSegmentedButton({
    required this.currentMode,
    required this.onModeChanged,
  });

  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(
          value: ThemeMode.light,
          label: Text(l10n.configurationThemeModeLight),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.wb_sunny_rounded,
              key: const ValueKey('sun'),
              color: currentMode == ThemeMode.light
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        ButtonSegment(
          value: ThemeMode.system,
          label: Text(l10n.configurationThemeModeSystem),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.brightness_auto_rounded,
              key: const ValueKey('auto'),
              color: currentMode == ThemeMode.system
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text(l10n.configurationThemeModeDark),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.nights_stay_rounded,
              key: const ValueKey('moon'),
              color: currentMode == ThemeMode.dark
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ],
      selected: {currentMode},
      onSelectionChanged: (Set<ThemeMode> selected) {
        onModeChanged(selected.first);
      },
      style: ButtonStyle(
        visualDensity: VisualDensity.comfortable,
      ),
    );
  }
}

/// Shows a brief SnackBar to confirm the change with the theme color.
void _showChangeSnackBar(BuildContext context, String changeName) {
  final theme = Theme.of(context);
  final l10n = AppLocalizations.of(context)!;
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '${l10n.configurationChangeConfirmation}: $changeName',
        style: TextStyle(color: theme.colorScheme.onPrimary),
      ),
      backgroundColor: theme.colorScheme.primary,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
