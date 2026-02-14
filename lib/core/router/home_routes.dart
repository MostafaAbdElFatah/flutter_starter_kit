part of 'app_router.dart';

class HomeRoutes {
  HomeRoutes._();
  // Splash
  static const splash = '/';

  // Home
  static const home = '/home';
}

class HomeRouter {
  HomeRouter._();

  static List<RouteBase> routes = [
    // Splash
    GoRoute(
      path: HomeRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),

    GoRoute(
      path: HomeRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
  ];
}

extension GoRouterHomeRoutesExtension on GoRouter {
  // Home Navigation
  void goToSplash() => go(HomeRoutes.splash);
  void goToHome() => go(HomeRoutes.home);
}
