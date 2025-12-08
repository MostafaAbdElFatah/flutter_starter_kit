import '../assets/localization_keys.dart';

/// Validator class for email validation
class EmailValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocalizationKeys.emailRequired;
    }

    final email = value.trim();

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return LocalizationKeys.invalidEmailAddress;
    }

    if (email.length > 254) {
      return LocalizationKeys.emailTooLong;
    }

    final parts = email.split('@');
    if (parts[0].length > 64) {
      return LocalizationKeys.emailUsernameTooLong;
    }

    return null;
  }

  static String? validateEmailOptional(
      String? value, {
        bool required = true,
      }) {
    if (value == null || value.trim().isEmpty) {
      return required ? LocalizationKeys.emailRequired : null;
    }
    return validateEmail(value);
  }

  static bool isValidEmail(String? value) {
    return validateEmail(value) == null;
  }
}