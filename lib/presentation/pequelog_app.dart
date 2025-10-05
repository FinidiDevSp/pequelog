import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pequelog/data/babies/sqlite_baby_repository.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/presentation/features/settings/configuration_screen.dart';
import 'package:pequelog/presentation/features/startup/baby_home_screen.dart';
import 'package:pequelog/presentation/features/startup/baby_state.dart';
import 'package:pequelog/presentation/features/startup/setup_screen.dart';

const _appBackground = Color(0xFFFBFBF1);
const _appAccent = Color(0xFF3F4C5A);

/// Root widget that decides the initial route depending on stored babies.
class PequeLogApp extends StatelessWidget {
  /// Builds the app with an optional [BabyRepository] override (useful in tests).
  PequeLogApp({super.key, BabyRepository? repository})
      : _repository = repository ?? SQLiteBabyRepository();

  final BabyRepository _repository;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BabyState(repository: _repository)..load(),
      child: MaterialApp(
        title: 'PequeLog',
        theme: _buildTheme(),
        home: const _StartupRouter(),
      ),
    );
  }
}

ThemeData _buildTheme() {
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

  return ThemeData(
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
}

class _StartupRouter extends StatelessWidget {
  const _StartupRouter();

  @override
  Widget build(BuildContext context) {
    return Consumer<BabyState>(
      builder: (context, state, _) {
        switch (state.status) {
          case BabyStatus.loading:
            return const _LoadingScreen();
          case BabyStatus.error:
            return _ErrorScreen(onRetry: state.load);
          case BabyStatus.missingBaby:
            return SetupScreen(
              onConfigure: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ConfigurationScreen(),
                  ),
                );
              },
              onCreateBaby: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const NewBabyScreen(),
                  ),
                );
              },
            );
          case BabyStatus.ready:
            final baby = state.selectedBaby;
            if (baby == null) {
              return _ErrorScreen(onRetry: state.load);
            }
            return BabyHomeScreen(baby: baby);
        }
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ops, algo salio mal al cargar.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () { unawaited(onRetry()); },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
