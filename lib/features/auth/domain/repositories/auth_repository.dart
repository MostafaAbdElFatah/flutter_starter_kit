import '../entities/user.dart';

/// An abstract repository that defines the contract for authentication-related operations.
///
/// This repository is responsible for abstracting the data sources (remote and local)
/// and providing a clean API for the domain layer to interact with.
abstract class AuthRepository {
  /// Logs in a user with the given [email] and [password].
  ///
  /// Returns a [Future] that completes with either an [Exception] if the
  /// operation fails, or a [User] object if the login is successful.
  Future<User> login({required String email, required String password});

  /// Registers a new user with the given [name], [email], and [password].
  ///
  /// Returns a [Future] that completes with either an [Exception] if the
  /// operation fails, or a [User] object if the registration is successful.
  Future<User> register({
    required String name,
    required String email,
    required String password,
  });

  /// Checks if a user is currently logged in.
  ///
  /// This is determined by checking for the presence of a locally stored auth token.
  ///
  /// Returns a [Future] that completes with either an [Exception] if an
  /// error occurs while checking, or a [bool] indicating the login status.
  Future<bool> isLoggedIn();

  /// Retrieves the currently authenticated user, if any.
  ///
  /// This is determined by checking for a locally stored auth token and then
  /// fetching the cached user data.
  ///
  /// Returns the [User] object if found, otherwise returns `null`.
  Future<User?> getAuthenticatedUser();

  /// Logs out the current user.
  ///
  /// This will clear any cached user data and delete the authentication token.
  Future<void> logout();
}
