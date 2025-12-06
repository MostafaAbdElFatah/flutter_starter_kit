import 'package:injectable/injectable.dart' hide Environment;

import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../entities/app_env_config.dart';
import '../entities/environment.dart';
import '../repositories/environment_repository.dart';

/// A use case for retrieving the static configuration for a specific environment.
///
/// This class encapsulates the business logic for fetching the configuration
/// details (like API keys and default URLs) for a given [Environment].
@lazySingleton
final class GetEnvironmentConfigUseCase extends UseCase<EnvironmentRepository>{

  /// Creates an instance of [GetEnvironmentConfigUseCase].
  ///
  /// Requires an [EnvironmentRepository] to be injected.
  GetEnvironmentConfigUseCase(super.repository);

  /// Executes the use case.
  ///
  /// Returns the [AppEnvConfig] for the specified [env].
  AppConfig call(Environment env) => repository.getConfigForEnvironment(env);
}
