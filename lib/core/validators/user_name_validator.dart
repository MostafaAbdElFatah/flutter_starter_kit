import '../assets/localization_keys.dart';

/// Validator class for username validation
class UsernameValidator {
  static String? validateUsername(
      String? value, {
        int minLength = 3,
        int maxLength = 20,
        bool allowNumbers = true,
        bool allowUnderscores = true,
      }) {
    if (value == null || value.trim().isEmpty) {
      return LocalizationKeys.usernameRequired;
    }

    final username = value.trim();

    if (username.length < minLength) {
      return LocalizationKeys.usernameMinLength(minLength);
    }

    if (username.length > maxLength) {
      return LocalizationKeys.usernameMaxLength(maxLength);
    }

    String pattern = r'^[a-zA-Z]';
    if (allowNumbers && allowUnderscores) {
      pattern += r'[a-zA-Z0-9_]*$';
    } else if (allowNumbers) {
      pattern += r'[a-zA-Z0-9]*$';
    } else if (allowUnderscores) {
      pattern += r'[a-zA-Z_]*$';
    } else {
      pattern += r'[a-zA-Z]*$';
    }

    final usernameRegex = RegExp(pattern);

    if (!usernameRegex.hasMatch(username)) {
      return LocalizationKeys.usernameInvalidCharacters(
        allowNumbers: allowNumbers,
        allowUnderscores: allowUnderscores,
      );
    }

    return null;
  }

  static String? validateUsernameOptional(
      String? value, {
        bool required = true,
        int minLength = 3,
        int maxLength = 20,
      }) {
    if (value == null || value.trim().isEmpty) {
      return required ? LocalizationKeys.usernameRequired : null;
    }
    return validateUsername(
      value,
      minLength: minLength,
      maxLength: maxLength,
    );
  }

  static bool isValidUsername(String? value) {
    return validateUsername(value) == null;
  }
}