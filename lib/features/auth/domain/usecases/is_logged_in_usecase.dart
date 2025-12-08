import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/domain/entities/no_params.dart';
import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// A use case that checks if a user is currently logged in.
///
/// This use case is responsible for determining the user's authentication status
/// by checking for the presence of a locally stored authentication token.
@lazySingleton
class IsLoggedInUseCase extends AsyncUseCase<AuthRepository, bool, NoParams>{

  /// Creates an instance of [IsLoggedInUseCase].
  ///
  /// Requires an [AuthRepository] to be injected.
  IsLoggedInUseCase(super.repository);

  /// Executes the use case.
  ///
  /// Returns a [Future] that completes with a boolean indicating whether the
  /// user is logged in. It returns `true` if a token is found, and `false`
  /// otherwise. In case of an error, it defaults to `false`.
  @override
  Future<bool> call(NoParams params) => repository.isLoggedIn();
}
