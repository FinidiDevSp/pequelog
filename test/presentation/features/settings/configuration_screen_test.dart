import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/app_settings.dart';
import 'package:pequelog/presentation/features/settings/configuration_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('changes the locale when selecting a different language', (tester) async {
    final settings = AppSettings();

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
  });
}
