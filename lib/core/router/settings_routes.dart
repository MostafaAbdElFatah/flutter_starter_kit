part of 'app_router.dart';

/// Route path constants for type-safe navigation
class SettingsRoutes {
  SettingsRoutes._();

  // Settings
  static const settings = '/settings';
  static const environmentConfig = '/environment-config';
}

class SettingsRouter {
  SettingsRouter._();

  static List<RouteBase> routes = [
    // Settings
    GoRoute(
      path: SettingsRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),

    // Environment Config
    GoRoute(
      path: SettingsRoutes.environmentConfig,
      builder: (context, state) => const EnvironmentConfigPage(),
    ),
  ];
}

extension GoRouterSettingsRoutesExtension on GoRouter {
  // Settings Navigation
  void goToSettings() => go(SettingsRoutes.settings);
  void goToEnvironmentConfig() => go(SettingsRoutes.environmentConfig);

  // Push methods (preserves navigation stack)
  void pushSettings() => push(SettingsRoutes.settings);
  void pushEnvironmentConfig() => push(SettingsRoutes.environmentConfig);
}