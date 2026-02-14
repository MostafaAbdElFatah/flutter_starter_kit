import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';

/// A use case that retrieves the currently authenticated user.
///
/// This use case is responsible for checking if a user session exists and
/// returning the [User] object if one is found.
@lazySingleton
class GetAuthenticatedUserUseCase extends UseCase<AuthRepository, User?, NoParams>{
  /// Creates an instance of [GetAuthenticatedUserUseCase].
  ///
  /// Requires an [AuthRepository] to be injected.
  GetAuthenticatedUserUseCase(super.repository);

  /// Executes the use case.
  ///
  /// Returns the authenticated [User] object if a session is active, otherwise
  /// returns `null`.
  @override
  User? call(NoParams params) => repository.getAuthenticatedUser();
}
