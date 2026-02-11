import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_kit/core/assets/localization_keys.dart';
import 'package:flutter_starter_kit/core/utils/validators/user_name_validator.dart';


void main() {
  EasyLocalization.logger.enableLevels = [];

  group('UsernameValidator', () {
    group('validateUsername', () {
      test('returns usernameRequired for null or empty', () {
        final emptyValues = [null, '', '   '];
        for (var value in emptyValues) {
          expect(
            UsernameValidator.validateUsername(value),
            LocalizationKeys.usernameRequired,
            reason: 'Expected usernameRequired for "$value"',
          );
        }
      });

      test('returns usernameMinLength if too short', () {
        expect(
          UsernameValidator.validateUsername('ab'),
          LocalizationKeys.usernameMinLength(3),
        );
      });

      test('returns usernameMaxLength if too long', () {
        expect(
          UsernameValidator.validateUsername('a' * 21),
          LocalizationKeys.usernameMaxLength(20),
        );
      });

      test('returns usernameInvalidCharacters if invalid characters present', () {
        expect(
          UsernameValidator.validateUsername('1abc'),
          LocalizationKeys.usernameInvalidCharacters(allowNumbers: true, allowUnderscores: true),
        );
        expect(
          UsernameValidator.validateUsername('abc!'),
          LocalizationKeys.usernameInvalidCharacters(allowNumbers: true, allowUnderscores: true),
        );
      });

      test('returns null for valid usernames', () {
        final validUsernames = ['abc', 'abc123', 'abc_123', 'AUser'];
        for (var username in validUsernames) {
          expect(
            UsernameValidator.validateUsername(username),
            null,
            reason: 'Expected null for valid username "$username"',
          );
        }
      });

      test('respects allowNumbers and allowUnderscores flags', () {
        // Numbers not allowed
        expect(
          UsernameValidator.validateUsername('abc123', allowNumbers: false),
          LocalizationKeys.usernameInvalidCharacters(allowNumbers: false, allowUnderscores: true),
        );

        // Underscores not allowed
        expect(
          UsernameValidator.validateUsername('abc_123', allowUnderscores: false),
          LocalizationKeys.usernameInvalidCharacters(allowNumbers: true, allowUnderscores: false),
        );

        // Neither allowed
        expect(
          UsernameValidator.validateUsername('abc_123', allowNumbers: false, allowUnderscores: false),
          LocalizationKeys.usernameInvalidCharacters(allowNumbers: false, allowUnderscores: false),
        );
      });
    });

    group('validateUsernameOptional', () {
      test('returns null for empty when required=false', () {
        expect(
          UsernameValidator.validateUsernameOptional('', required: false),
          null,
        );
      });

      test('returns usernameRequired for empty when required=true', () {
        expect(
          UsernameValidator.validateUsernameOptional('', required: true),
          LocalizationKeys.usernameRequired,
        );
      });

      test('delegates to validateUsername for non-empty', () {
        expect(
          UsernameValidator.validateUsernameOptional('abc'),
          null,
        );
        expect(
          UsernameValidator.validateUsernameOptional('ab'),
          LocalizationKeys.usernameMinLength(3),
        );
      });
    });

    group('isValidUsername', () {
      test('returns true for valid usernames', () {
        expect(UsernameValidator.isValidUsername('abc123'), true);
        expect(UsernameValidator.isValidUsername('abc_123'), true);
      });

      test('returns false for invalid usernames', () {
        expect(UsernameValidator.isValidUsername('ab'), false);
        expect(UsernameValidator.isValidUsername('1abc'), false);
      });
    });
  });
}
