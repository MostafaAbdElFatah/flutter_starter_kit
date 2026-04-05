import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/domain/use_cases/usecase.dart';
import '../entities/register_credentials.dart';
import '../repository/auth_repository.dart';

/// A use case for registering a new user.
///
/// This class encapsulates the business logic for user registration. It interacts
/// with the [AuthRepository] to perform the registration and returns the result
/// to the presentation layer.
@lazySingleton
class RegisterUseCase
    extends AsyncUseCase<AuthRepository, void, RegisterCredentials> {
  RegisterUseCase(super.repository);

  /// Executes the register use case.
  ///
  /// Takes the user's [name], [email], and [password] as input and attempts
  /// to register them.
  ///
  /// 1. Retrieves the cached [Gender] from the filters repository.
  /// 2. If no gender is found, throws an [Exception] with the relevant localization key.
  /// 3. Returns a [Future] that completes with either an [Exception] if the
  /// operation fails, or a [void] if the registration is successful.
  @override
  Future<void> call(RegisterCredentials credentials) {
    return repository.register(credentials);
  }
}
