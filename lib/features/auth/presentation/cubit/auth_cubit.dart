import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/use_cases/usecase.dart';
import '../../../../core/infrastructure/cubits/base_cubit.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/entities/register_credentials.dart';
import '../../domain/entities/user.dart';
import '../../domain/use_cases/delete_account_usecase.dart';
import '../../domain/use_cases/get_authenticated_user_usecase.dart';
import '../../domain/use_cases/is_logged_in_usecase.dart';
import '../../domain/use_cases/login_usecase.dart';
import '../../domain/use_cases/logout_usecase.dart';
import '../../domain/use_cases/register_usecase.dart';

part 'auth_state.dart';

enum AuthOperation {
  login,
  register,
  logout,
  deleteAccount,
}

/// The concrete implementation of the [AuthCubit].
///
/// This class manages the authentication state by interacting with various use cases.
/// It handles the logic for checking auth status, logging in, registering, and logging out.
// class AuthCubit extends BaseCubit<AuthState> {
//   AuthCubit() : super(const AuthInitial());
@injectable
class AuthCubit extends BaseCubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  //final IsLoggedInUseCase _isLoggedInUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final GetAuthenticatedUserUseCase _getAuthenticatedUserUseCase;

  /// Creates an instance of [AuthCubitImpl].
  ///
  /// Requires all authentication-related use cases to be injected.
  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required IsLoggedInUseCase isLoggedInUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required GetAuthenticatedUserUseCase getAuthenticatedUserUseCase,
  }) : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
         //_isLoggedInUseCase = isLoggedInUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _getAuthenticatedUserUseCase = getAuthenticatedUserUseCase,
        super(const AuthInitial());

  /// A static helper method to retrieve the [AuthCubit] instance from the widget tree.
  ///
  /// This simplifies accessing the cubit from UI components.
  ///
  /// Example:
  /// ```dart
  /// AuthCubit.of(context).login(email: 'test@test.com', password: '123');
  /// ```
  static AuthCubit of(BuildContext context, {bool listen = false}) =>
      BaseCubit.of(context, listen: listen);

  /// Checks the user's current authentication status when the app starts.
  ///
  /// It attempts to retrieve the cached user. If successful, it emits
  /// [AuthAuthenticated]; otherwise, it emits [AuthUnauthenticated].
  Future<void> checkAuthStatus() async {
    try {
      final loggedUser = _getAuthenticatedUserUseCase(NoParams());
      emit(loggedUser != null
          ? AuthAuthenticated(loggedUser)
          : const AuthUnauthenticated());
    } catch (e) {
      // If checking auth status fails, assume the user is not logged in.
      emit(AuthError(e.toString()));
    }
  }

  /// Logs in the user with the provided [email] and [password].
  ///
  /// Emits [AuthLoading], then either [AuthAuthenticated] on success or
  /// [AuthError] on failure.
  void login({required String email, required String password}) async {
    try {
      emit(const AuthLoading());
      final result = await runLatest<User>(
        AuthOperation.login,
        _loginUseCase(LoginCredentials(email: email, password: password)),
      );
      if (result.isCanceled) return;
      emit(AuthAuthenticated(result.requireValue<User>()));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Registers a new user with the given details.
  ///
  /// Emits [AuthLoading], then either [AuthAuthenticated] on success or
  /// [AuthError] on failure.
  void register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final result = await runLatest<User>(
        AuthOperation.register,
        _registerUseCase(
          RegisterCredentials(name: name, email: email, password: password),
        ),
      );
      if (result.isCanceled) return;
      emit(AuthAuthenticated(result.requireValue<User>()));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Logs out the current user.
  ///
  /// Emits [AuthLoading], then clears the local session and emits [AuthUnauthenticated].
  /// If an error occurs, it emits [AuthError].
  Future<void> logout() async {
    emit(const AuthLoading());
    try {
      final result = await runLatest<void>(
        AuthOperation.logout,
        _logoutUseCase(NoParams()),
      );
      if (result.isCanceled) return;
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// delete the current account.
  ///
  /// Emits [AuthLoading], then clears the local session and emits [AuthUnauthenticated].
  /// If an error occurs, it emits [AuthError].
  Future<void> deleteAccount() async {
    emit(const AuthLoading());
    try {
      final result = await runLatest<void>(
        AuthOperation.deleteAccount,
        _deleteAccountUseCase(NoParams()),
      );
      if (result.isCanceled) return;
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
