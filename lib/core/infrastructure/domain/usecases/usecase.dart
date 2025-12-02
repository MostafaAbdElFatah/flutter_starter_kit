/// Base abstract class representing a use case in your application.
///
/// [R] is the type of the repository used by the use case.
/// [T] is the return type of the use case execution.
/// [P] is the type of the parameters required by the use case.
abstract class UseCase<R> {
  final R _repository;

  /// Creates a use case with the given repository.
  UseCase(this._repository);

  /// Exposes the repository instance.
  R get repository => _repository;
}
