import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../entities/developer_credentials.dart';
import '../repositories/environment_repository.dart';

/// A use case for authenticating a developer.
///
/// This class encapsulates the business logic for developer login, providing a
/// clean and testable interface for the presentation layer.
@lazySingleton
final class DeveloperLoginUseCase extends UseCase<EnvironmentRepository> {
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
  bool call({required String username, required String password}) =>
      repository.loginAsDeveloper(
        DeveloperCredentials(username: username, password: password),
      );
}
