import 'package:equatable/equatable.dart';

import 'env.dart';

/// Defines the type of base URL to use for API requests.
enum BaseUrlType {
  /// Use the default base URL defined for the current environment.
  defaultUrl,

  /// Use a custom, user-defined base URL.
  custom,
}

/// Represents the different environments the application can run in.
///
/// This is used to configure environment-specific settings such as API endpoints
/// and app display names.
enum Environment {
  /// Development environment, typically used for local development.
  dev,

  /// Staging environment, for internal testing and QA.
  stage,

  /// Production environment, for the live app released to users.
  prod,

  /// Testing environment, used for automated tests.
  test;

  /// Returns a display-friendly name for the app based on the environment.
  String get appName {
    switch (this) {
      case Environment.prod:
        return 'Flutter Starter Kit';
      case Environment.dev:
        return 'Flutter Starter Kit (Dev)';
      case Environment.stage:
        return 'Flutter Starter Kit (Stage)';
      case Environment.test:
        return 'Flutter Starter Kit (Test)';
    }
  }
}

/// Manages the base URL configuration.
///
/// This class is immutable and supports serialization to/from JSON, allowing it
/// to be persisted locally. It uses [Equatable] for value-based comparison.
final class BaseUrlConfig extends Equatable {
  /// The type of base URL configuration (default or custom).
  final BaseUrlType type;

  /// The custom URL, if [type] is [BaseUrlType.custom].
  final String? customUrl;

  /// Creates a [BaseUrlConfig] with the default URL setting.
  const BaseUrlConfig.defaultUrl()
    : type = BaseUrlType.defaultUrl,
      customUrl = null;

  /// Creates a [BaseUrlConfig] with a custom URL.
  const BaseUrlConfig.custom(String url)
    : type = BaseUrlType.custom,
      customUrl = url;

  /// Returns `true` if using a custom URL.
  bool get isCustom => type == BaseUrlType.custom;

  /// Returns `true` if using the environment's default URL.
  bool get isDefault => type == BaseUrlType.defaultUrl;

  /// Creates a copy of this config with optional new values.
  BaseUrlConfig copyWith({BaseUrlType? type, String? customUrl}) {
    final effectiveType = type ?? this.type;
    if (effectiveType == BaseUrlType.custom) {
      // When copying to custom, use the provided URL or fall back to the existing one.
      return BaseUrlConfig.custom(customUrl ?? this.customUrl ?? '');
    }
    // Otherwise, always return a default config.
    return const BaseUrlConfig.defaultUrl();
  }

  /// Creates a [BaseUrlConfig] from a JSON map.
  factory BaseUrlConfig.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String?;
    final type = BaseUrlType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => BaseUrlType.defaultUrl,
    );

    if (type == BaseUrlType.custom) {
      final customUrl = json['customUrl'] as String?;
      if (customUrl != null && customUrl.isNotEmpty) {
        return BaseUrlConfig.custom(customUrl);
      }
    }
    // Default to defaultUrl if type is not custom or if customUrl is invalid.
    return const BaseUrlConfig.defaultUrl();
  }

  /// Converts this [BaseUrlConfig] instance into a JSON map for persistence.
  Map<String, dynamic> toJson() => {'type': type.name, 'customUrl': customUrl};

  @override
  List<Object?> get props => [type, customUrl];
}

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

/// A centralized provider for environment-specific constants.
///
/// This class uses a map to retrieve environment data, avoiding large
/// switch-case statements and centralizing configuration in one place.
final class EnvData {
  final String apiKey;
  final String defaultBaseUrl;
  final String devUser;
  final String devPass;

  const EnvData._({
    required this.apiKey,
    required this.defaultBaseUrl,
    required this.devUser,
    required this.devPass,
  });

  /// A map holding the configuration data for each environment.
  static final Map<Environment, EnvData> _envData = {
    Environment.dev: _devEnvData,
    Environment.stage: _stageEnvData,
    Environment.prod: _prodEnvData,
    Environment.test: _testEnvData,
  };

  /// Retrieves the configuration data for a specific [Environment].
  static EnvData get(Environment env) => _envData[env]!;

  /// Configuration for the Development environment, loaded from `.env.dev`.
  static final EnvData _devEnvData = EnvData._(
    apiKey: EnvDev.apiKey,
    defaultBaseUrl: EnvDev.baseUrl,
    devUser: EnvDev.envUser,
    devPass: EnvDev.envPass,
  );

  /// Configuration for the Staging environment, loaded from `.env.stage`.
  static final EnvData _stageEnvData = EnvData._(
    apiKey: EnvStage.apiKey,
    defaultBaseUrl: EnvStage.baseUrl,
    devUser: EnvDev.envUser, // Assuming dev user is same for stage
    devPass: EnvDev.envPass,
  );

  /// Configuration for the Production environment, loaded from `.env.prod`.
  static final EnvData _prodEnvData = EnvData._(
    apiKey: EnvProd.apiKey,
    defaultBaseUrl: EnvProd.baseUrl,
    devUser: EnvDev.envUser, // Assuming dev user is same for prod
    devPass: EnvDev.envPass,
  );

  /// Configuration for the Testing environment, loaded from `.env.test`.
  static final EnvData _testEnvData = EnvData._(
    apiKey: EnvTest.apiKey,
    defaultBaseUrl: EnvTest.baseUrl,
    devUser: EnvDev.envUser, // Assuming dev user is same for test
    devPass: EnvDev.envPass,
  );
}
