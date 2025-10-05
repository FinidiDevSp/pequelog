import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/main.dart';
import 'package:pequelog/presentation/features/onboarding/onboarding_page.dart';

void main() {
  group('OnboardingPage', () {
    testWidgets('renders the brand logo on load', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: OnboardingPage()),
      );

      final logoFinder = find.byType(Image);
      expect(logoFinder, findsOneWidget);

      final imageWidget = tester.widget<Image>(logoFinder);
      final assetImage = imageWidget.image;

      expect(assetImage, isA<AssetImage>());
      expect((assetImage as AssetImage).assetName, 'assets/logo.png');
    });

    testWidgets('is the initial route for PequeLogApp', (tester) async {
      await tester.pumpWidget(const PequeLogApp());

      expect(find.byType(OnboardingPage), findsOneWidget);
    });
  });
}
