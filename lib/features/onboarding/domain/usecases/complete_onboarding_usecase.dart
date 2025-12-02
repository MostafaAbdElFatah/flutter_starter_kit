import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

/// A use case that marks the onboarding process as complete.
///
/// This class encapsulates the business logic for completing the onboarding flow.
@lazySingleton
class CompleteOnboardingUseCase extends UseCase<OnboardingRepository> {
  /// Creates an instance of [CompleteOnboardingUseCase].
  CompleteOnboardingUseCase(super.repository);

  /// Executes the use case.
  ///
  /// This will persist the onboarding completion status.
  Future<void> call() => repository.completeOnboarding();
}
