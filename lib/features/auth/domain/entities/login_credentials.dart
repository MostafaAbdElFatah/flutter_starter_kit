/// Represents the credentials required for a user to log in.
///
/// This class is an entity in the domain layer and is designed to be immutable.
class LoginCredentials{
  /// Creates an instance of [LoginCredentials].
  const LoginCredentials({
    required this.email,
    required this.password,
    this.deviceName,
  });

  /// The user's email address.
  final String email;

  /// The user's password.
  final String password;

  /// The name of the device being used to log in.
  ///
  /// This is optional and may be used for security or session management purposes.
  final String? deviceName;
}
