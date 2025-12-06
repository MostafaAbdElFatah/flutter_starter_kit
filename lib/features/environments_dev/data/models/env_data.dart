import '../../domain/entities/environment.dart';
import '../env/env.dart';

/// A centralized provider for environment-specific constants.
///
/// This class uses a map to retrieve environment data, avoiding large
/// switch-case statements and centralizing configuration in one place.
final class EnvData {
  final String apiKey;
  final String defaultBaseUrl;
  final String devUser;
  final String devPass;

  const EnvData._({
    required this.apiKey,
    required this.defaultBaseUrl,
    required this.devUser,
    required this.devPass,
  });

  /// A map holding the configuration data for each environment.
  static final Map<Environment, EnvData> _envData = {
    Environment.dev: _devEnvData,
    Environment.stage: _stageEnvData,
    Environment.prod: _prodEnvData,
    Environment.test: _testEnvData,
  };

  /// Retrieves the configuration data for a specific [Environment].
  static EnvData get(Environment env) => _envData[env]!;

  /// Configuration for the Development environment, loaded from `.env.dev`.
  static final EnvData _devEnvData = EnvData._(
    apiKey: EnvDev.apiKey,
    defaultBaseUrl: EnvDev.baseUrl,
    devUser: EnvDev.envUser,
    devPass: EnvDev.envPass,
  );

  /// Configuration for the Staging environment, loaded from `.env.stage`.
  static final EnvData _stageEnvData = EnvData._(
    apiKey: EnvStage.apiKey,
    defaultBaseUrl: EnvStage.baseUrl,
    devUser: EnvDev.envUser, // Assuming dev user is same for stage
    devPass: EnvDev.envPass,
  );

  /// Configuration for the Production environment, loaded from `.env.prod`.
  static final EnvData _prodEnvData = EnvData._(
    apiKey: EnvProd.apiKey,
    defaultBaseUrl: EnvProd.baseUrl,
    devUser: EnvDev.envUser, // Assuming dev user is same for prod
    devPass: EnvDev.envPass,
  );

  /// Configuration for the Testing environment, loaded from `.env.test`.
  static final EnvData _testEnvData = EnvData._(
    apiKey: EnvTest.apiKey,
    defaultBaseUrl: EnvTest.baseUrl,
    devUser: EnvDev.envUser, // Assuming dev user is same for test
    devPass: EnvDev.envPass,
  );
}
