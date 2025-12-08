import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../entities/login_credentials.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// A use case for logging in a user.
///
/// This class encapsulates the business logic for user login. It interacts with
/// the [AuthRepository] to perform the login operation and returns the result
/// to the presentation layer.
@lazySingleton
class LoginUseCase extends AsyncUseCase<AuthRepository, User, LoginCredentials> {
  /// Creates an instance of [LoginUseCase].
  ///
  /// Requires an [AuthRepository] to be injected.
  LoginUseCase(super.repository);

  /// Executes the login use case.
  ///
  /// Takes the user's [email] and [password] as input and attempts to log them in.
  ///
  /// Returns a [Future] that completes with either an [Exception] if the
  /// operation fails, or a [User] object if the login is successful.
  @override
  Future<User> call(LoginCredentials params) => repository.login(params);
}
