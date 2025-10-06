import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/theme/app_color_palettes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds global presentation settings such as the active locale.
class AppSettings extends ChangeNotifier {
  AppSettings({
    Locale? initialLocale,
    AppColorPalette initialPalette = AppColorPalette.dawnBlush,
    ThemeMode initialThemeMode = ThemeMode.system,
    int initialRecentActionsLimit = 5,
    AppSettingsStore? store,
  })  : _locale = initialLocale ?? const Locale('es'),
        _palette = initialPalette,
        _themeMode = initialThemeMode,
        _recentActionsLimit = initialRecentActionsLimit,
        _store = store ?? const SharedPreferencesAppSettingsStore() {
    _restorePersistedSettings();
  }

  Locale _locale;
  AppColorPalette _palette;
  ThemeMode _themeMode;
  int _recentActionsLimit;
  final AppSettingsStore _store;

  /// Current locale for the application.
  Locale get locale => _locale;

  /// Current pastel palette applied to the app.
  AppColorPalette get palette => _palette;

  /// Current theme mode selection applied across the app.
  ThemeMode get themeMode => _themeMode;

  /// Number of recent actions to display in the home screen timeline.
  int get recentActionsLimit => _recentActionsLimit;

  /// Updates the locale and notifies listeners when it changes.
  void setLocale(Locale locale) {
    if (locale == _locale) {
      return;
    }
    _locale = locale;
    notifyListeners();
    unawaited(
      _store.saveLocale(locale).catchError((_) {
        // Persistence errors should not block UI updates.
      }),
    );
  }

  /// Updates the palette and notifies listeners when it changes.
  void setPalette(AppColorPalette palette) {
    if (palette == _palette) {
      return;
    }
    _palette = palette;
    notifyListeners();
    unawaited(
      _store.savePalette(palette).catchError((_) {
        // Persistence errors should not block UI updates.
      }),
    );
  }

  /// Updates the theme mode and notifies listeners when it changes.
  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) {
      return;
    }
    _themeMode = mode;
    notifyListeners();
    unawaited(
      _store.saveThemeMode(mode).catchError((_) {
        // Persistence errors should not block UI updates.
      }),
    );
  }

  /// Updates the number of recent actions to display and notifies listeners.
  void setRecentActionsLimit(int limit) {
    if (limit == _recentActionsLimit) {
      return;
    }
    _recentActionsLimit = limit;
    notifyListeners();
    unawaited(
      _store.saveRecentActionsLimit(limit).catchError((_) {
        // Persistence errors should not block UI updates.
      }),
    );
  }

  Future<void> _restorePersistedSettings() async {
    try {
      final storedLocale = await _store.loadLocale();
      final storedPalette = await _store.loadPalette();
      final storedThemeMode = await _store.loadThemeMode();

      var updated = false;

      if (storedLocale != null && storedLocale != _locale) {
        _locale = storedLocale;
        updated = true;
      }

      if (storedPalette != null && storedPalette != _palette) {
        _palette = storedPalette;
        updated = true;
      }

      if (storedThemeMode != null && storedThemeMode != _themeMode) {
        _themeMode = storedThemeMode;
        updated = true;
      }

      final storedLimit = await _store.loadRecentActionsLimit();
      if (storedLimit != null && storedLimit != _recentActionsLimit) {
        _recentActionsLimit = storedLimit;
        updated = true;
      }

      if (updated) {
        notifyListeners();
      }
    } catch (_) {
      // Ignore persistence errors during restore to keep the app responsive.
    }
  }
}

/// Abstract persistence layer for [AppSettings].
abstract class AppSettingsStore {
  /// Reads the previously stored palette, if any.
  Future<AppColorPalette?> loadPalette();

  /// Persists the palette selection.
  Future<void> savePalette(AppColorPalette palette);

  /// Reads the previously stored locale, if any.
  Future<Locale?> loadLocale();

  /// Persists the locale selection.
  Future<void> saveLocale(Locale locale);

  /// Reads the previously stored theme mode, if any.
  Future<ThemeMode?> loadThemeMode();

  /// Persists the theme mode selection.
  Future<void> saveThemeMode(ThemeMode mode);

  /// Reads the previously stored recent actions limit, if any.
  Future<int?> loadRecentActionsLimit();

  /// Persists the recent actions limit selection.
  Future<void> saveRecentActionsLimit(int limit);
}

/// Stores the palette selection using `SharedPreferences`.
class SharedPreferencesAppSettingsStore implements AppSettingsStore {
  /// Creates the store with an optional preferences instance override.
  const SharedPreferencesAppSettingsStore({SharedPreferences? preferences})
      : _preferences = preferences;

  static const _paletteKey = 'presentation.palette';
  static const _localeKey = 'presentation.locale';
  static const _themeModeKey = 'presentation.themeMode';
  static const _recentActionsLimitKey = 'presentation.recentActionsLimit';

  final SharedPreferences? _preferences;

  @override
  Future<AppColorPalette?> loadPalette() async {
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      final paletteName = prefs.getString(_paletteKey);
      if (paletteName == null) {
        return null;
      }
      return _matchPalette(paletteName);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> savePalette(AppColorPalette palette) async {
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      await prefs.setString(_paletteKey, palette.name);
    } catch (_) {
      // Ignore persistence errors silently.
    }
  }

  @override
  Future<Locale?> loadLocale() async {
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      final localeTag = prefs.getString(_localeKey);
      if (localeTag == null || localeTag.isEmpty) {
        return null;
      }
      final parsed = _parseLocale(localeTag);
      return _matchSupportedLocale(parsed);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, _toTag(locale));
    } catch (_) {
      // Ignore persistence errors silently.
    }
  }

  @override
  Future<ThemeMode?> loadThemeMode() async {
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      final modeName = prefs.getString(_themeModeKey);
      if (modeName == null) {
        return null;
      }
      return _matchThemeMode(modeName);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode.name);
    } catch (_) {
      // Ignore persistence errors silently.
    }
  }

  @override
  Future<int?> loadRecentActionsLimit() async {
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      return prefs.getInt(_recentActionsLimitKey);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveRecentActionsLimit(int limit) async {
    try {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      await prefs.setInt(_recentActionsLimitKey, limit);
    } catch (_) {
      // Ignore persistence errors silently.
    }
  }

  AppColorPalette? _matchPalette(String stored) {
    for (final palette in AppColorPalette.values) {
      if (palette.name == stored) {
        return palette;
      }
    }
    return null;
  }

  ThemeMode? _matchThemeMode(String stored) {
    for (final mode in ThemeMode.values) {
      if (mode.name == stored) {
        return mode;
      }
    }
    return null;
  }

  Locale? _parseLocale(String tag) {
    final normalized = tag.replaceAll('_', '-');
    final segments = normalized.split('-');
    if (segments.isEmpty || segments.first.isEmpty) {
      return null;
    }

    final languageCode = segments.first;
    String? scriptCode;
    String? countryCode;

    if (segments.length >= 2) {
      if (segments[1].length == 2 || segments[1].length == 3) {
        countryCode = segments[1];
      } else {
        scriptCode = segments[1];
        if (segments.length >= 3) {
          countryCode = segments[2];
        }
      }
    }

    return Locale.fromSubtags(
      languageCode: languageCode,
      scriptCode: scriptCode,
      countryCode: countryCode,
    );
  }

  Locale? _matchSupportedLocale(Locale? locale) {
    if (locale == null) {
      return null;
    }

    for (final supported in AppLocalizations.supportedLocales) {
      if (supported == locale) {
        return supported;
      }
    }

    final targetLanguage = locale.languageCode.toLowerCase();
    for (final supported in AppLocalizations.supportedLocales) {
      if (supported.languageCode.toLowerCase() == targetLanguage) {
        return supported;
      }
    }

    return null;
  }

  String _toTag(Locale locale) {
    final segments = <String>[locale.languageCode];
    final scriptCode = locale.scriptCode;
    final countryCode = locale.countryCode;
    if (scriptCode != null && scriptCode.isNotEmpty) {
      segments.add(scriptCode);
    }
    if (countryCode != null && countryCode.isNotEmpty) {
      segments.add(countryCode);
    }
    return segments.join('-');
  }
}
