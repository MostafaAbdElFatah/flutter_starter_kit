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
  prod;

  /// Returns `true` if the current environment is [Environment.dev].
  bool get isDev => this == Environment.dev;

  /// Returns `true` if the current environment is [Environment.stage].
  bool get isStage => this == Environment.stage;

  /// Returns `true` if the current environment is [Environment.prod].
  bool get isProd => this == Environment.prod;

  /// Returns a display-friendly name for the app based on the environment.
  String get appName {
    switch (this) {
      case Environment.prod:
        return 'Flutter Starter Kit';
      case Environment.dev:
        return 'Flutter Starter Kit (Dev)';
      case Environment.stage:
        return 'Flutter Starter Kit (Stage)';
    }
  }
}
