import 'package:equatable/equatable.dart';

/// Represents a user entity within the domain layer.
///
/// This class defines the core properties of a user and is designed to be
/// immutable. It uses [Equatable] to support value-based equality.
class User extends Equatable {
  /// Creates an instance of [User].
  const User({
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

  /// Creates a copy of this [User] instance with the given fields
  /// replaced with new values.
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  List<Object?> get props => [id, email, name, avatarUrl, isVerified];
}
