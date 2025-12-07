import 'package:injectable/injectable.dart' hide Environment;

import '../../domain/entities/api_config.dart';
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

  /// Retrieves the API configuration for the currently selected environment.
  ///
  /// This is a convenience getter that combines `currentEnvironment` and
  /// `getConfigForEnvironment`. It provides the API key and base URL for the
  /// active environment.
  @override
  ApiConfig get currentApiConfig => _localDataSource.currentApiConfig;

  /// Retrieves the currently selected [Environment] from persistent storage.
  ///
  /// If no environment is explicitly set, it should return a default, typically [Environment.dev].
  @override
  Environment get currentEnvironment => _localDataSource.currentEnvironment;

  /// Retrieves the static API configuration (API key and default URL) for a given [Environment].
  ///
  /// This data is typically loaded from compile-time environment variables.
  ///
  /// ### Parameters:
  /// - [env]: The environment for which to get the API config.
  @override
  ApiConfig getConfigForEnvironment(Environment env) => _localDataSource.getConfigForEnvironment(env);

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
    final env = _localDataSource.currentEnvironment;
    final config = _localDataSource.getAuthConfigForEnvironment(env);
    final isValid =
        credentials.username == config.devUsername &&
        credentials.password == config.devPassword;
    return isValid;
  }
}
