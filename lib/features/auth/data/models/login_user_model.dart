import 'package:equatable/equatable.dart';

import 'user_model.dart';


/// Represents the user and token data returned upon successful authentication.
///
/// This class is designed to be immutable and supports value-based equality.
class LoginUserModel extends Equatable {
  const LoginUserModel({required this.user, required this.token});

  /// The authenticated user's profile information.
  final UserModel user;

  /// The authentication token (e.g., JWT) for accessing protected resources.
  final String token;

  /// Creates a copy of this [LoginUserModel] but with the given fields replaced with the new values.
  LoginUserModel copyWith({UserModel? user, String? token}) {
    return LoginUserModel(user: user ?? this.user, token: token ?? this.token);
  }

  /// Creates a [LoginUserModel] from a JSON map.
  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      user: UserModel.fromJson(json["user"]),
      token: json["token"] ?? "N/A",
    );
  }

  /// Converts this [LoginUserModel] instance into a JSON map.
  Map<String, dynamic> toJson() => {"user": user.toJson(), "token": token};

  @override
  List<Object?> get props => [user, token];
}