import '../../../../../core/extensions/iterable/iterable_extension.dart';
import '../../../domain/entities/login_credentials.dart';

/// A data transfer object (DTO) representing the request body for a login attempt.
///
/// This class extends [LoginCredentials] and adds serialization/deserialization
/// logic to convert the object to and from JSON for API communication. It is
/// designed to be immutable.
final class LoginRequest extends LoginCredentials {
  /// Creates an instance of [LoginRequest].
  ///
  /// The [deviceName] is required to identify the device making the request.
  const LoginRequest({
    required super.email,
    required super.password,
    required super.deviceName,
  });

  LoginRequest.credentials({
    required LoginCredentials credentials,
    super.deviceName,
  }) : super(email: credentials.email, password: credentials.password);

  /// Creates a [LoginRequest] instance from a JSON map.
  ///
  /// This factory is used to deserialize the response from an API call
  /// or to reconstruct the object from a local data source.
  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    email: json["email"],
    password: json["password"],
    deviceName: json["device_name"],
  );

  /// Creates a new [LoginRequest] instance with updated fields.
  ///
  /// This method is useful for creating a modified copy of the object without
  /// altering the original.
  LoginRequest copyWith({
    String? email,
    String? password,
    String? deviceName,
  }) => LoginRequest(
    email: email ?? this.email,
    password: password ?? this.password,
    deviceName: deviceName ?? this.deviceName,
  );

  /// Converts this [LoginRequest] instance into a JSON map.
  ///
  /// The resulting map is cleaned to remove any fields that are `null`,
  /// ensuring a compact JSON payload for API requests.
  Map<String, dynamic> toJson() =>
      {"email": email, "password": password, "device_name": deviceName}
        ..removeNulls;

  /// Converts this data transfer object into a [LoginCredentials] domain entity.
  ///
  /// This is useful for mapping data from the data layer to the domain layer.
  LoginCredentials toEntity() => LoginCredentials(
    email: email,
    password: password,
    deviceName: deviceName,
  );
}
