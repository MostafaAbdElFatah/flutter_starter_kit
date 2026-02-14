import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/use_cases/usecase.dart';
import '../../../../core/infrastructure/cubits/base_cubit.dart';
import '../../../auth/domain/use_cases/is_logged_in_usecase.dart';
import '../../../onboarding/domain/use_cases/check_onboarding_status_usecase.dart';

enum SplashState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  onboarding,
}

/// The concrete implementation of the [SplashCubit].
///
/// This cubit drives the splash flow by checking onboarding completion and
/// authentication status, then emitting the appropriate [SplashState].
@injectable
class SplashCubit extends BaseCubit<SplashState> {
  final IsLoggedInUseCase _isLoggedInUseCase;
  final CheckOnboardingStatusUseCase _checkOnboardingStatusUseCase;

  SplashCubit(this._isLoggedInUseCase, this._checkOnboardingStatusUseCase)
    : super(SplashState.initial);

  /// A static helper method to retrieve the [SplashCubit] instance from the widget tree.
  ///
  /// This simplifies accessing the cubit from UI components.
  ///
  /// Example:
  /// ```dart
  /// SplashCubit.of(context).checkAuth();
  /// ```
  static SplashCubit of(BuildContext context, {bool listen = false}) =>
      BaseCubit.of(context, listen: listen);

  /// Checks onboarding completion and login status to determine the splash outcome.
  ///
  /// Emits [SplashState.loading], then:
  /// - [SplashState.onboarding] if onboarding is incomplete.
  /// - [SplashState.authenticated] if logged in.
  /// - [SplashState.unauthenticated] otherwise.
  Future<void> checkAuth() async {
    emit(SplashState.loading);
    await Future.delayed(const Duration(seconds: 2)); // Simulate splash delay

    final onboardingComplete = _checkOnboardingStatusUseCase(NoParams());

    if (!onboardingComplete) {
      emit(SplashState.onboarding);
      return;
    }

    final isLoggedIn = await _isLoggedInUseCase(NoParams());

    isLoggedIn
        ? emit(SplashState.authenticated)
        : emit(SplashState.unauthenticated);
  }
}
