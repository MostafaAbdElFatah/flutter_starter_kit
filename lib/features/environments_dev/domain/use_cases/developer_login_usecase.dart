import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/use_cases/usecase.dart';
import '../repository/environment_repository.dart';

/// A use case for authenticating a developer.
///
/// This class encapsulates the business logic for developer login, providing a
/// clean and testable interface for the presentation layer.
@lazySingleton
final class DeveloperLoginUseCase
    extends UseCase<EnvironmentRepository, bool, DevLoginParams> {
  /// Creates an instance of [DeveloperLoginUseCase].
  ///
  /// Requires an [EnvironmentRepository] to be injected.
  DeveloperLoginUseCase(super.repository);

  /// Executes the developer login use case.
  ///
  /// Takes the developer's [username] and [password] as input and attempts to
  /// authenticate them.
  ///
  /// Returns `true` if the login is successful, otherwise `false`.
  @override
  bool call(DevLoginParams params) => repository.loginAsDeveloper(params);
}

class DevLoginParams extends Equatable {
  final String username;
  final String password;

  const DevLoginParams({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
