import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/onboarding/onboarding_page.dart';

void main() {
  group('OnboardingPage', () {
    testWidgets('renders the brand logo on load', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const OnboardingPage(),
        ),
      );

      final logoFinder = find.byType(Image);
      expect(logoFinder, findsOneWidget);

      final imageWidget = tester.widget<Image>(logoFinder);
      final assetImage = imageWidget.image;

      expect(assetImage, isA<AssetImage>());
      expect((assetImage as AssetImage).assetName, 'assets/logo.png');
    });
  });
}
