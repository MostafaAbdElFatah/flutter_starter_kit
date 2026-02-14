import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart' hide Environment;

import '../../../../core/infrastructure/use_cases/usecase.dart';
import '../entities/api_config.dart';
import '../entities/environment.dart';
import '../repository/environment_repository.dart';

/// A use case for retrieving the static configuration for a specific environment.
///
/// This class encapsulates the business logic for fetching the configuration
/// details (like API keys and default URLs) for a given [Environment].
@lazySingleton
final class GetEnvironmentConfigUseCase extends UseCase<EnvironmentRepository, APIConfig, EnvironmentConfigGetParams>{

  /// Creates an instance of [GetEnvironmentConfigUseCase].
  ///
  /// Requires an [EnvironmentRepository] to be injected.
  GetEnvironmentConfigUseCase(super.repository);

  /// Executes the use case.
  ///
  /// Returns the [AppEnvConfig] for the specified [env].
  @override
  APIConfig call(EnvironmentConfigGetParams params) => repository.getConfigForEnvironment(params);
}

class EnvironmentConfigGetParams extends Equatable{

  final Environment env;
  const EnvironmentConfigGetParams(this.env);

  @override
  List<Object?> get props => [env];
}