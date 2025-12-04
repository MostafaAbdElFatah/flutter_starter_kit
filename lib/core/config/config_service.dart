import 'package:injectable/injectable.dart' hide Environment;
import '../storage/storage_service.dart';
import 'app_config.dart';

/// A service that manages the application's runtime configuration.
///
/// This service is responsible for retrieving and persisting environment-specific
/// settings. It interacts with a [StorageService] to read and write the
/// application's environment and base URL configuration.
@Injectable()
class ConfigService {
  /// The key used to store the selected environment in persistent storage.
  static const String _envKey = 'app_env';

  /// The key used to store the base URL configuration in persistent storage.
  static const String _envBaseUrlConfigKey = '_env_base_url_config';

  final StorageService _storageService;

  /// Creates a new [ConfigService] instance.
  ///
  /// Requires a [StorageService] to be injected for handling data persistence.
  ConfigService({required StorageService storageService})
      : _storageService = storageService;

  /// Retrieves the current application configuration.
  ///
  /// **Note**: This is a computed property that reads from persistent storage
  /// every time it is accessed. It fetches the saved environment and base URL
  /// configuration, then constructs and returns a new [AppConfig] instance.
  AppConfig get currentConfig {
    // Load the saved environment index, defaulting to 0 (dev) if not found.
    final savedEnvIndex = _storageService.get(_envKey, defaultValue: 0);
    final env = Environment.values[savedEnvIndex];

    // Load the saved base URL config, defaulting to 'defaultUrl' if not found.
    final baseUrlConfig = _storageService.getJson<BaseUrlConfig>(
      key: env.name + _envBaseUrlConfigKey,
      fromJson: BaseUrlConfig.fromJson,
      defaultValue: const BaseUrlConfig.defaultUrl(),
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

  AppConfig getAppConfig(Environment env) {
    // Load the saved base URL config, defaulting to 'defaultUrl' if not found.
    final baseUrlConfig = _storageService.getJson<BaseUrlConfig>(
      key: env.name + _envBaseUrlConfigKey,
      fromJson: BaseUrlConfig.fromJson,
      defaultValue: const BaseUrlConfig.defaultUrl(),
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
  Future<void> setEnvironment(
      Environment env, {
        BaseUrlConfig? baseUrlConfig,
      }) async {
    await _storageService.put(key: _envKey, value: env.index);
    if (baseUrlConfig != null) {
      await _storageService.putJson(
        key: env.name + _envBaseUrlConfigKey,
        value: baseUrlConfig,
      );
    }
  }
}
