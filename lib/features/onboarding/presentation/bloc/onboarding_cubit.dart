import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/infrastructure/domain/entities/no_params.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';

@injectable
class OnboardingCubit extends Cubit<void> {
  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  OnboardingCubit(this._completeOnboardingUseCase) : super(null);

  static OnboardingCubit of(context) => BlocProvider.of(context);

  Future<void> completeOnboarding() => _completeOnboardingUseCase(NoParams());
}
