/// Represents the credentials required for a new user to register.
///
/// This class is an entity in the domain layer and is designed to be immutable.
class RegisterCredentials{
  /// Creates an instance of [RegisterCredentials].
  ///
  /// If [confirmPassword] is not provided, it defaults to the value of [password].
  const RegisterCredentials({
    required this.name,
    required this.email,
    required this.password,
    String? confirmPassword,
    this.deviceName,
  }) : confirmPassword = confirmPassword ?? password;

  /// The user's full name.
  final String name;

  /// The user's email address.
  final String email;

  /// The user's desired password.
  final String password;

  /// The confirmation of the user's password.
  ///
  /// This is used to ensure the user has typed their password correctly.
  final String confirmPassword;

  /// The name of the device being used to register.
  ///
  /// This is optional and may be used for security or session management purposes.
  final String? deviceName;
}
