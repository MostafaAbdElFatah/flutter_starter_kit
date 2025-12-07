import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/environments_dev/presentation/pages/environment_config_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../di/di.dart' as di;

/// Route path constants for type-safe navigation
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const settings = '/home/settings';
  static const environmentConfig = '/home/settings/environmentConfig';
}

/// Application router configuration
class AppRouter {
  AppRouter._(); // Private constructor to prevent instantiation

  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // Auth routes
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),

      // Home and nested routes
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => di.get<AuthCubit>()),
                // Uncomment when ready to use SettingsCubit
                // BlocProvider(create: (context) => di.get<SettingsCubit>()),
              ],
              child: const SettingsPage(),
            ),
            routes: [
              GoRoute(
                path: 'environmentConfig',
                builder: (context, state) => const EnvironmentConfigPage(),
              ),
            ],
          ),
        ],
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
}
