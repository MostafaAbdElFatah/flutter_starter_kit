part of 'app_router.dart';

/// Route path constants for type-safe navigation
class OnboardingRoutes {
  OnboardingRoutes._();

  // Onboarding
  static const onboarding = '/onboarding';
}

class OnboardingRouter {
  OnboardingRouter._();

  static List<RouteBase> routes = [
    GoRoute(
      path: OnboardingRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
  ];
}

extension GoRouterOnboardingRoutesExtension on GoRouter {
  // Onboarding Navigation
  void goToOnboarding() => go(OnboardingRoutes.onboarding);
}
