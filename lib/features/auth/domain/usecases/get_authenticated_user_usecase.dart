import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// A use case that retrieves the currently authenticated user.
///
/// This use case is responsible for checking if a user session exists and
/// returning the [User] object if one is found.
@lazySingleton
class GetAuthenticatedUserUseCase extends UseCase<AuthRepository> {
  /// Creates an instance of [GetAuthenticatedUserUseCase].
  ///
  /// Requires an [AuthRepository] to be injected.
  GetAuthenticatedUserUseCase(super.repository);

  /// Executes the use case.
  ///
  /// Returns the authenticated [User] object if a session is active, otherwise
  /// returns `null`.
  Future<User?> call() => repository.getAuthenticatedUser();
}
