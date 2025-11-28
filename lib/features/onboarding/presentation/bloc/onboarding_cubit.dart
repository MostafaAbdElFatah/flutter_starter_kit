import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/storage_service.dart';

class OnboardingCubit extends Cubit<void> {
  final StorageService _storageService;

  OnboardingCubit(this._storageService) : super(null);

  Future<void> completeOnboarding() async {
    await _storageService.setOnboardingComplete();
  }
}
