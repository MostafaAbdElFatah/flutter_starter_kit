import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'app_config.dart' as env_config;
import 'env.dart';

/// A service that manages the application's configuration.
///
/// This class is responsible for initializing, retrieving, and updating the
/// environment-specific settings of the application. It uses Hive for
/// persistent storage of the selected environment.
@Injectable()
class ConfigService {
  // The name of the Hive box used for storing configuration.
  static const String _boxName = 'app_config';

  // The key used to store the selected environment in the Hive box.
  static const String _envKey = 'app_env';

  late Box _box;
  late env_config.AppConfig _currentConfig;

  /// Returns the current application configuration.
  env_config.AppConfig get currentConfig => _currentConfig;

  /// Initializes the configuration service.
  ///
  /// This method opens the Hive box and loads the saved environment. If no
  /// environment is saved, it defaults to the development environment.
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    final savedEnvIndex = _box.get(_envKey);

    env_config.Environment env = env_config.Environment.dev;
    if (savedEnvIndex != null) {
      env = env_config.Environment.values[savedEnvIndex];
    }
    _updateConfig(env);
  }

  /// Sets the application's environment.
  ///
  /// This method saves the selected environment to the Hive box and updates the
  /// current configuration.
  Future<void> setEnvironment(env_config.Environment env) async {
    await _box.put(_envKey, env.index);
    _updateConfig(env);
  }

  /// Updates the current configuration based on the selected environment.
  void _updateConfig(env_config.Environment env) {
    switch (env) {
      case env_config.Environment.dev:
        _currentConfig = env_config.AppConfig(
          appName: 'Flutter Starter Kit (Dev)',
          apiKey: EnvDev.apiKey,
          baseUrl: EnvDev.baseUrl,
          environment: env_config.Environment.dev,
        );
        break;
      case env_config.Environment.stage:
        _currentConfig = env_config.AppConfig(
          appName: 'Flutter Starter Kit (Stage)',
          apiKey: EnvStage.apiKey,
          baseUrl: EnvStage.baseUrl,
          environment: env_config.Environment.stage,
        );
        break;
      case env_config.Environment.prod:
        _currentConfig = env_config.AppConfig(
          appName: 'Flutter Starter Kit',
          apiKey: EnvProd.apiKey,
          baseUrl: EnvProd.baseUrl,
          environment: env_config.Environment.prod,
        );
        break;
      case env_config.Environment.test:
        _currentConfig = env_config.AppConfig(
          appName: 'Flutter Starter Kit (Test)',
          apiKey: EnvTest.apiKey,
          baseUrl: EnvTest.baseUrl,
          environment: env_config.Environment.test,
        );
        break;
    }
  }
}
