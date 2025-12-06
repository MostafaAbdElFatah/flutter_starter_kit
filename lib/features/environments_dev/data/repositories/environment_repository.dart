import 'package:injectable/injectable.dart' hide Environment;

import '../../domain/entities/app_env_config.dart';
import '../../domain/entities/base_url_config.dart';
import '../../domain/entities/environment.dart';
import '../../domain/repositories/environment_repository.dart';
import '../datasources/environment_local_data_source.dart';
import '../models/base_url_config.dart';

/// The concrete implementation of the [AuthRepository] interface.
///
/// This class orchestrates authentication-related operations by coordinating
/// between remote and local data sources. It is responsible for making API
/// calls, handling responses, and caching data locally.
@LazySingleton(as: EnvironmentRepository)
class EnvironmentRepositoryImpl implements EnvironmentRepository {
  final EnvLocalDataSource _localDataSource;

  EnvironmentRepositoryImpl(this._localDataSource);

  @override
  AppConfig get currentConfig => _localDataSource.currentConfig;

  @override
  AppConfig getConfigForEnvironment(Environment env) => _localDataSource.getConfigForEnvironment(env);

  @override
  Future<void> updateConfiguration(
    Environment environment, {
    BaseUrlConfig? baseUrlConfig,
  }) => _localDataSource.updateConfiguration(
    environment,
    baseUrlConfig: BaseUrlConfigModel.fromEntity(baseUrlConfig),
  );
}
