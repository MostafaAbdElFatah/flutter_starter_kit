import 'package:injectable/injectable.dart' hide Environment;

import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../repositories/environment_repository.dart';
import '../entities/base_url_config.dart';
import '../entities/environment.dart';

/// A use case for switching the application's environment and/or base URL config.
///
/// This class encapsulates the business logic for updating the active configuration,
/// providing a clean and testable interface for the presentation layer.
@lazySingleton
final class SwitchEnvironmentUseCase extends UseCase<EnvironmentRepository> {
  /// Creates an instance of [SwitchEnvironmentUseCase].
  ///
  /// Requires an [EnvironmentRepository] to be injected.
  SwitchEnvironmentUseCase(super.repository);

  /// Executes the use case.
  ///
  /// Updates the environment and/or base URL configuration and persists the changes.
  /// The application will typically need to be restarted for the changes to take full effect.
  ///
  /// ### Parameters:
  /// - [environment]: The new [Environment] to switch to.
  /// - [baseUrlConfig]: The new [BaseUrlConfig] to apply.
  Future<void> call(Environment environment, {BaseUrlConfig? baseUrlConfig}) =>
      repository.updateConfiguration(environment, baseUrlConfig: baseUrlConfig);
}
