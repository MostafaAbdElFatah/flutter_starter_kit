import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/environments_dev/presentation/pages/environment_config_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

/// Route path constants for type-safe navigation
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const settings = '/settings';
  static const environmentConfig = '/environment-config';
}

/// Application router configuration
class AppRouter {
  AppRouter._(); // Private constructor to prevent instantiation

  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Auth routes (top-level for easy access from anywhere)
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),

      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),

      // Home
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),

      // Settings (top-level so it's accessible from anywhere)
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),

      // Environment Config (top-level)
      GoRoute(
        path: AppRoutes.environmentConfig,
        builder: (context, state) => const EnvironmentConfigPage(),
      ),
    ],
  );
}

// Extension for convenient navigation
extension GoRouterExtension on GoRouter {
  void goToLogin() => go(AppRoutes.login);
  void goToRegister() => go(AppRoutes.register);
  void goToOnboarding() => go(AppRoutes.onboarding);
  void goToHome() => go(AppRoutes.home);
  void goToSettings() => go(AppRoutes.settings);
  void goToEnvironmentConfig() => go(AppRoutes.environmentConfig);

  // Navigation with back stack
  void pushLogin() => push(AppRoutes.login);
  void pushRegister() => push(AppRoutes.register);
  void pushSettings() => push(AppRoutes.settings);
  void pushEnvironmentConfig() => push(AppRoutes.environmentConfig);
}