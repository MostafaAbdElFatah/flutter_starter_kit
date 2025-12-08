import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/domain/entities/no_params.dart';
import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../entities/api_config.dart';
import '../repositories/environment_repository.dart';

/// A use case for retrieving the current application configuration.
///
/// This class encapsulates the business logic for fetching the current [AppConfig],
/// providing a clean and testable interface for the presentation layer.
@lazySingleton
final class GetCurrentApiConfigUseCase extends UseCase<EnvironmentRepository, ApiConfig, NoParams>{

  /// Creates an instance of [GetCurrentApiConfigUseCase].
  ///
  /// Requires an [EnvironmentRepository] to be injected.
  GetCurrentApiConfigUseCase(super.repository);

  /// Executes the use case.
  ///
  /// Returns the current [AppConfig] synchronously.
  @override
  ApiConfig call(NoParams params) => repository.currentApiConfig;
}
