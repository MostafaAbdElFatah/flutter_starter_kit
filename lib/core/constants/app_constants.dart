/// A class that holds constant values for the application.
///
/// This class is used to store values that are not expected to change during
/// runtime, such as storage keys, route names, or other configuration values.
/// This helps to avoid magic strings and provides a centralized place for
/// all constants.
class AppConstants {
  /// The name of the application.
  static const String appName = 'Flutter Starter Kit';

  // ===========================================================================
  // Storage Keys
  // ===========================================================================

  /// The key for storing the application's locale preference.
  static const String localeKey = 'app_locale';

  /// The key for storing whether the user has completed the onboarding flow.
  static const String onboardingCompleteKey = 'onboarding_complete';
}
