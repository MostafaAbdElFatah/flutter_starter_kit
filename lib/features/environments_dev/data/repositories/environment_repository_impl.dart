import 'package:injectable/injectable.dart' hide Environment;

import '../../domain/entities/api_config.dart';
import '../../domain/entities/environment.dart';
import '../../domain/repositories/environment_repository.dart';
import '../../domain/usecases/developer_login_usecase.dart';
import '../../domain/usecases/get_environment_config_use_case.dart';
import '../../domain/usecases/update_environment_configuration_use_case.dart';
import '../datasources/environment_local_data_source.dart';
import '../models/base_url_config.dart';

/// The concrete implementation of the [EnvironmentRepository] interface.
///
/// This class interacts with the [ConfigService] to manage and retrieve
/// environment-specific configurations.
@LazySingleton(as: EnvironmentRepository)
class EnvironmentRepositoryImpl implements EnvironmentRepository {
  final EnvironmentLocalDataSource _localDataSource;

  /// Creates an instance of [EnvironmentRepositoryImpl].
  EnvironmentRepositoryImpl(this._localDataSource);

  /// Retrieves the API configuration for the currently selected environment.
  ///
  /// This is a convenience getter that combines `currentEnvironment` and
  /// `getConfigForEnvironment`. It provides the API key and base URL for the
  /// active environment.
  @override
  APIConfig get currentApiConfig => _localDataSource.currentApiConfig;

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
  APIConfig getConfigForEnvironment(EnvironmentConfigGetParams params) =>
      _localDataSource.getConfigForEnvironment(params.env);

  @override
  Future<void> updateConfiguration(EnvironmentConfigUpdateParams params) =>
      _localDataSource.updateConfiguration(
        params.environment,
        baseUrlConfig: BaseUrlConfigModel.fromEntity(params.baseUrlConfig),
      );

  @override
  bool loginAsDeveloper(DevLoginParams params) {
    final env = _localDataSource.currentEnvironment;
    final config = _localDataSource.getAuthConfigForEnvironment(env);
    final isValid =
        params.username == config.username &&
        params.password == config.password;
    return isValid;
  }
}
