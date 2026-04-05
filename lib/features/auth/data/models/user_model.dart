import 'dart:convert';

import '../../domain/entities/user.dart';

class UserModel {
  /// Creates an instance of [User].
  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    required this.isVerified,
  });

  /// The unique identifier for the user.
  final String id;

  /// The user's email address.
  final String email;

  /// The user's full name. Can be null if not provided.
  final String? name;

  /// The URL for the user's avatar image. Can be null if not set.
  final String? avatarUrl;

  /// A flag indicating whether the user's email address has been verified.
  final bool isVerified;

  /// Creates a [UserModel] instance from a JSON map.
  ///
  /// This factory is used to deserialize the response from an API call.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final profile = json["profile"] as Map<String, dynamic>?;

    final avatar = json["avatar"] ?? profile?["avatar"];

    return UserModel(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      avatarUrl: avatar,
      isVerified: json["isVerified"] ?? false,
    );
  }

  /// Creates a [UserModel] instance from a domain [User].
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
      isVerified: user.isVerified,
    );
  }

  /// Converts this [UserModel] instance into a JSON map for API requests.
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "avatar": avatarUrl,
    "isVerified": isVerified,
  };

  /// Converts this [UserModel] instance into a JSON map for API requests.
  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "avatar": avatarUrl,
    "isVerified": isVerified,
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

  @override
  String toString() => jsonEncode(toJson());
}
