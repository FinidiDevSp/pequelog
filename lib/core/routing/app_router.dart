import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/presentation/features/babies/actions/bath_action_screen.dart';
import 'package:pequelog/presentation/features/babies/actions/diaper_action_screen.dart';
import 'package:pequelog/presentation/features/babies/actions/feed_action_screen.dart';
import 'package:pequelog/presentation/features/babies/actions/vomit_action_screen.dart';
import 'package:pequelog/presentation/features/babies/edit_baby_screen.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/presentation/features/settings/configuration_screen.dart';
import 'package:pequelog/presentation/features/startup/baby_home_screen.dart';
import 'package:pequelog/presentation/features/history/baby_history_screen.dart';

/// Route names for type-safe navigation.
class AppRoutes {
  /// Home screen route (baby dashboard).
  static const String home = 'home';

  /// Configuration/settings screen route.
  static const String settings = 'settings';

  /// New baby creation screen route.
  static const String newBaby = 'new-baby';

  /// Edit baby screen route.
  static const String editBaby = 'edit-baby';

  /// Feed action screen route.
  static const String feedAction = 'feed-action';

  /// Bath action screen route.
  static const String bathAction = 'bath-action';

  /// Vomit action screen route.
  static const String vomitAction = 'vomit-action';

  /// Diaper action screen route.
  static const String diaperAction = 'diaper-action';

  /// History screen route.
  static const String history = 'history';

  AppRoutes._();
}

/// Extension on BuildContext for type-safe navigation.
extension AppNavigationExtension on BuildContext {
  /// Navigates to the home screen.
  void goToHome() => goNamed(AppRoutes.home);

  /// Navigates to the settings screen.
  void goToSettings() => pushNamed(AppRoutes.settings);

  /// Navigates to the new baby creation screen.
  void goToNewBaby() => pushNamed(AppRoutes.newBaby);

  /// Navigates to the edit baby screen.
  void goToEditBaby() => pushNamed(AppRoutes.editBaby);

  /// Navigates to the feed action screen.
  Future<String?> goToFeedAction({BabyAction? initialAction}) {
    return pushNamed<String>(
      AppRoutes.feedAction,
      extra: initialAction,
    );
  }

  /// Navigates to the bath action screen.
  Future<String?> goToBathAction() {
    return pushNamed<String>(AppRoutes.bathAction);
  }

  /// Navigates to the vomit action screen.
  Future<String?> goToVomitAction() {
    return pushNamed<String>(AppRoutes.vomitAction);
  }

  /// Navigates to the diaper action screen.
  Future<String?> goToDiaperAction() {
    return pushNamed<String>(AppRoutes.diaperAction);
  }

  /// Navigates to the history screen.
  void goToHistory() => pushNamed(AppRoutes.history);
}

/// Creates the app's router with all defined routes.
GoRouter createAppRouter({
  required Baby? selectedBaby,
  required ImagePickerService imagePicker,
  DatePickerLauncher? datePicker,
  TimePickerLauncher? timePicker,
  required GlobalKey<NavigatorState> navigatorKey,
}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        name: AppRoutes.home,
        pageBuilder: (context, state) {
          if (selectedBaby == null) {
            return _buildPageWithTransition(
              context,
              state,
              const Scaffold(
                body: Center(
                  child: Text('No baby selected'),
                ),
              ),
            );
          }
          return _buildPageWithTransition(
            context,
            state,
            BabyHomeScreen(
              baby: selectedBaby,
              imagePicker: imagePicker,
              datePicker: datePicker,
              timePicker: timePicker,
            ),
          );
        },
      ),
      GoRoute(
        path: '/settings',
        name: AppRoutes.settings,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const ConfigurationScreen(),
        ),
      ),
      GoRoute(
        path: '/new-baby',
        name: AppRoutes.newBaby,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          NewBabyScreen(
            imagePicker: imagePicker,
            datePicker: datePicker,
            timePicker: timePicker,
          ),
        ),
      ),
      GoRoute(
        path: '/edit-baby',
        name: AppRoutes.editBaby,
        pageBuilder: (context, state) {
          if (selectedBaby == null) {
            return _buildPageWithTransition(
              context,
              state,
              const Scaffold(
                body: Center(
                  child: Text('No baby to edit'),
                ),
              ),
            );
          }
          return _buildPageWithTransition(
            context,
            state,
            EditBabyScreen(
              baby: selectedBaby,
              imagePicker: imagePicker,
              datePicker: datePicker,
              timePicker: timePicker,
            ),
          );
        },
      ),
      GoRoute(
        path: '/feed-action',
        name: AppRoutes.feedAction,
        pageBuilder: (context, state) {
          final initialAction = state.extra as BabyAction?;
          return _buildPageWithTransition(
            context,
            state,
            FeedActionScreen(
              timePicker: timePicker,
              datePicker: datePicker,
              initialAction: initialAction,
            ),
          );
        },
      ),
      GoRoute(
        path: '/bath-action',
        name: AppRoutes.bathAction,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          BathActionScreen(
            datePicker: datePicker,
            timePicker: timePicker,
          ),
        ),
      ),
      GoRoute(
        path: '/vomit-action',
        name: AppRoutes.vomitAction,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          VomitActionScreen(
            datePicker: datePicker,
            timePicker: timePicker,
          ),
        ),
      ),
      GoRoute(
        path: '/diaper-action',
        name: AppRoutes.diaperAction,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          DiaperActionScreen(
            datePicker: datePicker,
            timePicker: timePicker,
          ),
        ),
      ),
      GoRoute(
        path: '/history',
        name: AppRoutes.history,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const BabyHistoryScreen(),
        ),
      ),
    ],
  );
}

/// Builds a page with a consistent fade transition animation.
Page<void> _buildPageWithTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}
