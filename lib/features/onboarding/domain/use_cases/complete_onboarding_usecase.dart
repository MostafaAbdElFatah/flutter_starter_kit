import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/use_cases/usecase.dart';
import '../repository/onboarding_repository.dart';

/// A use case that marks the onboarding process as complete.
///
/// This class encapsulates the business logic for completing the onboarding flow.
@lazySingleton
class CompleteOnboardingUseCase
    extends AsyncUseCase<OnboardingRepository, void, NoParams> {
  /// Creates an instance of [CompleteOnboardingUseCase].
  CompleteOnboardingUseCase(super.repository);

  /// Executes the use case.
  ///
  /// This will persist the onboarding completion status.
  @override
  Future<void> call(NoParams params) => repository.completeOnboarding();
}
