import 'package:hive_flutter/hive_flutter.dart';
import 'app_config.dart';
import 'env.dart';

class ConfigService {
  static const String _boxName = 'app_config';
  static const String _envKey = 'app_env';
  
  late Box _box;
  late AppConfig _currentConfig;

  AppConfig get currentConfig => _currentConfig;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    final savedEnvIndex = _box.get(_envKey);
    
    Environment env = Environment.dev;
    if (savedEnvIndex != null) {
      env = Environment.values[savedEnvIndex];
    }
    _updateConfig(env);
  }

  Future<void> setEnvironment(Environment env) async {
    await _box.put(_envKey, env.index);
    _updateConfig(env);
  }

  void _updateConfig(Environment env) {
    switch (env) {
      case Environment.dev:
        _currentConfig = AppConfig(
          environment: Environment.dev,
          apiBaseUrl: EnvDev.baseUrl,
          appName: 'Flutter Starter Kit (Dev)',
        );
        break;
      case Environment.stage:
        _currentConfig = AppConfig(
          environment: Environment.stage,
          apiBaseUrl: EnvStage.baseUrl,
          appName: 'Flutter Starter Kit (Stage)',
        );
        break;
      case Environment.test:
        _currentConfig = AppConfig(
          environment: Environment.test,
          apiBaseUrl: EnvTest.baseUrl,
          appName: 'Flutter Starter Kit (Test)',
        );
        break;
      case Environment.prod:
        _currentConfig = AppConfig(
          environment: Environment.prod,
          apiBaseUrl: EnvProd.baseUrl,
          appName: 'Flutter Starter Kit',
        );
        break;
    }
  }
}
