import '../entities/app_env_config.dart';
import '../entities/base_url_config.dart';
import '../entities/developer_credentials.dart';
import '../entities/environment.dart';

/// An abstract repository that defines the contract for managing environment configurations.
///
/// This repository abstracts the data sources and provides a clean API for the
/// domain layer to interact with environment-related data.
abstract class EnvironmentRepository {
  /// Retrieves the current application configuration.
  AppConfig get currentConfig;

  /// Retrieves the static configuration for a specific [Environment].
  AppConfig getConfigForEnvironment(Environment env);

  /// Updates the application's configuration.
  ///
  /// This method persists the new environment and/or base URL settings.
  Future<void> updateConfiguration({
    required Environment environment,
    BaseUrlConfig? baseUrlConfig,
  });

  /// Attempts to log in as a developer with the given [credentials].
  ///
  /// Returns `true` if the credentials are valid, otherwise `false`.
  bool loginAsDeveloper(DeveloperCredentials credentials);
}
