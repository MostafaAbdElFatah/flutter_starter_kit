import 'package:injectable/injectable.dart' hide Environment;
import '../../../../../core/infrastructure/data/storage/storage_service.dart';
import '../../../domain/entities/api_config.dart';
import '../../../domain/entities/environment.dart';
import '../../models/auth_config.dart';
import '../../models/base_url_config.dart';
import '../../models/env_data.dart';
import '../environment_local_data_source.dart';

typedef EnvConfigService = EnvLocalDataSource;

/// A service that manages the application's runtime configuration.
///
/// This service is responsible for retrieving and persisting environment-specific
/// settings. It interacts with a [StorageService] to read and write the
/// application's environment and base URL configuration.
@Injectable(as: EnvConfigService)
@Injectable(as: EnvLocalDataSource)
class EnvConfigStorageService implements EnvLocalDataSource {
  /// The key used to store the selected environment in persistent storage.
  static const String _envKey = 'app_env';

  /// The key used to store the base URL configuration in persistent storage.
  static const String _envBaseUrlConfigKey = '_env_base_url_config';

  final StorageService _storageService;

  /// Creates a new [ConfigService] instance.
  ///
  /// Requires a [StorageService] to be injected for handling data persistence.
  EnvConfigStorageService({required StorageService storageService})
    : _storageService = storageService;

  /// Retrieves the currently selected [Environment] from persistent storage.
  ///
  /// If no environment is explicitly set, it should return a default, typically [Environment.dev].
  @override
  Environment get currentEnvironment {
    // Load the saved environment index, defaulting to 0 (dev) if not found.
    final savedEnvIndex = _storageService.get(_envKey, defaultValue: 0);
    return Environment.values[savedEnvIndex];
  }

  /// Retrieves the API configuration for the currently selected environment.
  ///
  /// This is a convenience getter that combines `currentEnvironment` and
  /// `getConfigForEnvironment`. It provides the API key and base URL for the
  /// active environment.
  @override
  ApiConfig get currentApiConfig => getConfigForEnvironment(currentEnvironment);


  /// Retrieves the developer authentication credentials for a given [Environment].
  ///
  /// These credentials (username/password) are typically loaded from environment
  /// variables and are used for accessing developer-only features.
  ///
  /// ### Parameters:
  /// - [env]: The environment for which to get the auth config.
  @override
  AuthConfig getAuthConfigForEnvironment(Environment env) {
    // Get the static data (API keys, etc.) for the loaded environment.
    final data = EnvData.get(env);
    return AuthConfig(devUsername: data.devUser, devPassword: data.devPass);
  }

  /// Retrieves the static API configuration (API key and default URL) for a given [Environment].
  ///
  /// This data is typically loaded from compile-time environment variables.
  ///
  /// ### Parameters:
  /// - [env]: The environment for which to get the API config.
  @override
  ApiConfig getConfigForEnvironment(Environment env) {
    // Load the saved base URL config, defaulting to 'defaultUrl' if not found.
    final baseUrlConfig = _storageService.getJson<BaseUrlConfigModel>(
      key: env.name + _envBaseUrlConfigKey,
      fromJson: BaseUrlConfigModel.fromJson,
      defaultValue: const BaseUrlConfigModel.defaultUrl(),
    )!;

    // Get the static data (API keys, etc.) for the loaded environment.
    final data = EnvData.get(env);

    // Construct and return the AppConfig object.
    return ApiConfig(
      environment: env,
      apiKey: data.apiKey,
      baseUrl: data.defaultBaseUrl,
      baseUrlConfig: baseUrlConfig,
    );
  }

  /// Updates and persists the application's configuration.
  ///
  /// This method saves the selected [environment] and an optional [baseUrlConfig]
  /// to persistent storage. The application typically needs to be restarted for
  /// these changes to take full effect.
  ///
  /// ### Parameters:
  /// - [environment]: The new environment to save.
  /// - [baseUrlConfig]: The new base URL configuration to save.
  @override
  Future<void> updateConfiguration(
    Environment environment, {
    BaseUrlConfigModel? baseUrlConfig,
  }) async {
    await _storageService.put(key: _envKey, value: environment.index);
    if (baseUrlConfig != null) {
      await _storageService.putJson(
        key: environment.name + _envBaseUrlConfigKey,
        value: baseUrlConfig,
      );
    }
  }
}
