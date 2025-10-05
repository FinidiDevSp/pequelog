import 'package:flutter/material.dart';
import 'package:pequelog/presentation/features/onboarding/onboarding_page.dart';

const _appBackground = Color(0xFFFBFBF1);
const _appAccent = Color(0xFF3F4C5A);

/// Bootstraps the PequeLog application.
void main() {
  runApp(const PequeLogApp());
}

/// Root widget that applies theming and the initial navigation flow.
class PequeLogApp extends StatelessWidget {
  /// Creates the root configuration for PequeLog.
  const PequeLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: _appAccent,
      background: _appBackground,
      brightness: Brightness.light,
    );

    final colorScheme = baseScheme.copyWith(
      surface: _appBackground,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      primary: _appAccent,
      onPrimary: Colors.white,
    );

    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _appBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: _appBackground,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
        backgroundColor: _appAccent,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _appAccent,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );

    return MaterialApp(
      title: 'PequeLog',
      theme: theme,
      home: const OnboardingPage(),
    );
  }
}
