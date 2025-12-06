import 'package:equatable/equatable.dart';

import 'base_url_config.dart';
import 'environment.dart';

/// Holds the application's entire configuration.
///
/// This class is the single source of truth for all environment-specific settings.
/// It is immutable and uses [Equatable] for value-based comparison.
final class AppConfig extends Equatable {
  /// The base URL for the API, derived from the environment's default.
  final String _baseUrl;

  /// The API key for the current environment.
  final String apiKey;

  /// The username for developer login.
  final String devUsername;

  /// The password for developer login.
  final String devPassword;

  /// The current runtime environment (e.g., dev, prod).
  final Environment environment;

  /// The current base URL configuration (default or custom).
  final BaseUrlConfig baseUrlConfig;

  /// Creates a new [AppConfig] instance.
  const AppConfig({
    required String baseUrl,
    required this.apiKey,
    required this.devUsername,
    required this.devPassword,
    required this.environment,
    required this.baseUrlConfig,
  }) : _baseUrl = baseUrl;

  /// The display name of the application, which varies by environment.
  String get appName => environment.appName;

  /// The effective base URL to be used for API requests.
  ///
  /// Returns the custom URL if one is set, otherwise falls back to the
  /// environment's default base URL.
  String get baseUrl =>
      baseUrlConfig.isCustom ? baseUrlConfig.customUrl ?? _baseUrl : _baseUrl;

  /// Returns `true` if the current environment is [Environment.dev].
  bool get isDev => environment == Environment.dev;

  /// Returns `true` if the current environment is [Environment.stage].
  bool get isStage => environment == Environment.stage;

  /// Returns `true` if the current environment is [Environment.prod].
  bool get isProd => environment == Environment.prod;

  /// Returns `true` if the current environment is [Environment.test].
  bool get isTest => environment == Environment.test;

  /// Creates a copy of this config with optional new values.
  AppConfig copyWith({
    String? baseUrl,
    String? apiKey,
    String? devUsername,
    String? devPassword,
    Environment? environment,
    BaseUrlConfig? baseUrlConfig,
  }) {
    return AppConfig(
      baseUrl: baseUrl ?? _baseUrl,
      apiKey: apiKey ?? this.apiKey,
      devUsername: devUsername ?? this.devUsername,
      devPassword: devPassword ?? this.devPassword,
      environment: environment ?? this.environment,
      baseUrlConfig: baseUrlConfig ?? this.baseUrlConfig,
    );
  }

  @override
  List<Object?> get props => [
    _baseUrl,
    apiKey,
    devUsername,
    devPassword,
    environment,
    baseUrlConfig,
  ];
}