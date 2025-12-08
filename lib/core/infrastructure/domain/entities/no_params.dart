
import 'package:equatable/equatable.dart';

/// A class to be used as a parameter for use cases that do not require any parameters.
///
/// Using this class provides a type-safe way to represent the absence of
/// parameters, avoiding the use of `void` or `null` which can be ambiguous.
///
/// ### Example:
/// ```dart
/// @lazySingleton
/// class GetAuthenticatedUserUseCase extends AsyncUseCase<User?, NoParams> {
///   final AuthRepository _repository;
///   GetAuthenticatedUserUseCase(this._repository);
///
///   @override
///   Future<User?> call(NoParams params) {
///     return _repository.getAuthenticatedUser();
///   }
/// }
/// ```
class NoParams extends Equatable {
  /// Creates a [NoParams] instance.
  const NoParams();

  @override
  List<Object?> get props => [];
}
