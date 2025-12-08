part of 'auth_cubit.dart';

/// The concrete implementation of the [AuthCubit].
///
/// This class manages the authentication state by interacting with various use cases.
/// It handles the logic for checking auth status, logging in, registering, and logging out.
@Injectable(as: AuthCubit)
class AuthCubitImpl extends AuthCubit {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  //final IsLoggedInUseCase _isLoggedInUseCase;
  final DeleteAccountUsecase _deleteAccountUsecase;
  final GetAuthenticatedUserUseCase _getAuthenticatedUserUseCase;

  /// Creates an instance of [AuthCubitImpl].
  ///
  /// Requires all authentication-related use cases to be injected.
  AuthCubitImpl({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required IsLoggedInUseCase isLoggedInUseCase,
    required DeleteAccountUsecase deleteAccountUsecase,
    required GetAuthenticatedUserUseCase getAuthenticatedUserUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       //_isLoggedInUseCase = isLoggedInUseCase,
       _deleteAccountUsecase = deleteAccountUsecase,
       _getAuthenticatedUserUseCase = getAuthenticatedUserUseCase,
       super(const AuthInitial());

  /// Checks the user's current authentication status when the app starts.
  ///
  /// It attempts to retrieve the cached user. If successful, it emits
  /// [AuthAuthenticated]; otherwise, it emits [AuthUnauthenticated].
  @override
  Future<void> checkAuthStatus() async {
    try {
      final loggedUser = await _getAuthenticatedUserUseCase(NoParams());
      loggedUser != null
          ? emit(AuthAuthenticated(loggedUser))
          : emit(const AuthUnauthenticated());
    } catch (e) {
      // If checking auth status fails, assume the user is not logged in.
      emit(AuthError(e.toString()));
    }
  }

  /// Logs in the user with the provided [email] and [password].
  ///
  /// Emits [AuthLoading], then either [AuthAuthenticated] on success or
  /// [AuthError] on failure.
  @override
  void login({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      final user = await _loginUseCase(
        LoginCredentials(email: email, password: password),
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Registers a new user with the given details.
  ///
  /// Emits [AuthLoading], then either [AuthAuthenticated] on success or
  /// [AuthError] on failure.
  @override
  void register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _registerUseCase(
        RegisterCredentials(name: name, email: email, password: password),
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Logs out the current user.
  ///
  /// Emits [AuthLoading], then clears the local session and emits [AuthUnauthenticated].
  /// If an error occurs, it emits [AuthError].
  @override
  Future<void> logout() async {
    emit(const AuthLoading());
    try {
      await _logoutUseCase(NoParams());
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// delete the current account.
  ///
  /// Emits [AuthLoading], then clears the local session and emits [AuthUnauthenticated].
  /// If an error occurs, it emits [AuthError].
  @override
  Future<void> deleteAccount() async {
    emit(const AuthLoading());
    try {
      await _deleteAccountUsecase(NoParams());
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
