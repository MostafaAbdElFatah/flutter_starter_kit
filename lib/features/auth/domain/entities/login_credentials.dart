import '../../../../core/extensions/iterable/iterable_extension.dart';

/// A data transfer object (DTO) representing the request body for a login attempt.
///
/// This class extends [LoginCredentials] and adds serialization/deserialization
/// logic to convert the object to and from JSON for API communication. It is
/// designed to be immutable.
final class LoginCredentials {
  /// Creates an instance of [LoginCredentials].
  ///
  /// The [deviceName] is required to identify the device making the request.
  LoginCredentials({
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

  /// Creates a copy of this [LoginCredentials] instance with the provided
  /// values replacing the current ones.
  LoginCredentials copyWith({
    String? email,
    String? deviceName,
    String? password,
  }) {
    return LoginCredentials(
      email: email ?? this.email,
      deviceName: deviceName ?? this.deviceName,
      password: password ?? this.password,
    );
  }

  /// Converts this [LoginCredentials] instance into a query parameters map.
  ///
  /// The resulting map is cleaned to remove any fields that are `null`,
  /// ensuring a compact payload for API requests.
  Map<String, dynamic> toQueryParams() =>
      {"email": email, "device_name": deviceName, "password": password}
        ..removeNulls;
}
