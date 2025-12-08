import 'package:flutter_starter_kit/core/assets/localization_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_starter_kit/core/validators/password_validator.dart';

void main() {
  EasyLocalization.logger.enableLevels = [];

  group('PasswordValidator', () {
    group('validatePassword', () {
      test('returns passwordRequired for null or empty', () {
        expect(PasswordValidator.validatePassword(null), LocalizationKeys.passwordRequired);
        expect(PasswordValidator.validatePassword(''), LocalizationKeys.passwordRequired);
      });

      test('returns passwordMinLength if too short', () {
        expect(
          PasswordValidator.validatePassword('Ab1!'),
          LocalizationKeys.passwordMinLength(8),
        );
      });

      test('requires uppercase if rule enabled', () {
        expect(
          PasswordValidator.validatePassword('abcdef1!'),
          LocalizationKeys.passwordRequireUppercase,
        );
      });

      test('requires lowercase if rule enabled', () {
        expect(
          PasswordValidator.validatePassword('ABCDEF1!'),
          LocalizationKeys.passwordRequireLowercase,
        );
      });

      test('requires number if rule enabled', () {
        expect(
          PasswordValidator.validatePassword('Abcdefgh!'),
          LocalizationKeys.passwordRequireNumber,
        );
      });

      test('requires special character if rule enabled', () {
        expect(
          PasswordValidator.validatePassword('Abcdefg1'),
          LocalizationKeys.passwordRequireSpecialChar,
        );
      });

      test('valid password returns null', () {
        final validPassword = 'Abcdef1!';
        expect(PasswordValidator.validatePassword(validPassword), null);
      });

      test('supports custom minLength', () {
        final password = 'Abc1!';
        expect(
          PasswordValidator.validatePassword(password, minLength: 4),
          null,
        );
      });

      test('can disable specific rules', () {
        final password = 'abcdefg';
        expect(
          PasswordValidator.validatePassword(password,
              requireUppercase: false,
              requireLowercase: false,
              requireNumber: false,
              requireSpecialChar: false,
              minLength: 5),
          null,
        );
      });
    });

    group('validatePasswordConfirmation', () {
      test('returns confirmPasswordRequired for null or empty', () {
        expect(
          PasswordValidator.validatePasswordConfirmation(null, 'Abcdef1!'),
          LocalizationKeys.confirmPasswordRequired,
        );
        expect(
          PasswordValidator.validatePasswordConfirmation('', 'Abcdef1!'),
          LocalizationKeys.confirmPasswordRequired,
        );
      });

      test('returns passwordsDoNotMatch if values differ', () {
        expect(
          PasswordValidator.validatePasswordConfirmation('Abcdef2!', 'Abcdef1!'),
          LocalizationKeys.passwordsDoNotMatch,
        );
      });

      test('returns null if passwords match', () {
        expect(
          PasswordValidator.validatePasswordConfirmation('Abcdef1!', 'Abcdef1!'),
          null,
        );
      });
    });

    group('getPasswordStrength', () {
      test('returns "very_weak" for empty or null', () {
        expect(PasswordValidator.getPasswordStrength(null), 'very_weak');
        expect(PasswordValidator.getPasswordStrength(''), 'very_weak');
        expect(PasswordValidator.getPasswordStrength(' '), 'very_weak');
      });

      test('calculates correct strength', () {
        expect(PasswordValidator.getPasswordStrength(' abc '), 'very_weak'); // very weak
        expect(PasswordValidator.getPasswordStrength('abc'), 'very_weak'); // very weak
        expect(PasswordValidator.getPasswordStrength('abc1'), 'weak'); // very weak
        expect(PasswordValidator.getPasswordStrength('abc!'), 'weak'); //  weak
        expect(PasswordValidator.getPasswordStrength('Abc'), 'weak'); // weak
        expect(PasswordValidator.getPasswordStrength('abcdef12'), 'medium'); // medium
        expect(PasswordValidator.getPasswordStrength('Abcdef12'), 'medium'); // strong
        expect(PasswordValidator.getPasswordStrength('Abcdef12!'), 'strong'); // strong
        expect(PasswordValidator.getPasswordStrength('Abcdefwe1112'), 'strong'); // strong
        expect(PasswordValidator.getPasswordStrength('Abcdefwe1112!'), 'very_strong'); // very strong

      });
    });

    group('isValidPassword', () {
      test('returns true for valid password', () {
        expect(PasswordValidator.isValidPassword('Abcdef1!'), true);
      });

      test('returns false for invalid password', () {
        expect(PasswordValidator.isValidPassword('abcdef'), false);
      });
    });
  });
}
