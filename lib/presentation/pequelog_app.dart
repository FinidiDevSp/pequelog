import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/data/babies/sqlite_baby_repository.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/app_settings.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/presentation/features/settings/configuration_screen.dart';
import 'package:pequelog/presentation/features/startup/baby_home_screen.dart';
import 'package:pequelog/presentation/features/startup/baby_state.dart';
import 'package:pequelog/presentation/features/startup/setup_screen.dart';
import 'package:provider/provider.dart';

const _appBackground = Color(0xFFFBFBF1);
const _appAccent = Color(0xFF3F4C5A);

/// Root widget that decides the initial route depending on stored babies.
class PequeLogApp extends StatelessWidget {
  /// Builds the app with optional overrides that ease testing.
  PequeLogApp({
    super.key,
    BabyRepository? repository,
    ImagePickerService? imagePicker,
    DatePickerLauncher? datePicker,
    TimePickerLauncher? timePicker,
    AppSettings? settings,
  }) : _repository = repository ?? SQLiteBabyRepository(),
       _imagePicker = imagePicker ?? DeviceImagePickerService(),
       _datePicker = datePicker,
       _timePicker = timePicker,
       _settingsOverride = settings;

  final BabyRepository _repository;
  final ImagePickerService _imagePicker;
  final DatePickerLauncher? _datePicker;
  final TimePickerLauncher? _timePicker;
  final AppSettings? _settingsOverride;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        if (_settingsOverride != null)
          ChangeNotifierProvider<AppSettings>.value(value: _settingsOverride!)
        else
          ChangeNotifierProvider<AppSettings>(create: (_) => AppSettings()),
        ChangeNotifierProvider<BabyState>(
          create: (_) => BabyState(repository: _repository)..load(),
        ),
      ],
      child: Consumer<AppSettings>(
        builder: (context, settings, _) {
          return MaterialApp(
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: _buildTheme(),
            locale: settings.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: _StartupRouter(
              imagePicker: _imagePicker,
              datePicker: _datePicker,
              timePicker: _timePicker,
            ),
          );
        },
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
  const _StartupRouter({
    required this.imagePicker,
    required this.datePicker,
    required this.timePicker,
  });

  final ImagePickerService imagePicker;
  final DatePickerLauncher? datePicker;
  final TimePickerLauncher? timePicker;

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
                    builder: (_) => NewBabyScreen(
                      imagePicker: imagePicker,
                      datePicker: datePicker,
                      timePicker: timePicker,
                    ),
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
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.errorLoadingMessage),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                unawaited(onRetry());
              },
              child: Text(l10n.retryButton),
            ),
          ],
        ),
      ),
    );
  }
}
