import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_starter_kit/core/assets/localization_keys.dart';
import 'package:flutter_starter_kit/core/utils/validators/email_validator.dart';

void main() {
  EasyLocalization.logger.enableLevels = [];

  group('EmailValidator', () {
    group('validateEmail', () {
      test('returns emailRequired for null or empty', () {
        final emptyValues = [null, '', '   '];
        for (var value in emptyValues) {
          expect(
            EmailValidator.validateEmail(value),
            LocalizationKeys.emailRequired,
            reason: 'Expected emailRequired for "$value"',
          );
        }
      });

      test('returns invalidEmailAddress for invalid formats', () {
        final invalidEmails = [
          'invalid',
          'name@',
          '@domain.com',
          'name@domain',
          'name@@domain.com'
        ];

        for (var email in invalidEmails) {
          expect(
            EmailValidator.validateEmail(email),
            LocalizationKeys.invalidEmailAddress,
            reason: 'Expected invalidEmailAddress for "$email"',
          );
        }
      });

      test('returns emailTooLong if total length > 254', () {
        final email = '${'a' * 64}@${'b' * 190}.com';
        expect(
          EmailValidator.validateEmail(email),
          LocalizationKeys.emailTooLong,
        );
      });

      test('returns emailUsernameTooLong if local part > 64 chars', () {
        final email = '${'a' * 65}@example.com';
        expect(
          EmailValidator.validateEmail(email),
          LocalizationKeys.emailUsernameTooLong,
        );
      });

      test('returns null for valid emails', () {
        final validEmails = ['test@example.com', 'john.doe+label@domain.co'];
        for (var email in validEmails) {
          expect(
            EmailValidator.validateEmail(email),
            null,
            reason: 'Expected null for valid email "$email"',
          );
        }
      });
    });

    group('validateEmailOptional', () {
      test('returns null for empty when required = false', () {
        expect(
          EmailValidator.validateEmailOptional('', required: false),
          null,
        );
      });

      test('returns emailRequired for empty when required = true', () {
        expect(
          EmailValidator.validateEmailOptional('', required: true),
          LocalizationKeys.emailRequired,
        );
      });

      test('delegates to validateEmail when not empty', () {
        expect(
          EmailValidator.validateEmailOptional('invalid', required: false),
          LocalizationKeys.invalidEmailAddress,
        );
      });
    });

    group('isValidEmail', () {
      test('returns true for valid emails', () {
        expect(EmailValidator.isValidEmail('test@example.com'), true);
      });

      test('returns false for invalid emails', () {
        expect(EmailValidator.isValidEmail('invalid'), false);
      });
    });
  });
}
