import '../../assets/localization_keys.dart';

/// Validator class for password validation
class PasswordValidator {
  static String? validatePassword(
      String? value, {
        int minLength = 8,
        bool requireUppercase = true,
        bool requireLowercase = true,
        bool requireNumber = true,
        bool requireSpecialChar = true,
      }) {
    if (value == null || value.isEmpty) {
      return LocalizationKeys.passwordRequired;
    }

    if (value.length < minLength) {
      return LocalizationKeys.passwordMinLength(minLength);
    }

    if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      return LocalizationKeys.passwordRequireUppercase;
    }

    if (requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      return LocalizationKeys.passwordRequireLowercase;
    }

    if (requireNumber && !value.contains(RegExp(r'[0-9]'))) {
      return LocalizationKeys.passwordRequireNumber;
    }

    if (requireSpecialChar && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return LocalizationKeys.passwordRequireSpecialChar;
    }

    return null;
  }

  static String? validatePasswordConfirmation(
      String? value,
      String? password,
      ) {
    if (value == null || value.isEmpty) {
      return LocalizationKeys.confirmPasswordRequired;
    }

    if (value != password) {
      return LocalizationKeys.passwordsDoNotMatch;
    }

    return null;
  }

  static String getPasswordStrength(String? value) {
    if (value == null || value.isEmpty) return 'weak';

    int strength = 0;

    if (value.length >= 8) strength++;
    if (value.length >= 12) strength++;
    if (value.contains(RegExp(r'[A-Z]'))) strength++;
    if (value.contains(RegExp(r'[a-z]'))) strength++;
    if (value.contains(RegExp(r'[0-9]'))) strength++;
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    if (strength <= 2) return 'weak';
    if (strength <= 4) return 'medium';
    if (strength <= 5) return 'strong';
    return 'very_strong';
  }

  static bool isValidPassword(String? value) {
    return validatePassword(value) == null;
  }
}