part of 'auth_cubit.dart';

/// A sealed class representing the different states of the authentication process.
///
/// Using a sealed class allows for exhaustive pattern matching in the UI,
/// ensuring that all possible states are handled.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// The initial state of the authentication flow, before any action has been taken.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// The state indicating that an authentication process (e.g., login, register)
/// is currently in progress.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// The state representing a successfully authenticated user.
///
/// This state holds the [User] object, making it available to the UI.
final class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// The state indicating that an error has occurred during authentication.
///
/// This state holds an error [message] that can be displayed to the user.
final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
