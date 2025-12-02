import '../../domain/entities/user.dart';

/// A data transfer object (DTO) that represents the user data from the API.
///
/// This class extends the domain [User] entity and adds serialization logic
/// to convert the object to and from JSON for communication with the API.
/// It is designed to be immutable.
final class UserModel extends User {
  /// Creates an instance of [UserModel].
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.avatarUrl,
    required super.isVerified,
  });

  /// Creates a copy of this [UserModel] but with the given fields replaced with the new values.
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  /// Creates a [UserModel] instance from a JSON map.
  ///
  /// This factory is used to deserialize the response from an API call.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"].toString(),
      name: json["name"],
      email: json["email"],
      avatarUrl: json["avatar_url"],
      isVerified: json.containsKey("has_verified_email")
          ? json["has_verified_email"] as bool
          : false,
    );
  }

  /// Converts this [UserModel] instance into a JSON map for API requests.
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "avatar_url": avatarUrl,
        "has_verified_email": isVerified,
      };

  /// Converts this data transfer object into a [User] domain entity.
  ///
  /// This is useful for mapping data from the data layer to the domain layer.
  User toEntity() => User(
        id: id,
        email: email,
        name: name,
        avatarUrl: avatarUrl,
        isVerified: isVerified,
      );
}
