import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../entities/register_credentials.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';

/// A use case for registering a new user.
///
/// This class encapsulates the business logic for user registration. It interacts
/// with the [AuthRepository] to perform the registration and returns the result
/// to the presentation layer.
@lazySingleton
class RegisterUseCase
    extends AsyncUseCase<AuthRepository, User, RegisterCredentials> {
  /// Creates an instance of [RegisterUseCase].
  ///
  /// Requires an [AuthRepository] to be injected.
  RegisterUseCase(super.repository);

  /// Executes the register use case.
  ///
  /// Takes the user's [name], [email], and [password] as input and attempts
  /// to register them.
  ///
  /// Returns a [Future] that completes with either an [Exception] if the
  /// operation fails, or a [User] object if the registration is successful.
  @override
  Future<User> call(RegisterCredentials params) => repository.register(params);
}
