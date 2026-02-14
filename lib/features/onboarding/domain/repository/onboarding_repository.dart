/// An abstract repository that defines the contract for managing the onboarding process.
///
/// This repository abstracts the data source and provides a clean API for the
/// domain layer to interact with onboarding-related data.
abstract class OnboardingRepository {
  /// Checks if the onboarding process has been completed.
  ///
  /// Returns `true` if onboarding is complete, otherwise `false`.
  /// Throws an exception if there is an issue checking the status.
  bool isOnboardingCompleted();

  /// Marks the onboarding process as complete.
  ///
  /// Throws an exception if there is an issue saving the status.
  Future<void> completeOnboarding();
}
