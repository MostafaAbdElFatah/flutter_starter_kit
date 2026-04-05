import 'env_data.dart';

/// Represents the different environments the application can run in.
///
/// This is used to configure environment-specific settings such as API endpoints
/// and app display names.
enum Environment {
  /// Development environment, typically used for local development.
  dev,

  /// Production environment, for the live app released to users.
  prod;

  /// Returns `true` if the current environment is [Environment.dev].
  bool get isDev => this == Environment.dev;

  /// Returns `true` if the current environment is [Environment.prod].
  bool get isProd => this == Environment.prod;

  /// Returns current`EnvData`.
  AppConfig get appConfig => AppConfig.get(this);
}
