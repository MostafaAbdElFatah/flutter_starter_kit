import 'package:injectable/injectable.dart' hide Environment;
import '../../../../core/infrastructure/data/storage/storage_service.dart';
import '../../domain/entities/api_config.dart';
import '../../domain/entities/environment.dart';
import '../models/auth_config.dart';
import '../models/base_url_config.dart';
import '../models/env_data.dart';

part 'environment_config_storage_service.dart';


/// An abstract class defining the contract for the local data source that manages
/// environment-specific configurations.
///
/// This data source is responsible for persisting and retrieving settings related
/// to the application's current runtime environment (e.g., dev, prod) and
/// any associated custom configurations like a base URL.
abstract class EnvironmentConfigService {
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

  /// Retrieves the developer authentication credentials for a given [Environment].
  ///
  /// These credentials (username/password) are typically loaded from environment
  /// variables and are used for accessing developer-only features.
  ///
  /// ### Parameters:
  /// - [env]: The environment for which to get the auth config.
  AuthConfig getAuthConfigForEnvironment(Environment env);

  /// Retrieves the static API configuration (API key and default URL) for a given [Environment].
  ///
  /// This data is typically loaded from compile-time environment variables.
  ///
  /// ### Parameters:
  /// - [env]: The environment for which to get the API config.
  APIConfig getConfigForEnvironment(Environment env);

  /// Updates and persists the application's configuration.
  ///
  /// This method saves the selected [environment] and an optional [baseUrlConfig]
  /// to persistent storage. The application typically needs to be restarted for
  /// these changes to take full effect.
  ///
  /// ### Parameters:
  /// - [environment]: The new environment to save.
  /// - [baseUrlConfig]: The new base URL configuration to save.
  Future<void> updateConfiguration(
      Environment environment, {
        BaseUrlConfigModel? baseUrlConfig,
      });
}
