import '../../../../../core/extensions/iterable_extension.dart';
import '../../../domain/entities/register_credentials.dart';

/// A data transfer object (DTO) representing the request body for a user registration.
///
/// This class extends [RegisterCredentials] and adds serialization/deserialization
/// logic to convert the object to and from JSON for API communication. It is
/// designed to be immutable.
final class RegisterRequest extends RegisterCredentials {
  /// Creates an instance of [RegisterRequest].
  const RegisterRequest({
    required super.name,
    required super.email,
    required super.password,
    super.confirmPassword,
    super.deviceName,
  });

  /// Creates a new [RegisterRequest] instance with updated fields.
  ///
  /// This method is useful for creating a modified copy of the object without
  /// altering the original.
  RegisterRequest copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    String? deviceName,
  }) {
    return RegisterRequest(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      deviceName: deviceName ?? this.deviceName,
    );
  }

  /// Creates a [RegisterRequest] instance from a JSON map.
  ///
  /// This factory is used to deserialize data from a form or
  /// reconstruct the object from a local data source.
  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        name: json["name"],
        email: json["email"],
        password: json["password"],
        confirmPassword: json["password_confirmation"],
        deviceName: json["device_name"],
      );

  /// Converts this [RegisterRequest] instance into a JSON map.
  ///
  /// The resulting map is cleaned to remove any `null` values,
  /// ensuring a compact JSON payload for API requests.
  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": confirmPassword,
        "device_name": deviceName,
      }..removeNulls;

  /// Converts this data transfer object into a [RegisterCredentials] domain entity.
  ///
  /// This is useful for mapping data from the data layer to the domain layer.
  RegisterCredentials toEntity() => RegisterCredentials(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        deviceName: deviceName,
      );
}
