
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Base abstract class representing a use case in your application.
///

/// An abstract class representing a synchronous use case.
///
/// A use case encapsulates a single, specific business rule of the application.
/// It is a callable class that should have a single responsibility.
///
/// This base class is for synchronous operations. For asynchronous operations,
/// see [AsyncUseCase].
///
/// ### Type Parameters:
/// [R] is the type of the repository used by the use case.
/// [T] is the return type of the use case execution.
/// [P] is the type of the parameters required by the use case  Use [NoParams].
///   if the use case does not require any parameters.
///
/// ### Example:
/// ```dart
/// // A use case that validates an email synchronously.
/// class ValidateEmailUseCase extends UseCase<bool, String> {
///   @override
///   bool call(String email) {
///     return RegExp(r'[^@]+@[^@]+\.[^@]+').hasMatch(email);
///   }
/// }
/// ```
abstract class UseCase<R, T, P> {
  final R _repository;
  /// Creates a use case with the given repository.
  UseCase(this._repository);

  /// Exposes the repository instance.
  @protected
  R get repository => _repository;

  T call(P params);
}

/// An abstract class representing an asynchronous use case.
///
/// A use case encapsulates a single, specific business rule of the application.
/// It is a callable class that should have a single responsibility.
///
/// This base class is for asynchronous operations that return a [Future]. For
/// synchronous operations, see [UseCase].
///
/// ### Type Parameters:
/// [R] is the type of the repository used by the use case.
/// [T] is the return type of the use case execution.
/// [P] is the type of the parameters required by the use case  Use [NoParams].
///   if the use case does not require any parameters.
///
/// ### Example:
/// ```dart
/// @lazySingleton
/// class LoginUseCase extends AsyncUseCase<User, LoginParams> {
///   final AuthRepository _repository;
///   LoginUseCase(this._repository);
///
///   @override
///   Future<User> call(LoginParams params) {
///     return _repository.login(email: params.email, password: params.password);
///   }
/// }
///
/// class LoginParams extends Equatable {
///   final String email;
///   final String password;
///   // ...
/// }
/// ```
abstract class AsyncUseCase<R, T, P> {
  final R _repository;
  /// Creates a use case with the given repository.
  AsyncUseCase(this._repository);

  /// Exposes the repository instance.
  @protected
  R get repository => _repository;

  Future<T> call(P params);
}

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
