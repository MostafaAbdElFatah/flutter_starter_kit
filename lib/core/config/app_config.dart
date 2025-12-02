/// Represents the different environments the application can run in.
///
/// This is used to configure environment-specific settings such as API endpoints.
enum Environment { 
  /// Development environment.
  dev, 

  /// Staging environment.
  stage, 

  /// Production environment.
  prod,

  /// Testing environment.
  test
}

/// Holds the application's configuration.
///
/// This class is initialized at startup and provides access to
/// environment-specific settings.
class AppConfig {
  /// The name of the application.
  final String appName;

  /// The key for the API.
  final String apiKey;

  /// The base URL for the API.
  final String baseUrl;

  /// The current environment.
  final Environment environment;

  /// Creates a new [AppConfig] instance.
  AppConfig({
    required this.appName,
    required this.apiKey,
    required this.baseUrl,
    required this.environment,
  });

  /// Returns `true` if the current environment is [Environment.dev].
  bool get isDev => environment == Environment.dev;

  /// Returns `true` if the current environment is [Environment.stage].
  bool get isStage => environment == Environment.stage;

  /// Returns `true` if the current environment is [Environment.prod].
  bool get isProd => environment == Environment.prod;

  /// Returns `true` if the current environment is [Environment.test].
  bool get isTest => environment == Environment.test;
}
