import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/get_authenticated_user_usecase.dart';
import '../../domain/usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

part 'auth_state.dart';
part 'auth_cubit_impl.dart';

/// An abstract class defining the contract for the [AuthCubit].
///
/// This contract ensures that any implementation of the [AuthCubit] provides a
/// standardized interface for managing user authentication. It covers essential
/// functionalities such as checking the current auth status, logging in, registering,
/// logging out, and deleting an account.
abstract class AuthCubit extends Cubit<AuthState> {
  /// Creates an [AuthCubit] instance with an initial state.
  AuthCubit(super.initialState);

  /// A static helper method to retrieve the [AuthCubit] instance from the widget tree.
  ///
  /// This simplifies accessing the cubit from UI components.
  ///
  /// Example:
  /// ```dart
  /// AuthCubit.of(context).login(email: 'test@test.com', password: '123');
  /// ```
  static AuthCubit of(context) => BlocProvider.of(context);

  /// Checks the user's current authentication status.
  ///
  /// This should be called when the application starts to determine if the user
  /// is already logged in, emitting [AuthAuthenticated] or [AuthInitial] accordingly.
  Future<void> checkAuthStatus();

  /// Initiates the login process with the provided credentials.
  ///
  /// This method should handle the logic for authenticating the user
  /// with their email and password, emitting appropriate states like
  /// [AuthLoading], [AuthAuthenticated], or [AuthError].
  ///
  /// ### Parameters:
  /// - `email`: The email address provided by the user.
  /// - `password`: The password provided by the user.
  void login({required String email, required String password});

  /// Initiates the registration process for a new user.
  ///
  /// This method should handle the logic for creating a new user account,
  /// emitting appropriate states like [AuthLoading], [AuthAuthenticated], or [AuthError].
  ///
  /// ### Parameters:
  /// - `name`: The user's full name.
  /// - `email`: The user's email address.
  /// - `password`: The desired password for the new account.
  void register({
    required String name,
    required String email,
    required String password,
  });

  /// Logs out the currently authenticated user.
  ///
  /// This method should clear any local session data and reset the
  /// authentication state to [AuthInitial].
  Future<void> logout();

  /// Deletes the currently authenticated user's account.
  ///
  /// This method should handle the logic for permanently deleting the user's
  /// account from the server and clearing all local data. After deletion,
  /// the state should be reset to [AuthInitial].
  Future<void> deleteAccount();
}
