part of 'app_router.dart';

/// Route path constants for type-safe navigation
class AuthRoutes {
  AuthRoutes._();

  // Auth
  static const login = '/login';
  static const register = '/register';
}

class AuthRouter {
  AuthRouter._();

  static List<RouteBase> routes = [

    // Login
    GoRoute(
      path: AuthRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),

    // Register
    GoRoute(
      path: AuthRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
  ];
}

extension GoRouterAuthRoutesExtension on GoRouter {
  // Auth Navigation
  void goToLogin() => go(AuthRoutes.login);
  void goToRegister() => go(AuthRoutes.register);

  // Push methods (preserves navigation stack)
  void pushLogin() => push(AuthRoutes.login);
  void pushRegister() => push(AuthRoutes.register);
}