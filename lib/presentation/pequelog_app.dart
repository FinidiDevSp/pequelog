import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pequelog/core/routing/app_router.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/data/babies/sqlite_baby_repository.dart';
import 'package:pequelog/data/baby_actions/sqlite_baby_action_repository.dart';
import 'package:pequelog/data/sqlite_database.dart';
import 'package:pequelog/domain/baby_actions/repositories/baby_action_repository.dart';
import 'package:pequelog/domain/baby_actions/usecases/delete_baby_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/get_recent_baby_actions.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_bath_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_diaper_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_feed_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/log_vomit_action.dart';
import 'package:pequelog/domain/baby_actions/usecases/update_feed_action.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/app_settings.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';
import 'package:pequelog/presentation/features/baby_actions/feed_timer_state.dart';
import 'package:pequelog/presentation/features/startup/baby_state.dart';
import 'package:pequelog/presentation/features/startup/setup_screen.dart';
import 'package:pequelog/presentation/theme/app_color_palettes.dart';
import 'package:provider/provider.dart';

/// Root widget that decides the initial route depending on stored babies.
class PequeLogApp extends StatelessWidget {
  /// Builds the app with optional overrides that ease testing.
  factory PequeLogApp({
    Key? key,
    BabyRepository? repository,
    BabyActionRepository? actionRepository,
    SQLiteDatabaseProvider? databaseProvider,
    ImagePickerService? imagePicker,
    DatePickerLauncher? datePicker,
    TimePickerLauncher? timePicker,
    AppSettings? settings,
  }) {
    final dbProvider = databaseProvider ?? SQLiteDatabaseProvider();
    final resolvedRepository =
        repository ?? SQLiteBabyRepository(database: dbProvider);
    final resolvedActionRepository =
        actionRepository ?? SQLiteBabyActionRepository(database: dbProvider);
    final resolvedImagePicker = imagePicker ?? DeviceImagePickerService();

    return PequeLogApp._(
      key: key,
      databaseProvider: dbProvider,
      repository: resolvedRepository,
      actionRepository: resolvedActionRepository,
      imagePicker: resolvedImagePicker,
      datePicker: datePicker,
      timePicker: timePicker,
      settings: settings,
    );
  }

  const PequeLogApp._({
    super.key,
    required SQLiteDatabaseProvider databaseProvider,
    required BabyRepository repository,
    required BabyActionRepository actionRepository,
    required ImagePickerService imagePicker,
    DatePickerLauncher? datePicker,
    TimePickerLauncher? timePicker,
    AppSettings? settings,
  }) : _databaseProvider = databaseProvider,
       _repository = repository,
       _actionRepository = actionRepository,
       _imagePicker = imagePicker,
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
      updateFeedAction: UpdateFeedAction(repository: _actionRepository),
      deleteBabyAction: DeleteBabyAction(repository: _actionRepository),
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
        ChangeNotifierProxyProvider<BabyState, FeedTimerState>(
          create: (_) => FeedTimerState(),
          update: (_, babyState, timerState) {
            timerState ??= FeedTimerState();
            timerState.updateActiveBaby(babyState.selectedBaby?.id);
            return timerState;
          },
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
      child: Consumer2<AppSettings, BabyState>(
        builder: (context, settings, babyState, _) {
          final navigatorKey = GlobalKey<NavigatorState>();
          final router = createAppRouter(
            selectedBaby: babyState.selectedBaby,
            imagePicker: _imagePicker,
            datePicker: _datePicker,
            timePicker: _timePicker,
            navigatorKey: navigatorKey,
          );

          return MaterialApp.router(
            routerConfig: router,
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
            builder: (context, child) {
              return _StartupRouterWrapper(
                imagePicker: _imagePicker,
                datePicker: _datePicker,
                timePicker: _timePicker,
                child: child ?? const SizedBox.shrink(),
              );
            },
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

class _StartupRouterWrapper extends StatelessWidget {
  const _StartupRouterWrapper({
    required this.imagePicker,
    required this.datePicker,
    required this.timePicker,
    required this.child,
  });

  final ImagePickerService imagePicker;
  final DatePickerLauncher? datePicker;
  final TimePickerLauncher? timePicker;
  final Widget child;

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
              onConfigure: () => context.goToSettings(),
              onCreateBaby: () => context.goToNewBaby(),
            );
          case BabyStatus.ready:
            return child;
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
