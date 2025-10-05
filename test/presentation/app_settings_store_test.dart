import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/presentation/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesAppSettingsStore.loadLocale', () {
    setUp(() {
      SharedPreferences.setMockInitialValues(<String, Object?>{});
    });

    test('returns supported locale when stored tag includes region', () async {
      SharedPreferences.setMockInitialValues(<String, Object?>{
        'presentation.locale': 'es-ES',
      });

      const store = SharedPreferencesAppSettingsStore();

      final locale = await store.loadLocale();

      expect(locale, const Locale('es'));
    });

    test('returns null when stored locale is unsupported', () async {
      SharedPreferences.setMockInitialValues(<String, Object?>{
        'presentation.locale': 'fr',
      });

      const store = SharedPreferencesAppSettingsStore();

      final locale = await store.loadLocale();

      expect(locale, isNull);
    });
  });
}
