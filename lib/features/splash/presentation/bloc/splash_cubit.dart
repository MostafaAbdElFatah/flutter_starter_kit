import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/domain/usecases/is_logged_in_usecase.dart';
import '../../../onboarding/domain/usecases/check_onboarding_status_usecase.dart';

enum SplashState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  onboarding,
}

@injectable
class SplashCubit extends Cubit<SplashState> {
  final IsLoggedInUseCase _isLoggedInUseCase;
  final CheckOnboardingStatusUseCase _checkOnboardingStatusUseCase;

  SplashCubit(
    this._isLoggedInUseCase,
    this._checkOnboardingStatusUseCase,
  ) : super(SplashState.initial);

  Future<void> checkAuth() async {
    emit(SplashState.loading);
    await Future.delayed(const Duration(seconds: 2)); // Simulate splash delay

    final onboardingComplete = await _checkOnboardingStatusUseCase();

    if (!onboardingComplete) {
      emit(SplashState.onboarding);
      return;
    }

    final isLoggedIn = await _isLoggedInUseCase();

    isLoggedIn
        ? emit(SplashState.authenticated)
        : emit(SplashState.unauthenticated);
  }
}
