import '../../assets/localization_keys.dart';


/// Validator class for phone number validation
class PhoneValidator {
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocalizationKeys.phoneRequired;
    }

    // Remove any common formatting characters like spaces, dashes, or parentheses
    final phone = value.trim().replaceAll(RegExp(r'[\s\-;~!@#$%^&*()<>.,"\(\)]'), '');

    // Saudi Arabia (KSA) mobile numbers only (LOCAL format).
    // Users should NOT enter country-code prefixes (+966 / 966 / 00966).
    // Accepted inputs (after stripping formatting):
    // - 05XXXXXXXX
    // - 5XXXXXXXX
    if (phone.startsWith('+') || phone.startsWith('966') || phone.startsWith('00966')) {
      return LocalizationKeys.invalidPhone;
    }

    // Regex breakdown:
    // ^0?        -> Optional leading zero
    // 5\d{8}$    -> Mobile numbers start with 5 then 8 digits
    final phoneRegex = RegExp(r'^0?5\d{8}$');

    if (!phoneRegex.hasMatch(phone)) {
      return LocalizationKeys.invalidPhone;
    }

    return null;
  }

  static String? validatePhoneOptional(
      String? value, {
        bool required = true,
      }) {
    if (value == null || value.trim().isEmpty) {
      return required ? LocalizationKeys.phoneRequired : null;
    }
    return validatePhone(value);
  }

  static bool isValidPhone(String? value) {
    return validatePhone(value) == null;
  }
}