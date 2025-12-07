import 'package:injectable/injectable.dart' hide Environment;
import '../../../../../core/storage/storage_service.dart';
import '../../../domain/entities/app_env_config.dart';
import '../../../domain/entities/environment.dart';
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

  /// Retrieves the current application configuration.
  ///
  /// **Note**: This is a computed property that reads from persistent storage
  /// every time it is accessed. It fetches the saved environment and base URL
  /// configuration, then constructs and returns a new [AppConfig] instance.
  @override
  AppConfig get currentConfig {
    // Load the saved environment index, defaulting to 0 (dev) if not found.
    final savedEnvIndex = _storageService.get(_envKey, defaultValue: 0);
    final env = Environment.values[savedEnvIndex];

    // Load the saved base URL config, defaulting to 'defaultUrl' if not found.
    final baseUrlConfig = _storageService.getJson<BaseUrlConfigModel>(
      key: env.name + _envBaseUrlConfigKey,
      fromJson: BaseUrlConfigModel.fromJson,
      defaultValue: const BaseUrlConfigModel.defaultUrl(),
    )!;

    // Get the static data (API keys, etc.) for the loaded environment.
    final data = EnvData.get(env);

    // Construct and return the AppConfig object.
    return AppConfig(
      environment: env,
      apiKey: data.apiKey,
      devUsername: data.devUser,
      devPassword: data.devPass,
      baseUrl: data.defaultBaseUrl,
      baseUrlConfig: baseUrlConfig,
    );
  }

  @override
  AppConfig getConfigForEnvironment(Environment env) {
    // Load the saved base URL config, defaulting to 'defaultUrl' if not found.
    final baseUrlConfig = _storageService.getJson<BaseUrlConfigModel>(
      key: env.name + _envBaseUrlConfigKey,
      fromJson: BaseUrlConfigModel.fromJson,
      defaultValue: const BaseUrlConfigModel.defaultUrl(),
    )!;

    // Get the static data (API keys, etc.) for the loaded environment.
    final data = EnvData.get(env);

    // Construct and return the AppConfig object.
    return AppConfig(
      environment: env,
      apiKey: data.apiKey,
      devUsername: data.devUser,
      devPassword: data.devPass,
      baseUrl: data.defaultBaseUrl,
      baseUrlConfig: baseUrlConfig,
    );
  }

  /// Saves the selected environment and base URL configuration to persistent storage.
  ///
  /// This method updates the stored settings for both the environment and the
  /// custom base URL. The application typically needs to be restarted for these
  /// changes to take full effect across the app.
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
