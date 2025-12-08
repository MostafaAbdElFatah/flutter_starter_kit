import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/usecases/is_logged_in_usecase.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/environments_dev/presentation/pages/environment_config_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../di/di.dart' as di;
import '../infrastructure/domain/entities/no_params.dart';

part 'auth_routes.dart';
part 'home_routes.dart';
part 'settings_routes.dart';
part 'onboarding_routes.dart';

class AuthGuard {
  static Future<String?>? redirect(BuildContext context, GoRouterState state) async {
    final isGoingToSplash = state.matchedLocation == HomeRoutes.splash;
    final isGoingToOnboarding = state.matchedLocation == OnboardingRoutes.onboarding;

    if(isGoingToOnboarding || isGoingToSplash) {
      return state.matchedLocation;
    }

    final isAuthenticated = await di.get<IsLoggedInUseCase>()(
      NoParams(),
    ); // Check your auth state
    final isGoingToLogin = state.matchedLocation == AuthRoutes.login;


    if (!isAuthenticated && !isGoingToLogin) {
      return AuthRoutes.login;
    }

    if (isAuthenticated && isGoingToLogin) {
      return HomeRoutes.home;
    }

    return null;
  }
}

/// Application router configuration
class AppRouter {
  AppRouter._(); // Private constructor to prevent instantiation

  static final router = GoRouter(
    initialLocation: HomeRoutes.splash,
    redirect: AuthGuard.redirect,
    routes: [
      ...AuthRouter.routes,
      ...OnboardingRouter.routes,
      ...HomeRouter.routes,
      ...SettingsRouter.routes,
    ],
  );
}

// Extension for convenient navigation
// extension GoRouterExtension on GoRouter {
//   void goToLogin() => go(AppRoutes.login);
//   void goToRegister() => go(AppRoutes.register);
//   void goToOnboarding() => go(AppRoutes.onboarding);
//   void goToHome() => go(AppRoutes.home);
//   void goToSettings() => go(AppRoutes.settings);
//   void goToEnvironmentConfig() => go(AppRoutes.environmentConfig);
//
//   // Navigation with back stack
//   void pushLogin() => push(AppRoutes.login);
//   void pushRegister() => push(AppRoutes.register);
//   void pushSettings() => push(AppRoutes.settings);
//   void pushEnvironmentConfig() => push(AppRoutes.environmentConfig);
// }
