import 'package:equatable/equatable.dart';

class AuthConfig extends Equatable {

  /// The username for developer login.
  final String username;

  /// The password for developer login.
  final String password;

  /// Creates a new [AuthConfig] instance.
  const AuthConfig({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}