import 'package:equatable/equatable.dart';

import '../../../../../core/infrastructure/data/models/api_response.dart';
import '../user.dart';

/// Represents the API response for a successful login or registration.
///
/// This class extends [APIResponse] and includes the [LoginUser] data,
/// which contains the user profile and an authentication token. It is designed
/// to be immutable and supports value-based equality.
final class LoginResponse extends APIResponse {
  const LoginResponse({
    required this.data,
    required super.links,
    required super.meta,
    required super.errors,
    required super.message,
    required super.statusCode,
  });

  /// The data payload of the response, containing the user and token.
  final LoginUser? data;

  /// Creates a [LoginResponse] from a JSON map.
  factory LoginResponse.fromJson(
    int? statusCode,
    String? message,
    Map<String, dynamic> json,
  ) =>
      LoginResponse(
        errors: json["errors"],
        statusCode: statusCode ?? 0,
        message: json["message"] ?? message,
        data: json["data"] == null ? null : LoginUser.fromJson(json["data"]),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  /// Creates a copy of this [LoginResponse] but with the given fields replaced with the new values.
  @override
  LoginResponse copyWith({
    LoginUser? data,
    Links? links,
    Meta? meta,
    int? statusCode,
    String? message,
    Map<String, dynamic>? errors,
  }) =>
      LoginResponse(
        data: data ?? this.data,
        links: links ?? this.links,
        meta: meta ?? this.meta,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        errors: errors ?? this.errors,
      );

  @override
  List<Object?> get props => [...super.props, data];
}

/// Represents the user and token data returned upon successful authentication.
///
/// This class is designed to be immutable and supports value-based equality.
final class LoginUser extends Equatable {
  const LoginUser({required this.user, required this.token});

  /// The authenticated user's profile information.
  final UserModel user;

  /// The authentication token (e.g., JWT) for accessing protected resources.
  final String token;

  /// Creates a copy of this [LoginUser] but with the given fields replaced with the new values.
  LoginUser copyWith({UserModel? user, String? token}) {
    return LoginUser(user: user ?? this.user, token: token ?? this.token);
  }

  /// Creates a [LoginUser] from a JSON map.
  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      user: UserModel.fromJson(json["user"]),
      token: json["token"],
    );
  }

  /// Converts this [LoginUser] instance into a JSON map.
  Map<String, dynamic> toJson() => {"user": user.toJson(), "token": token};

  @override
  List<Object?> get props => [user, token];
}
