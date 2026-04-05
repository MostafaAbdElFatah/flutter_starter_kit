import '../../../../core/extensions/datetime/datetime_extension.dart';
import '../../../../core/extensions/iterable/iterable_extension.dart';

/// A data transfer object (DTO) representing the request body for a user registration.
///
/// This class extends [RegisterCredentials] and adds serialization/deserialization
/// logic to convert the object to and from JSON for API communication. It is
/// designed to be immutable.
/// Represents the credentials required for a new user to register.
///
/// This class is a domain entity designed to be immutable, ensuring that
/// registration data remains consistent throughout the registration flow.
final class RegisterCredentials {
  /// Creates an instance of [RegisterCredentials].
  ///
  /// The [phone] and [gender] fields are mandatory for a valid registration.
  const RegisterCredentials({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.city,
    this.dateOfBirth,
  });

  /// The user's full name.
  ///
  /// May be null if the registration process allows for anonymous or
  /// partial profiles.
  final String name;

  /// The user's email address.
  ///
  /// Often used for notifications or password recovery.
  final String email;

  /// The primary phone number used for account identification and verification.
  final String? phone;

  /// The unique identifier or code for the user's district.
  final String? city;

  /// The user's date of birth.
  ///
  /// Used for age verification or personalized experiences.
  final DateTime? dateOfBirth;

  /// The user's password.
  final String password;

  /// Creates a new [RegisterRequest] instance with updated fields.
  ///
  /// This method is useful for creating a modified copy of the object without
  /// altering the original.
  RegisterCredentials copyWith({
    String? name,
    String? email,
    String? password,
    String? phone,
    DateTime? dateOfBirth,
    String? city,
  }) {
    return RegisterCredentials(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  /// Converts this [RegisterCredentials] instance into a query parameters map.
  ///
  /// The resulting map is cleaned to remove any fields that are `null`,
  /// ensuring a compact payload for API requests.
  Map<String, dynamic> toQueryParams() => {
    "name": name,
    "email": email,
    "password": password,
    "phone": phone,
    "city_id": city,
    "dob": dateOfBirth?.yMMd,
  }..removeNulls;
}
