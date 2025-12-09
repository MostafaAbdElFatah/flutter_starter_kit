import '../entities/api_config.dart';
import '../entities/environment.dart';
import '../usecases/developer_login_usecase.dart';
import '../usecases/get_environment_config_use_case.dart';
import '../usecases/update_environment_configuration_use_case.dart';

/// An abstract repository that defines the contract for managing environment configurations.
///
/// This repository abstracts the data sources and provides a clean API for the
/// domain layer to interact with environment-related data.
abstract class EnvironmentRepository {
  /// Retrieves the API configuration for the currently selected environment.
  ///
  /// This is a convenience getter that combines `currentEnvironment` and
  /// `getConfigForEnvironment`. It provides the API key and base URL for the
  /// active environment.
  APIConfig get currentApiConfig;

  /// Retrieves the currently selected [Environment] from persistent storage.
  ///
  /// If no environment is explicitly set, it should return a default, typically [Environment.dev].
  Environment get currentEnvironment;

  /// Retrieves the static API configuration (API key and default URL) for a given [Environment].
  ///
  /// This data is typically loaded from compile-time environment variables.
  ///
  /// ### Parameters:
  /// - [env]: The environment for which to get the API config.
  APIConfig getConfigForEnvironment(EnvironmentConfigGetParams params);

  /// Updates the application's configuration.
  ///
  /// This method persists the new environment and/or base URL settings.
  Future<void> updateConfiguration(EnvironmentConfigUpdateParams params);

  /// Attempts to log in as a developer with the given [LoginParams].
  ///
  /// Returns `true` if the credentials are valid, otherwise `false`.
  bool loginAsDeveloper(DevLoginParams params);
}
