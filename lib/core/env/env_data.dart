import 'env.dart';
import 'environment.dart';

/// A centralized provider for environment-specific constants.
///
/// This class uses a map to retrieve environment data, avoiding large
/// switch-case statements and centralizing configuration in one place.
class AppConfig {
  final String baseUrl;
  final Environment environment;
  final String moyasarPublishableKey;

  const AppConfig._({
    required this.baseUrl,
    required this.environment,
    required this.moyasarPublishableKey,
  });

  /// A map holding the configuration data for each environment.
  static final Map<Environment, AppConfig> _envData = {
    Environment.dev: _devEnvData,
    Environment.prod: _prodEnvData,
  };

  /// Retrieves the configuration data for a specific [Environment].
  static AppConfig get(Environment env) => _envData[env]!;

  /// Configuration for the Development environment, loaded from `.env.dev`.
  static final AppConfig _devEnvData = AppConfig._(
    baseUrl: EnvDev.baseUrl,
    environment: Environment.dev,
    moyasarPublishableKey: EnvDev.moyasarPublishableKey,
  );


  /// Configuration for the Production environment, loaded from `.env.prod`.
  static final AppConfig _prodEnvData = AppConfig._(
    baseUrl: EnvProd.baseUrl,
    environment: Environment.prod,
    moyasarPublishableKey: EnvProd.moyasarPublishableKey,
  );
}
