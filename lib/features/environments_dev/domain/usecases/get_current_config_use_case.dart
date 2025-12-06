import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../repositories/environment_repository.dart';
import '../entities/app_env_config.dart';

/// A use case for retrieving the current application configuration.
///
/// This class encapsulates the business logic for fetching the current [AppConfig],
/// providing a clean and testable interface for the presentation layer.
@lazySingleton
final class GetCurrentAppConfigUseCase extends UseCase<EnvironmentRepository>{

  /// Creates an instance of [GetCurrentAppConfigUseCase].
  ///
  /// Requires an [EnvironmentRepository] to be injected.
  GetCurrentAppConfigUseCase(super.repository);

  /// Executes the use case.
  ///
  /// Returns the current [AppConfig] synchronously.
  AppConfig call() => repository.currentConfig;
}
