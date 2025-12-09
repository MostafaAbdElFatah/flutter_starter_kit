import 'package:equatable/equatable.dart';

import 'base_url_config.dart';
import 'base_url_type.dart';
import 'environment.dart';

/// Holds the application's entire configuration.
///
/// This class is the single source of truth for all environment-specific settings.
/// It is immutable and uses [Equatable] for value-based comparison.
class APIConfig extends Equatable {
  /// The base URL for the API, derived from the environment's default.
  final String _baseUrl;

  /// The API key for the current environment.
  final String apiKey;

  /// The current runtime environment (e.g., dev, prod).
  final Environment environment;

  /// The current base URL configuration (default or custom).
  final BaseUrlConfig baseUrlConfig;

  /// Creates a new [AppConfig] instance.
  const APIConfig({
    required String baseUrl,
    required this.apiKey,
    required this.environment,
    required this.baseUrlConfig,
  }) : _baseUrl = baseUrl;

  /// The display name of the application, which varies by environment.
  String get appName => environment.appName;

  String get defaultBaseUrl => _baseUrl;

  /// The effective base URL to be used for API requests.
  ///
  /// Returns the custom URL if one is set, otherwise falls back to the
  /// environment's default base URL.
  String get baseUrl =>
      baseUrlConfig.isCustom ? baseUrlConfig.customUrl ?? _baseUrl : _baseUrl;

  /// Returns `true` if the current environment is [Environment.dev].
  bool get isDev => environment.isDev;

  /// Returns `true` if the current environment is [Environment.stage].
  bool get isStage => environment.isStage;

  /// Returns `true` if the current environment is [Environment.prod].
  bool get isProd => environment.isProd;

  /// Returns `true` if the current environment is [Environment.test].
  bool get isTest => environment.isTest;

  /// Creates a copy of this config with optional new values.
  APIConfig copyWith({
    String? baseUrl,
    String? apiKey,
    Environment? environment,
    BaseUrlConfig? baseUrlConfig,
  }) {
    return APIConfig(
      baseUrl: baseUrl ?? _baseUrl,
      apiKey: apiKey ?? this.apiKey,
      environment: environment ?? this.environment,
      baseUrlConfig: baseUrlConfig ?? this.baseUrlConfig,
    );
  }

  String baseUrlFor(BaseUrlType type) {
    return type.isDefault
        ? defaultBaseUrl
        : (baseUrlConfig.customUrl ?? defaultBaseUrl);
  }

  @override
  List<Object?> get props => [_baseUrl, apiKey, environment, baseUrlConfig];
}
