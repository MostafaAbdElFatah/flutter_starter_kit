import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart' hide Environment;

import '../../../../core/infrastructure/use_cases/usecase.dart';
import '../repository/environment_repository.dart';
import '../entities/base_url_config.dart';
import '../entities/environment.dart';

/// A use case for switching the application's environment and/or base URL config.
///
/// This class encapsulates the business logic for updating the active configuration,
/// providing a clean and testable interface for the presentation layer.
@lazySingleton
final class UpdateEnvironmentConfigUseCase
    extends AsyncUseCase<EnvironmentRepository, void, EnvironmentConfigUpdateParams> {
  /// Creates an instance of [UpdateEnvironmentConfigUseCase].
  ///
  /// Requires an [EnvironmentRepository] to be injected.
  UpdateEnvironmentConfigUseCase(super.repository);

  /// Executes the use case.
  ///
  /// Updates the environment and/or base URL configuration and persists the changes.
  /// The application will typically need to be restarted for the changes to take full effect.
  ///
  /// ### Parameters:
  /// - [environment]: The new [Environment] to switch to.
  /// - [baseUrlConfig]: The new [BaseUrlConfig] to apply.
  @override
  Future<void> call(EnvironmentConfigUpdateParams params) =>
      repository.updateConfiguration(params);
}

class EnvironmentConfigUpdateParams extends Equatable{
  final Environment environment;
  final BaseUrlConfig? baseUrlConfig;
  const EnvironmentConfigUpdateParams(this.environment, {this.baseUrlConfig});

  @override
  List<Object?> get props => [environment, baseUrlConfig];
}