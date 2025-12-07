import 'package:equatable/equatable.dart';

/// Represents the credentials required for developer authentication.
///
/// This entity holds the username and password for developer-only access points.
class DeveloperCredentials extends Equatable {
  final String username;
  final String password;

  const DeveloperCredentials({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}
