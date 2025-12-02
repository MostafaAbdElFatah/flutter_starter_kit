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
  final GetAuthenticatedUserUseCase _getAuthenticatedUserUseCase;

  /// Creates an instance of [AuthCubitImpl].
  ///
  /// Requires all authentication-related use cases to be injected.
  AuthCubitImpl({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required IsLoggedInUseCase isLoggedInUseCase,
    required GetAuthenticatedUserUseCase getAuthenticatedUserUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       //_isLoggedInUseCase = isLoggedInUseCase,
       _getAuthenticatedUserUseCase = getAuthenticatedUserUseCase,
       super(const AuthInitial());

  /// Checks the user's current authentication status when the app starts.
  ///
  /// It attempts to retrieve the cached user. If successful, it emits
  /// [AuthAuthenticated]; otherwise, it emits [AuthInitial].
  @override
  Future<void> checkAuthStatus() async {
    try {
      final loggedUser = await _getAuthenticatedUserUseCase();
      loggedUser != null
          ? emit(AuthAuthenticated(loggedUser))
          : emit(const AuthInitial());
    } catch (e) {
      // If checking auth status fails, assume the user is not logged in.
      emit(const AuthInitial());
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
      final user = await _loginUseCase(email: email, password: password);
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
        name: name,
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Logs out the current user.
  ///
  /// Emits [AuthLoading], then clears the local session and emits [AuthInitial].
  /// If an error occurs, it emits [AuthError].
  @override
  Future<void> logout() async {
    emit(const AuthLoading());
    try {
      await _logoutUseCase();
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // --- Unimplemented Methods ---

  @override
  void signInWithApple() {
    // TODO: implement signInWithApple
    throw UnimplementedError();
  }

  @override
  void signInWithFacebook() {
    // TODO: implement signInWithFacebook
    throw UnimplementedError();
  }

  @override
  void signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  void forgetPassword({required String email}) {
    // TODO: implement forgetPassword
    throw UnimplementedError();
  }
}
