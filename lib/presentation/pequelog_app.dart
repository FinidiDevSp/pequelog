import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/data/babies/sqlite_baby_repository.dart';
import 'package:pequelog/data/baby_actions/sqlite_baby_action_repository.dart';
import 'package:pequelog/data/sqlite_database.dart';
import 'package:pequelog/domain/baby_actions/repositories/baby_action_repository.dart';
import 'package:pequelog/domain/baby_actions/usecases/get_recent_baby_actions.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_bath_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_diaper_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_feed_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_vomit_action.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/app_settings.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/presentation/features/settings/configuration_screen.dart';
import 'package:pequelog/presentation/features/startup/baby_home_screen.dart';
import 'package:pequelog/presentation/features/startup/baby_state.dart';
import 'package:pequelog/presentation/features/startup/setup_screen.dart';
import 'package:pequelog/presentation/theme/app_color_palettes.dart';
import 'package:provider/provider.dart';

/// Root widget that decides the initial route depending on stored babies.
class PequeLogApp extends StatelessWidget {
  /// Builds the app with optional overrides that ease testing.
  PequeLogApp({
    super.key,
    BabyRepository? repository,
    BabyActionRepository? actionRepository,
    SQLiteDatabaseProvider? databaseProvider,
    ImagePickerService? imagePicker,
    DatePickerLauncher? datePicker,
    TimePickerLauncher? timePicker,
    AppSettings? settings,
  })  : _databaseProvider = databaseProvider ?? SQLiteDatabaseProvider(),
        _repository =
            repository ?? SQLiteBabyRepository(database: _databaseProvider),
        _actionRepository = actionRepository ??
            SQLiteBabyActionRepository(database: _databaseProvider),
        _imagePicker = imagePicker ?? DeviceImagePickerService(),
        _datePicker = datePicker,
        _timePicker = timePicker,
        _settingsOverride = settings;

  final SQLiteDatabaseProvider _databaseProvider;
  final BabyRepository _repository;
  final BabyActionRepository _actionRepository;
  final ImagePickerService _imagePicker;
  final DatePickerLauncher? _datePicker;
  final TimePickerLauncher? _timePicker;
  final AppSettings? _settingsOverride;

  BabyActionsState _createActionsState() {
    return BabyActionsState(
      getRecentActions: GetRecentBabyActions(repository: _actionRepository),
      logFeedAction: LogFeedAction(repository: _actionRepository),
      logBathAction: LogBathAction(repository: _actionRepository),
      logVomitAction: LogVomitAction(repository: _actionRepository),
      logDiaperAction: LogDiaperAction(repository: _actionRepository),
    );
  }

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
        ChangeNotifierProxyProvider<BabyState, BabyActionsState>(
          create: (_) => _createActionsState(),
          update: (_, babyState, actionsState) {
            actionsState ??= _createActionsState();
            actionsState.updateBabyId(babyState.selectedBaby?.id);
            return actionsState;
          },
        ),
      ],
      child: Consumer<AppSettings>(
        builder: (context, settings, _) {
          return MaterialApp(
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: _buildTheme(settings.palette, Brightness.light),
            darkTheme: _buildTheme(settings.palette, Brightness.dark),
            themeMode: settings.themeMode,
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

ThemeData _buildTheme(AppColorPalette palette, Brightness brightness) {
  final paletteColors = palette.colors;
  final variant =
      brightness == Brightness.dark ? paletteColors.dark : paletteColors.light;

  final baseScheme = ColorScheme.fromSeed(
    seedColor: paletteColors.seed,
    brightness: brightness,
  );

  final colorScheme = baseScheme.copyWith(
    background: variant.background,
    surface: variant.surface,
    onSurface: variant.onSurface,
    onBackground: variant.onBackground,
    primary: variant.accent,
    onPrimary: variant.onAccent,
    secondary: variant.accent,
    onSecondary: variant.onAccent,
  );

  final borderColor = variant.onSurface.withOpacity(0.14);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: variant.background,
    appBarTheme: AppBarTheme(
      backgroundColor: variant.surface,
      foregroundColor: variant.onSurface,
      elevation: 0,
      centerTitle: true,
    ),
    cardColor: variant.surface,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: variant.accent,
      foregroundColor: variant.onAccent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: variant.accent,
        foregroundColor: variant.onAccent,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor:
          brightness == Brightness.light ? variant.surface : variant.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: variant.accent),
      ),
      labelStyle: TextStyle(color: variant.onSurface.withOpacity(0.8)),
      helperStyle: TextStyle(color: variant.onSurface.withOpacity(0.7)),
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
            return BabyHomeScreen(
              baby: baby,
              imagePicker: imagePicker,
              datePicker: datePicker,
              timePicker: timePicker,
            );
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
