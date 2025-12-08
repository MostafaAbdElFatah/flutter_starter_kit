import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/domain/entities/no_params.dart';
import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../repositories/onboarding_repository.dart';

/// A use case that checks if the onboarding process has been completed.
///
/// This class encapsulates the business logic for checking the onboarding status.
@lazySingleton
class CheckOnboardingStatusUseCase extends UseCase<OnboardingRepository, bool, NoParams> {
  /// Creates an instance of [CheckOnboardingStatusUseCase].
  CheckOnboardingStatusUseCase(super.repository);

  /// Executes the use case.
  ///
  /// Returns `true` if onboarding is complete, otherwise `false`.
  bool call(NoParams params) => repository.isOnboardingCompleted();
}
