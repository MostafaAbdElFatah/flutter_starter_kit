import '../../assets/localization_keys.dart';

/// Validator class for URL validation
class UrlValidator {
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LocalizationKeys.urlRequired;
    }

    Uri? uri;
    try {
      uri = Uri.parse(value.trim());
    } catch (e) {
      return LocalizationKeys.invalidUrlFormat;
    }

    if (!uri.hasScheme) {
      return LocalizationKeys.urlMustIncludeProtocol;
    }

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return LocalizationKeys.urlMustUseHttpProtocol;
    }

    if (!uri.hasAuthority || uri.host.isEmpty) {
      return LocalizationKeys.urlMustIncludeDomain;
    }

    if (!_isValidHost(uri.host)) {
      return LocalizationKeys.invalidDomainName;
    }

    return null;
  }

  static bool _isValidHost(String host) {
    final hostRegex = RegExp(
      r'^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)*'
      r'[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?$|'
      r'^localhost$|'
      r'^(\d{1,3}\.){3}\d{1,3}$',
    );
    return hostRegex.hasMatch(host);
  }

  static String? validateUrlOptional(String? value, {bool required = true}) {
    if (value == null || value.trim().isEmpty) {
      return required ? LocalizationKeys.urlRequired : null;
    }
    return validateUrl(value);
  }

  static bool isValidUrl(String? value) {
    return validateUrl(value) == null;
  }
}
