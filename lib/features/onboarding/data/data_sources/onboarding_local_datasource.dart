import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/infrastructure/storage/storage_service.dart';

/// An abstract class defining the contract for the onboarding local data source.
///
/// This data source is responsible for managing the onboarding status locally.
abstract class OnboardingLocalDataSource {
  /// Checks if the onboarding process has been completed.
  ///
  /// Returns `true` if onboarding is complete, otherwise `false`.
  /// Throws a [CacheException] if there is an issue reading from storage.
  bool isOnboardingCompleted();

  /// Marks the onboarding process as complete.
  ///
  /// Throws a [CacheException] if there is an issue writing to storage.
  Future<void> completeOnboarding();
}

/// The concrete implementation of [OnboardingLocalDataSource].
///
/// This class uses [StorageService] to persist the onboarding status.
@LazySingleton(as: OnboardingLocalDataSource)
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final StorageService _storageService;

  /// Creates an instance of [OnboardingLocalDataSourceImpl].
  OnboardingLocalDataSourceImpl(this._storageService);

  @override
  bool isOnboardingCompleted() => _storageService.get(
    AppConstants.onboardingCompleteKey,
    defaultValue: false,
  );

  @override
  Future<void> completeOnboarding() =>
      _storageService.put(key: AppConstants.onboardingCompleteKey, value: true);
}
