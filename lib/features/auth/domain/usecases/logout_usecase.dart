import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// A use case for logging out the current user.
///
/// This class encapsulates the business logic for logging out. It interacts with
/// the [AuthRepository] to clear local session data and sign the user out.
@lazySingleton
class LogoutUseCase extends AsyncUseCase<AuthRepository, void, NoParams>{

  /// Creates an instance of [LogoutUseCase].
  ///
  /// Requires an [AuthRepository] to be injected.
  LogoutUseCase(super.repository);

  /// Executes the logout use case.
  ///
  /// This will clear any cached user data and delete the authentication token.
  @override
  Future<void> call(NoParams params) => repository.logout();
}
