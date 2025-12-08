import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_starter_kit/core/assets/localization_keys.dart';
import 'package:flutter_starter_kit/core/validators/url_validator.dart';

void main() {
  EasyLocalization.logger.enableLevels = [];

  group('UrlValidator', () {
    group('validateUrl', () {
      test('returns urlRequired for null or empty', () {
        final emptyValues = [null, '', '   '];
        for (var value in emptyValues) {
          expect(
            UrlValidator.validateUrl(value),
            LocalizationKeys.urlRequired,
            reason: 'Expected urlRequired for "$value"',
          );
        }
      });

      test('returns invalidUrlFormat for invalid URLs', () {
        final invalidUrls = ['ht!tp://example.com', '://example.com'];

        for (var url in invalidUrls) {
          expect(
            UrlValidator.validateUrl(url),
            LocalizationKeys.invalidUrlFormat,
            reason: 'Expected invalidUrlFormat for "$url"',
          );
        }
      });

      test('returns urlMustIncludeDomain if missing Domain', () {
        final url = 'http:/example.com';
        expect(
          UrlValidator.validateUrl(url),
          LocalizationKeys.urlMustIncludeDomain,
          reason: 'Expected urlMustIncludeDomain for "$url"',
        );
      });

      test('returns urlMustIncludeProtocol if missing scheme', () {
        final url = 'www.example.com';
        expect(
          UrlValidator.validateUrl(url),
          LocalizationKeys.urlMustIncludeProtocol,
          reason: 'Expected urlMustIncludeProtocol for "$url"',
        );
      });

      test('returns urlMustUseHttpProtocol if scheme is not http/https', () {
        final urls = ['ftp://example.com', 'file://example.com'];
        for (var url in urls) {
          expect(
            UrlValidator.validateUrl(url),
            LocalizationKeys.urlMustUseHttpProtocol,
            reason: 'Expected urlMustUseHttpProtocol for "$url"',
          );
        }
      });

      test('returns urlMustIncludeDomain if host is missing', () {
        final urls = ['http://', 'https://'];
        for (var url in urls) {
          expect(
            UrlValidator.validateUrl(url),
            LocalizationKeys.urlMustIncludeDomain,
            reason: 'Expected urlMustIncludeDomain for "$url"',
          );
        }
      });

      test('returns invalidDomainName for invalid host', () {
        final urls = [
          'http://exa_mple.com',
          'https://-example.com',
          'http://example..com',
        ];
        for (var url in urls) {
          expect(
            UrlValidator.validateUrl(url),
            LocalizationKeys.invalidDomainName,
            reason: 'Expected invalidDomainName for "$url"',
          );
        }
      });

      test('returns null for valid URLs', () {
        final validUrls = [
          'http://example.com',
          'https://example.com',
          'http://localhost',
          'http://127.0.0.1',
          'https://sub.domain.example.com/path?query=1#fragment',
        ];
        for (var url in validUrls) {
          expect(
            UrlValidator.validateUrl(url),
            null,
            reason: 'Expected null for valid URL "$url"',
          );
        }
      });
    });

    group('validateUrlOptional', () {
      test('returns null if empty and required=false', () {
        expect(UrlValidator.validateUrlOptional('', required: false), null);
        expect(UrlValidator.validateUrlOptional(null, required: false), null);
      });

      test('returns urlRequired if empty and required=true', () {
        expect(
          UrlValidator.validateUrlOptional('', required: true),
          LocalizationKeys.urlRequired,
        );
      });

      test('delegates to validateUrl for non-empty', () {
        expect(UrlValidator.validateUrlOptional('http://example.com'), null);
        expect(
          UrlValidator.validateUrlOptional('invalid-url'),
          LocalizationKeys.urlMustIncludeProtocol,
        );
      });
    });

    group('isValidUrl', () {
      test('returns true for valid URLs', () {
        expect(UrlValidator.isValidUrl('http://example.com'), true);
      });

      test('returns false for invalid URLs', () {
        expect(UrlValidator.isValidUrl('invalid-url'), false);
      });
    });
  });
}
