import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pequelog/data/baby_actions/legacy_action_csv_parser.dart';
import 'package:pequelog/domain/baby_actions/entities/stool_texture.dart';
import 'package:pequelog/domain/baby_actions/entities/vomit_severity.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/app_settings.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';
import 'package:pequelog/presentation/features/startup/baby_state.dart';
import 'package:pequelog/presentation/theme/app_color_palettes.dart';
import 'package:provider/provider.dart';

/// Simple configuration screen for language and color palette selection.
class ConfigurationScreen extends StatefulWidget {
  /// Creates the configuration screen.
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  bool _isImporting = false;

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
                FilledButton.icon(
                  onPressed: () {
                    if (_isImporting) {
                      return;
                    }
                    _importLegacyCsv(context);
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isImporting
                        ? SizedBox(
                            key: const ValueKey('loading'),
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : const Icon(Icons.upload_file_outlined),
                  ),
                  label: Text(
                    _isImporting
                        ? l10n.configurationImportLegacyLoading
                        : l10n.configurationImportLegacyButton,
                  ),
                ),
                const SizedBox(height: 32),
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
                    _showChangeSnackBar(
                      context,
                      l10n.configurationLanguageSpanish,
                    );
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
                    _showChangeSnackBar(
                      context,
                      l10n.configurationLanguageEnglish,
                    );
                  },
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
                  onTap: () {
                    HapticFeedback.selectionClick();
                    settings.setPalette(AppColorPalette.dawnBlush);
                    _showChangeSnackBar(
                      context,
                      l10n.configurationPaletteDawnBlush,
                    );
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
                    _showChangeSnackBar(
                      context,
                      l10n.configurationPaletteMintWhisper,
                    );
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
                    _showChangeSnackBar(
                      context,
                      l10n.configurationPaletteSkyBreeze,
                    );
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
                    _showChangeSnackBar(
                      context,
                      l10n.configurationPaletteLavenderField,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _importLegacyCsv(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final babyState = context.read<BabyState>();
    final baby = babyState.selectedBaby;
    if (baby == null) {
      _showImportSnackBar(context, l10n.configurationImportNoBaby, isError: true);
      return;
    }

    setState(() {
      _isImporting = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const <String>['csv'],
        withData: true,
      );

      if (!mounted) {
        return;
      }

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.first;
      final bytes = file.bytes;
      if (bytes == null) {
        _showImportSnackBar(
          context,
          l10n.configurationImportFailure,
          isError: true,
        );
        return;
      }

      final parser = LegacyActionCsvParser();
      final records = parser.parse(utf8.decode(bytes));
      if (records.isEmpty) {
        _showImportSnackBar(
          context,
          l10n.configurationImportEmpty,
          isError: true,
        );
        return;
      }

      final actionsState = context.read<BabyActionsState>();
      var inserted = 0;
      for (final record in records) {
        if (!mounted) {
          return;
        }
        if (record.feedAmountMl != null) {
          await actionsState.logFeed(
            occurredAt: record.occurredAt,
            amountMl: record.feedAmountMl!,
          );
          inserted++;
        }
        if (record.didPoop) {
          await actionsState.logDiaper(
            occurredAt: record.occurredAt,
            texture: StoolTexture.soft,
          );
          inserted++;
        }
        if (record.didVomit) {
          await actionsState.logVomit(
            occurredAt: record.occurredAt,
            severity: VomitSeverity.mild,
          );
          inserted++;
        }
        if (record.didBath) {
          await actionsState.logBath(
            occurredAt: record.occurredAt,
          );
          inserted++;
        }
      }

      if (!mounted) {
        return;
      }

      _showImportSnackBar(
        context,
        l10n.configurationImportSuccess(inserted),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showImportSnackBar(
        context,
        l10n.configurationImportFailure,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  void _showImportSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final theme = Theme.of(context);
    final backgroundColor =
        isError ? theme.colorScheme.error : theme.colorScheme.primary;
    final foregroundColor =
        isError ? theme.colorScheme.onError : theme.colorScheme.onPrimary;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: foregroundColor),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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
          label: const SizedBox.shrink(),
          icon: Icon(
            Icons.wb_sunny_rounded,
            color: currentMode == ThemeMode.light
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          tooltip: l10n.configurationThemeModeLight,
        ),
        ButtonSegment(
          value: ThemeMode.system,
          label: const SizedBox.shrink(),
          icon: Icon(
            Icons.brightness_auto_rounded,
            color: currentMode == ThemeMode.system
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          tooltip: l10n.configurationThemeModeSystem,
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: const SizedBox.shrink(),
          icon: Icon(
            Icons.nights_stay_rounded,
            color: currentMode == ThemeMode.dark
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          tooltip: l10n.configurationThemeModeDark,
        ),
      ],
      selected: {currentMode},
      onSelectionChanged: (Set<ThemeMode> selected) {
        onModeChanged(selected.first);
      },
      style: const ButtonStyle(
        visualDensity: VisualDensity.comfortable,
        padding: MaterialStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 12),
        ),
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
