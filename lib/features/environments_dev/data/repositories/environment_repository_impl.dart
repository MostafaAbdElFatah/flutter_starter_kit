import 'package:injectable/injectable.dart' hide Environment;

import '../../domain/entities/app_env_config.dart';
import '../../domain/entities/base_url_config.dart';
import '../../domain/entities/developer_credentials.dart';
import '../../domain/entities/environment.dart';
import '../../domain/repositories/environment_repository.dart';
import '../datasources/environment_local_data_source.dart';
import '../models/base_url_config.dart';

/// The concrete implementation of the [EnvironmentRepository] interface.
///
/// This class interacts with the [ConfigService] to manage and retrieve
/// environment-specific configurations.
@LazySingleton(as: EnvironmentRepository)
class EnvironmentRepositoryImpl implements EnvironmentRepository {
  final EnvLocalDataSource _localDataSource;

  /// Creates an instance of [EnvironmentRepositoryImpl].
  EnvironmentRepositoryImpl(this._localDataSource);

  @override
  AppConfig get currentConfig => _localDataSource.currentConfig;

  @override
  AppConfig getConfigForEnvironment(Environment env) =>
      _localDataSource.getConfigForEnvironment(env);

  @override
  Future<void> updateConfiguration({
    required Environment environment,
    BaseUrlConfig? baseUrlConfig,
  }) => _localDataSource.updateConfiguration(
    environment,
    baseUrlConfig: BaseUrlConfigModel.fromEntity(baseUrlConfig),
  );

  @override
  bool loginAsDeveloper(DeveloperCredentials credentials) {
    // Check credentials against AppConfig
    // Note: In a real app, these should probably be hashed or checked against a secure source.
    // For this requirement, we check against AppConfig.

    // Since AppConfig is static/singleton-like in how it's accessed usually,
    // we might need to define these credentials in AppConfig first.
    // For now, let's assume hardcoded check based on "in AppConfig" requirement.
    // We will add `devUsername` and `devPassword` to AppConfig later.
    final config = _localDataSource.currentConfig;
    final isValid =
        credentials.username == config.devUsername &&
        credentials.password == config.devPassword;
    return isValid;
  }
}
