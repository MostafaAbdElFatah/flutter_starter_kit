import 'package:injectable/injectable.dart' hide Environment;

import '../../../../core/infrastructure/usecases/usecase.dart';
import '../entities/environment.dart';
import '../repositories/environment_repository.dart';

/// A use case for retrieving the current application configuration.
///
/// This class encapsulates the business logic for fetching the current [AppConfig],
/// providing a clean and testable interface for the presentation layer.
@lazySingleton
final class GetCurrentEnvironmentUseCase extends UseCase<EnvironmentRepository, Environment, NoParams>{

  /// Creates an instance of [GetCurrentEnvironmentUseCase].
  ///
  /// Requires an [EnvironmentRepository] to be injected.
  GetCurrentEnvironmentUseCase(super.repository);

  /// Executes the use case.
  ///
  /// Returns the current [Environment] synchronously.
  @override
  Environment call(NoParams params) => repository.currentEnvironment;
}
