import 'package:injectable/injectable.dart';

import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

/// The concrete implementation of the [OnboardingRepository] interface.
///
/// This class orchestrates the logic for the onboarding process by interacting
/// with the [OnboardingLocalDataSource].
@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _localDataSource;

  /// Creates an instance of [OnboardingRepositoryImpl].
  OnboardingRepositoryImpl(this._localDataSource);

  @override
  bool isOnboardingCompleted() {
    // Directly return the future from the data source.
    // The data source is responsible for handling any potential errors.
    return _localDataSource.isOnboardingCompleted();
  }

  @override
  Future<void> completeOnboarding() {
    // Directly call the data source to mark onboarding as complete.
    // The data source will handle any errors.
    return _localDataSource.completeOnboarding();
  }
}
