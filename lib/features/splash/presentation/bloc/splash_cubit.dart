import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/storage_service.dart';

enum SplashState { initial, loading, authenticated, unauthenticated, onboarding }

class SplashCubit extends Cubit<SplashState> {
  final StorageService _storageService;

  SplashCubit(this._storageService) : super(SplashState.initial);

  Future<void> checkAuth() async {
    emit(SplashState.loading);
    await Future.delayed(const Duration(seconds: 2)); // Simulate splash delay

    final onboardingComplete = await _storageService.isOnboardingComplete();
    if (!onboardingComplete) {
      emit(SplashState.onboarding);
      return;
    }

    final token = await _storageService.getToken();
    if (token != null) {
      emit(SplashState.authenticated);
    } else {
      emit(SplashState.unauthenticated);
    }
  }
}
