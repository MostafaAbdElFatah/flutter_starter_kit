import '../di/injection.dart' as di;
import 'router_exports.dart';


part 'auth_routes.dart';
part 'home_routes.dart';
part 'settings_routes.dart';
part 'onboarding_routes.dart';

@lazySingleton
class AuthGuard {
  final AuthCubit authCubit;
  AuthGuard(this.authCubit) {
    authCubit.checkAuthStatus();
  }

  final publicRoutes = <String>[
    //AuthRoutes.otp,
    HomeRoutes.splash,
    OnboardingRoutes.onboarding,
  ];

  final authRoutes = <String>[AuthRoutes.login, AuthRoutes.register];

  Future<String?>? redirect(BuildContext context, GoRouterState state) async {
    final location = state.matchedLocation;

    final isGoingToOnboarding = location == OnboardingRoutes.onboarding;
    final isOnboardingCompleted = di.get<CheckOnboardingStatusUseCase>()(
      const NoParams(),
    );
    if (!isOnboardingCompleted) {
      return isGoingToOnboarding ? null : OnboardingRoutes.onboarding;
    }

    // 3️⃣ Auth check
    final isAuthenticated = authCubit.state is AuthAuthenticated;

    if (!isAuthenticated && !authRoutes.contains(location)) {
      return AuthRoutes.login;
    }

    return null;
  }
}

@lazySingleton
class AppRouter {
  final AuthGuard authGuard;
  final GoRouterRefreshStream _goRouterRefreshStream;
  AppRouter(this.authGuard)
    : _goRouterRefreshStream = GoRouterRefreshStream(
        authGuard.authCubit.stream,
      );
  GoRouter get router => _router;

  late final GoRouter _router = GoRouter(
    redirect: authGuard.redirect,
    initialLocation: HomeRoutes.splash,
    refreshListenable: _goRouterRefreshStream,
    //onException: (context, state, router) => ,
    errorBuilder: (context, state) => AppErrorPage(exception: state.error),
    // errorPageBuilder: (context, state) {
    //   return MaterialPage(
    //     key: state.pageKey,
    //     child: ErrorPage(exception: state.error),
    //   );
    // },
    routes: [
      ...AuthRouter.routes,
      ...OnboardingRouter.routes,
      ...HomeRouter.routes,
      ...SettingsRouter.routes,
    ],
  );
}

/// Wraps any Stream (e.g., AuthCubit) and notifies GoRouter on changes
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _subscription;
  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners(); // trigger first check
    _subscription = stream.asBroadcastStream().distinct().listen(
      (state) {
        switch (state) {
          case AuthAuthenticated():
          case AuthUnauthenticated():
            notifyListeners();
          default:
            break;
        }
      },
      onError: (error) => Log.error('Stream error:', error: error),
      onDone: () => Log.debug('Stream closed'),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
