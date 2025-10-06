import 'package:flutter/material.dart';import 'package:flutter/material.dart';import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_test/flutter_test.dart';import 'package:flutter_localizations/flutter_localizations.dart';import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:pequelog/l10n/app_localizations.dart';

import 'package:pequelog/presentation/app_settings.dart';import 'package:flutter_test/flutter_test.dart';import 'package:flutter_test/flutter_test.dart';

import 'package:pequelog/presentation/features/settings/configuration_screen.dart';

import 'package:pequelog/presentation/theme/app_color_palettes.dart';import 'package:pequelog/l10n/app_localizations.dart';import 'package:pequelog/l10n/app_localizations.dart';

import 'package:provider/provider.dart';

import 'package:pequelog/presentation/app_settings.dart';import 'package:pequelog/presentation/app_settings.dart';

void main() {

  group('ConfigurationScreen', () {import 'package:pequelog/presentation/features/settings/configuration_screen.dart';import 'package:pequelog/presentation/features/settings/configuration_screen.dart';

    testWidgets('displays language options', (tester) async {

      final store = _FakeAppSettingsStore();import 'package:pequelog/presentation/theme/app_color_palettes.dart';import 'package:provider/provider.dart';

      final settings = AppSettings(store: store);

import 'package:provider/provider.dart';

      await tester.pumpWidget(

        ChangeNotifierProvider<AppSettings>.value(import 'package:pequelog/presentation/theme/app_color_palettes.dart';

          value: settings,

          child: MaterialApp(void main() {

            locale: settings.locale,

            localizationsDelegates: const [  group('ConfigurationScreen', () {void main() {

              AppLocalizations.delegate,

              GlobalMaterialLocalizations.delegate,    testWidgets('displays language options', (tester) async {  testWidgets('changes the locale when selecting a different language', (tester) async {

              GlobalWidgetsLocalizations.delegate,

              GlobalCupertinoLocalizations.delegate,      final store = _FakeAppSettingsStore();    final store = _FakeAppSettingsStore();

            ],

            supportedLocales: AppLocalizations.supportedLocales,      final settings = AppSettings(store: store);    final settings = AppSettings(store: store);

            home: const ConfigurationScreen(),

          ),

        ),

      );      await tester.pumpWidget(    await tester.pumpWidget(



      await tester.pumpAndSettle();        ChangeNotifierProvider<AppSettings>.value(      ChangeNotifierProvider<AppSettings>.value(



      expect(find.text('Español'), findsOneWidget);          value: settings,        value: settings,

      expect(find.text('English'), findsOneWidget);

    });          child: MaterialApp(        child: MaterialApp(



    testWidgets('changes language when tapping on language option',            locale: settings.locale,          locale: settings.locale,

        (tester) async {

      final store = _FakeAppSettingsStore();            localizationsDelegates: const [          localizationsDelegates: const [

      final settings = AppSettings(store: store);

              AppLocalizations.delegate,            AppLocalizations.delegate,

      await tester.pumpWidget(

        ChangeNotifierProvider<AppSettings>.value(              GlobalMaterialLocalizations.delegate,            GlobalMaterialLocalizations.delegate,

          value: settings,

          child: MaterialApp(              GlobalWidgetsLocalizations.delegate,            GlobalWidgetsLocalizations.delegate,

            locale: settings.locale,

            localizationsDelegates: const [              GlobalCupertinoLocalizations.delegate,            GlobalCupertinoLocalizations.delegate,

              AppLocalizations.delegate,

              GlobalMaterialLocalizations.delegate,            ],          ],

              GlobalWidgetsLocalizations.delegate,

              GlobalCupertinoLocalizations.delegate,            supportedLocales: AppLocalizations.supportedLocales,          supportedLocales: AppLocalizations.supportedLocales,

            ],

            supportedLocales: AppLocalizations.supportedLocales,            home: const ConfigurationScreen(),          home: const ConfigurationScreen(),

            home: const ConfigurationScreen(),

          ),          ),        ),

        ),

      );        ),      ),



      await tester.pumpAndSettle();      );    );



      // Default should be Spanish

      expect(settings.locale.languageCode, 'es');

      await tester.pumpAndSettle();    await tester.tap(find.byKey(const Key('configuration_language')));

      // Tap English option

      await tester.tap(find.text('English'));    await tester.pumpAndSettle();

      await tester.pumpAndSettle();

      // Should display Spanish and English options

      // Should change to English

      expect(settings.locale.languageCode, 'en');      expect(find.text('Español'), findsOneWidget);    await tester.tap(find.text('Inglés').last);

      expect(store.savedLocale?.languageCode, 'en');

    });      expect(find.text('Inglés'), findsOneWidget);    await tester.pumpAndSettle();



    testWidgets('displays all color palette options', (tester) async {    });

      final store = _FakeAppSettingsStore();

      final settings = AppSettings(store: store);    expect(settings.locale.languageCode, 'en');



      await tester.pumpWidget(    testWidgets('changes language when tapping on language option',    expect(store.savedLocale?.languageCode, 'en');

        ChangeNotifierProvider<AppSettings>.value(

          value: settings,        (tester) async {  });

          child: MaterialApp(

            locale: settings.locale,      final store = _FakeAppSettingsStore();

            localizationsDelegates: const [

              AppLocalizations.delegate,      final settings = AppSettings(store: store);  testWidgets('updates the palette when selecting a different option and persists it', (tester) async {

              GlobalMaterialLocalizations.delegate,

              GlobalWidgetsLocalizations.delegate,    final store = _FakeAppSettingsStore();

              GlobalCupertinoLocalizations.delegate,

            ],      await tester.pumpWidget(    final settings = AppSettings(store: store);

            supportedLocales: AppLocalizations.supportedLocales,

            home: const ConfigurationScreen(),        ChangeNotifierProvider<AppSettings>.value(

          ),

        ),          value: settings,    await tester.pumpWidget(

      );

          child: MaterialApp(      ChangeNotifierProvider<AppSettings>.value(

      await tester.pumpAndSettle();

            locale: settings.locale,        value: settings,

      expect(find.text('Lavender Field'), findsOneWidget);

      expect(find.text('Mint Whisper'), findsOneWidget);            localizationsDelegates: const [        child: MaterialApp(

      expect(find.text('Peach Blossom'), findsOneWidget);

      expect(find.text('Sky Dream'), findsOneWidget);              AppLocalizations.delegate,          locale: settings.locale,

    });

              GlobalMaterialLocalizations.delegate,          localizationsDelegates: const [

    testWidgets('changes palette when tapping on palette option',

        (tester) async {              GlobalWidgetsLocalizations.delegate,            AppLocalizations.delegate,

      final store = _FakeAppSettingsStore();

      final settings = AppSettings(store: store);              GlobalCupertinoLocalizations.delegate,            GlobalMaterialLocalizations.delegate,



      await tester.pumpWidget(            ],            GlobalWidgetsLocalizations.delegate,

        ChangeNotifierProvider<AppSettings>.value(

          value: settings,            supportedLocales: AppLocalizations.supportedLocales,            GlobalCupertinoLocalizations.delegate,

          child: MaterialApp(

            locale: settings.locale,            home: const ConfigurationScreen(),          ],

            localizationsDelegates: const [

              AppLocalizations.delegate,          ),          supportedLocales: AppLocalizations.supportedLocales,

              GlobalMaterialLocalizations.delegate,

              GlobalWidgetsLocalizations.delegate,        ),          home: const ConfigurationScreen(),

              GlobalCupertinoLocalizations.delegate,

            ],      );        ),

            supportedLocales: AppLocalizations.supportedLocales,

            home: const ConfigurationScreen(),      ),

          ),

        ),      await tester.pumpAndSettle();    );

      );



      await tester.pumpAndSettle();

      // Initial locale is Spanish    await tester.tap(find.byKey(const Key('configuration_palette')));

      // Default should be Lavender Field

      expect(settings.palette, AppColorPalette.lavenderField);      expect(settings.locale.languageCode, 'es');    await tester.pumpAndSettle();



      // Tap Mint Whisper option

      await tester.tap(find.text('Mint Whisper'));

      await tester.pumpAndSettle();      // Tap on English option    await tester.tap(find.text('Brisa de menta').last);



      // Should change to Mint Whisper      await tester.tap(find.text('Inglés'));    await tester.pumpAndSettle();

      expect(settings.palette, AppColorPalette.mintWhisper);

      expect(store.savedPalette, AppColorPalette.mintWhisper);      await tester.pumpAndSettle();

    });

    expect(settings.palette, AppColorPalette.mintWhisper);

    testWidgets('shows color preview dots for each palette', (tester) async {

      final store = _FakeAppSettingsStore();      // Locale should change to English    expect(store.savedPalette, AppColorPalette.mintWhisper);

      final settings = AppSettings(store: store);

      expect(settings.locale.languageCode, 'en');  });

      await tester.pumpWidget(

        ChangeNotifierProvider<AppSettings>.value(      expect(store.savedLocale?.languageCode, 'en');

          value: settings,

          child: MaterialApp(    });  testWidgets('updates the theme mode when selecting a different option and persists it', (tester) async {

            locale: settings.locale,

            localizationsDelegates: const [    final store = _FakeAppSettingsStore();

              AppLocalizations.delegate,

              GlobalMaterialLocalizations.delegate,    testWidgets('displays all color palette options', (tester) async {    final settings = AppSettings(store: store);

              GlobalWidgetsLocalizations.delegate,

              GlobalCupertinoLocalizations.delegate,      final store = _FakeAppSettingsStore();

            ],

            supportedLocales: AppLocalizations.supportedLocales,      final settings = AppSettings(store: store);    await tester.pumpWidget(

            home: const ConfigurationScreen(),

          ),      ChangeNotifierProvider<AppSettings>.value(

        ),

      );      await tester.pumpWidget(        value: settings,



      await tester.pumpAndSettle();        ChangeNotifierProvider<AppSettings>.value(        child: MaterialApp(



      // Find all Container widgets with circular decoration (color dots)          value: settings,          locale: settings.locale,

      final colorDots = find.byWidgetPredicate(

        (widget) =>          child: MaterialApp(          localizationsDelegates: const [

            widget is Container &&

            widget.decoration != null &&            locale: settings.locale,            AppLocalizations.delegate,

            widget.decoration is BoxDecoration &&

            (widget.decoration as BoxDecoration).shape == BoxShape.circle,            localizationsDelegates: const [            GlobalMaterialLocalizations.delegate,

      );

              AppLocalizations.delegate,            GlobalWidgetsLocalizations.delegate,

      // Should have 12 dots: 4 palettes * 3 colors each

      expect(colorDots, findsNWidgets(12));              GlobalMaterialLocalizations.delegate,            GlobalCupertinoLocalizations.delegate,

    });

              GlobalWidgetsLocalizations.delegate,          ],

    testWidgets('highlights selected language option', (tester) async {

      final store = _FakeAppSettingsStore();              GlobalCupertinoLocalizations.delegate,          supportedLocales: AppLocalizations.supportedLocales,

      final settings = AppSettings(store: store);

            ],          home: const ConfigurationScreen(),

      await tester.pumpWidget(

        ChangeNotifierProvider<AppSettings>.value(            supportedLocales: AppLocalizations.supportedLocales,        ),

          value: settings,

          child: MaterialApp(            home: const ConfigurationScreen(),      ),

            locale: settings.locale,

            localizationsDelegates: const [          ),    );

              AppLocalizations.delegate,

              GlobalMaterialLocalizations.delegate,        ),

              GlobalWidgetsLocalizations.delegate,

              GlobalCupertinoLocalizations.delegate,      );    await tester.tap(find.byKey(const Key('configuration_theme_mode')));

            ],

            supportedLocales: AppLocalizations.supportedLocales,    await tester.pumpAndSettle();

            home: const ConfigurationScreen(),

          ),      await tester.pumpAndSettle();

        ),

      );    await tester.tap(find.text('Siempre oscuro').last);



      await tester.pumpAndSettle();      // Should display all palette options    await tester.pumpAndSettle();



      // Find radio button checked icons      expect(find.text('Amanecer rosado'), findsOneWidget);

      final checkedIcons =

          find.byIcon(Icons.radio_button_checked).evaluate().toList();      expect(find.text('Brisa de menta'), findsOneWidget);    expect(settings.themeMode, ThemeMode.dark);



      // Should have 2: one for selected language, one for selected palette      expect(find.text('Cielo suave'), findsOneWidget);    expect(store.savedThemeMode, ThemeMode.dark);

      expect(checkedIcons.length, 2);

    });      expect(find.text('Campo de lavanda'), findsOneWidget);  });



    testWidgets('highlights selected palette option', (tester) async {    });

      final store = _FakeAppSettingsStore();

      final settings = AppSettings(store: store);  testWidgets('shows the palette preview for both light and dark variants', (tester) async {



      await tester.pumpWidget(    testWidgets('changes palette when tapping on palette option',    final store = _FakeAppSettingsStore();

        ChangeNotifierProvider<AppSettings>.value(

          value: settings,        (tester) async {    final settings = AppSettings(store: store);

          child: MaterialApp(

            locale: settings.locale,      final store = _FakeAppSettingsStore();

            localizationsDelegates: const [

              AppLocalizations.delegate,      final settings = AppSettings(store: store);    await tester.pumpWidget(

              GlobalMaterialLocalizations.delegate,

              GlobalWidgetsLocalizations.delegate,      ChangeNotifierProvider<AppSettings>.value(

              GlobalCupertinoLocalizations.delegate,

            ],      await tester.pumpWidget(        value: settings,

            supportedLocales: AppLocalizations.supportedLocales,

            home: const ConfigurationScreen(),        ChangeNotifierProvider<AppSettings>.value(        child: MaterialApp(

          ),

        ),          value: settings,          locale: settings.locale,

      );

          child: MaterialApp(          localizationsDelegates: const [

      await tester.pumpAndSettle();

            locale: settings.locale,            AppLocalizations.delegate,

      // Tap Peach Blossom

      await tester.tap(find.text('Peach Blossom'));            localizationsDelegates: const [            GlobalMaterialLocalizations.delegate,

      await tester.pumpAndSettle();

              AppLocalizations.delegate,            GlobalWidgetsLocalizations.delegate,

      // Verify it's now selected

      expect(settings.palette, AppColorPalette.peachBlossom);              GlobalMaterialLocalizations.delegate,            GlobalCupertinoLocalizations.delegate,



      // Find all checked radio buttons              GlobalWidgetsLocalizations.delegate,          ],

      final checkedIcons =

          find.byIcon(Icons.radio_button_checked).evaluate().toList();              GlobalCupertinoLocalizations.delegate,          supportedLocales: AppLocalizations.supportedLocales,



      // Should still be 2 (one language, one palette)            ],          home: const ConfigurationScreen(),

      expect(checkedIcons.length, 2);

    });            supportedLocales: AppLocalizations.supportedLocales,        ),

  });

}            home: const ConfigurationScreen(),      ),



class _FakeAppSettingsStore implements AppSettingsStore {          ),    );

  Locale? savedLocale;

  AppColorPalette? savedPalette;        ),

  ThemeMode? savedThemeMode;

      );    await tester.pump();

  @override

  Future<Locale?> loadLocale() async => savedLocale;



  @override      await tester.pumpAndSettle();    final lightAccent = tester.widget<Container>(

  Future<AppColorPalette?> loadPalette() async => savedPalette;

      find.byKey(const Key('palette_preview_light_accent')),

  @override

  Future<ThemeMode?> loadThemeMode() async => savedThemeMode;      // Initial palette is dawnBlush    );



  @override      expect(settings.palette, AppColorPalette.dawnBlush);    final darkAccent = tester.widget<Container>(

  Future<void> saveLocale(Locale locale) async {

    savedLocale = locale;      find.byKey(const Key('palette_preview_dark_accent')),

  }

      // Tap on mintWhisper option    );

  @override

  Future<void> savePalette(AppColorPalette palette) async {      await tester.tap(find.text('Brisa de menta'));    final mockupButton = tester.widget<Container>(

    savedPalette = palette;

  }      await tester.pumpAndSettle();      find.byKey(const Key('palette_preview_light_mockup_accent_button')),



  @override    );

  Future<void> saveThemeMode(ThemeMode mode) async {

    savedThemeMode = mode;      // Palette should change to mintWhisper

  }

}      expect(settings.palette, AppColorPalette.mintWhisper);    final lightDecoration = lightAccent.decoration! as BoxDecoration;


      expect(store.savedPalette, AppColorPalette.mintWhisper);    final darkDecoration = darkAccent.decoration! as BoxDecoration;

    });    final mockupDecoration = mockupButton.decoration! as BoxDecoration;



    testWidgets('shows color preview dots for each palette', (tester) async {    expect(lightDecoration.color, settings.palette.colors.light.accent);

      final store = _FakeAppSettingsStore();    expect(darkDecoration.color, settings.palette.colors.dark.accent);

      final settings = AppSettings(store: store);    expect(mockupDecoration.color, settings.palette.colors.light.accent);

  });

      await tester.pumpWidget(

        ChangeNotifierProvider<AppSettings>.value(  testWidgets('restores stored palette, locale, and theme mode when available', (tester) async {

          value: settings,    final store = _FakeAppSettingsStore()

          child: MaterialApp(      ..savedPalette = AppColorPalette.lavenderField

            locale: settings.locale,      ..savedLocale = const Locale('en')

            localizationsDelegates: const [      ..savedThemeMode = ThemeMode.dark;

              AppLocalizations.delegate,    final settings = AppSettings(store: store);

              GlobalMaterialLocalizations.delegate,

              GlobalWidgetsLocalizations.delegate,    await tester.pumpWidget(

              GlobalCupertinoLocalizations.delegate,      ChangeNotifierProvider<AppSettings>.value(

            ],        value: settings,

            supportedLocales: AppLocalizations.supportedLocales,        child: MaterialApp(

            home: const ConfigurationScreen(),          locale: settings.locale,

          ),          localizationsDelegates: const [

        ),            AppLocalizations.delegate,

      );            GlobalMaterialLocalizations.delegate,

            GlobalWidgetsLocalizations.delegate,

      await tester.pumpAndSettle();            GlobalCupertinoLocalizations.delegate,

          ],

      // Should have color dots for each palette (4 palettes × 3 colors = 12 dots)          supportedLocales: AppLocalizations.supportedLocales,

      final colorDots = find.byType(Container).evaluate().where((element) {          home: const ConfigurationScreen(),

        final widget = element.widget as Container;        ),

        final decoration = widget.decoration;      ),

        return decoration is BoxDecoration && decoration.shape == BoxShape.circle;    );

      });

    await tester.pump();

      expect(colorDots.length, 12);

    });    expect(settings.palette, AppColorPalette.lavenderField);

    expect(settings.locale.languageCode, 'en');

    testWidgets('highlights selected language option', (tester) async {    expect(settings.themeMode, ThemeMode.dark);

      final store = _FakeAppSettingsStore();    expect(

      final settings = AppSettings(store: store);      (tester.widget<Container>(

        find.byKey(const Key('palette_preview_light_accent')),

      await tester.pumpWidget(      ).decoration! as BoxDecoration)

        ChangeNotifierProvider<AppSettings>.value(          .color,

          value: settings,      AppColorPalette.lavenderField.colors.light.accent,

          child: MaterialApp(    );

            locale: settings.locale,  });

            localizationsDelegates: const [}

              AppLocalizations.delegate,

              GlobalMaterialLocalizations.delegate,class _FakeAppSettingsStore implements AppSettingsStore {

              GlobalWidgetsLocalizations.delegate,  AppColorPalette? savedPalette;

              GlobalCupertinoLocalizations.delegate,  Locale? savedLocale;

            ],  ThemeMode? savedThemeMode;

            supportedLocales: AppLocalizations.supportedLocales,

            home: const ConfigurationScreen(),  @override

          ),  Future<AppColorPalette?> loadPalette() async => savedPalette;

        ),

      );  @override

  Future<void> savePalette(AppColorPalette palette) async {

      await tester.pumpAndSettle();    savedPalette = palette;

  }

      // Spanish should be selected (shows checked radio button)

      final checkedIcons =  @override

          find.byIcon(Icons.radio_button_checked).evaluate().toList();  Future<Locale?> loadLocale() async => savedLocale;

      expect(checkedIcons.length, 2); // One for language, one for palette

    });  @override

  Future<void> saveLocale(Locale locale) async {

    testWidgets('highlights selected palette option', (tester) async {    savedLocale = locale;

      final store = _FakeAppSettingsStore();  }

      final settings = AppSettings(store: store);

  @override

      await tester.pumpWidget(  Future<ThemeMode?> loadThemeMode() async => savedThemeMode;

        ChangeNotifierProvider<AppSettings>.value(

          value: settings,  @override

          child: MaterialApp(  Future<void> saveThemeMode(ThemeMode mode) async {

            locale: settings.locale,    savedThemeMode = mode;

            localizationsDelegates: const [  }

              AppLocalizations.delegate,}

              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const ConfigurationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // dawnBlush should be selected
      final checkedIcons =
          find.byIcon(Icons.radio_button_checked).evaluate().toList();
      expect(checkedIcons.length, 2); // One for language, one for palette
    });
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
