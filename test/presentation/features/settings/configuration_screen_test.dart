import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/app_settings.dart';
import 'package:pequelog/presentation/features/settings/configuration_screen.dart';
import 'package:provider/provider.dart';

import 'package:pequelog/presentation/theme/app_color_palettes.dart';

void main() {
  testWidgets('changes the locale when selecting a different language', (tester) async {
    final store = _FakeAppSettingsStore();
    final settings = AppSettings(store: store);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppSettings>.value(
        value: settings,
        child: MaterialApp(
          locale: settings.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ConfigurationScreen(),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('configuration_language')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Inglés').last);
    await tester.pumpAndSettle();

    expect(settings.locale.languageCode, 'en');
    expect(store.savedLocale?.languageCode, 'en');
  });

  testWidgets('updates the palette when selecting a different option and persists it', (tester) async {
    final store = _FakeAppSettingsStore();
    final settings = AppSettings(store: store);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppSettings>.value(
        value: settings,
        child: MaterialApp(
          locale: settings.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ConfigurationScreen(),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('configuration_palette')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Brisa de menta').last);
    await tester.pumpAndSettle();

    expect(settings.palette, AppColorPalette.mintWhisper);
    expect(store.savedPalette, AppColorPalette.mintWhisper);
  });

  testWidgets('updates the theme mode when selecting a different option and persists it', (tester) async {
    final store = _FakeAppSettingsStore();
    final settings = AppSettings(store: store);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppSettings>.value(
        value: settings,
        child: MaterialApp(
          locale: settings.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ConfigurationScreen(),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('configuration_theme_mode')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Siempre oscuro').last);
    await tester.pumpAndSettle();

    expect(settings.themeMode, ThemeMode.dark);
    expect(store.savedThemeMode, ThemeMode.dark);
  });

  testWidgets('shows the palette preview for both light and dark variants', (tester) async {
    final store = _FakeAppSettingsStore();
    final settings = AppSettings(store: store);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppSettings>.value(
        value: settings,
        child: MaterialApp(
          locale: settings.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ConfigurationScreen(),
        ),
      ),
    );

    await tester.pump();

    final lightAccent = tester.widget<Container>(
      find.byKey(const Key('palette_preview_light_accent')),
    );
    final darkAccent = tester.widget<Container>(
      find.byKey(const Key('palette_preview_dark_accent')),
    );
    final mockupButton = tester.widget<Container>(
      find.byKey(const Key('palette_preview_light_mockup_accent_button')),
    );

    final lightDecoration = lightAccent.decoration! as BoxDecoration;
    final darkDecoration = darkAccent.decoration! as BoxDecoration;
    final mockupDecoration = mockupButton.decoration! as BoxDecoration;

    expect(lightDecoration.color, settings.palette.colors.light.accent);
    expect(darkDecoration.color, settings.palette.colors.dark.accent);
    expect(mockupDecoration.color, settings.palette.colors.light.accent);
  });

  testWidgets('restores stored palette, locale, and theme mode when available', (tester) async {
    final store = _FakeAppSettingsStore()
      ..savedPalette = AppColorPalette.lavenderField;
      ..savedLocale = const Locale('en')
      ..savedThemeMode = ThemeMode.dark;
    final settings = AppSettings(store: store);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppSettings>.value(
        value: settings,
        child: MaterialApp(
          locale: settings.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ConfigurationScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(settings.palette, AppColorPalette.lavenderField);
    expect(settings.locale.languageCode, 'en');
    expect(settings.themeMode, ThemeMode.dark);
    expect(
      (tester.widget<Container>(
        find.byKey(const Key('palette_preview_light_accent')),
      ).decoration! as BoxDecoration)
          .color,
      AppColorPalette.lavenderField.colors.light.accent,
    );
  });
}

class _FakeAppSettingsStore implements AppSettingsStore {
  AppColorPalette? savedPalette;
  Locale? savedLocale;
  ThemeMode? savedThemeMode;

  @override
  Future<AppColorPalette?> loadPalette() async => savedPalette;

  @override
  Future<void> savePalette(AppColorPalette palette) async {
    savedPalette = palette;
  }

  @override
  Future<Locale?> loadLocale() async => savedLocale;

  @override
  Future<void> saveLocale(Locale locale) async {
    savedLocale = locale;
  }

  @override
  Future<ThemeMode?> loadThemeMode() async => savedThemeMode;

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    savedThemeMode = mode;
  }
}
