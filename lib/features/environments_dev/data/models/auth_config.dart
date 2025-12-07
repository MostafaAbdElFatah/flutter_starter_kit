import 'package:equatable/equatable.dart';

class AuthConfig extends Equatable {

  /// The username for developer login.
  final String devUsername;

  /// The password for developer login.
  final String devPassword;

  /// Creates a new [AuthConfig] instance.
  const AuthConfig({
    required this.devUsername,
    required this.devPassword,
  });

  @override
  List<Object?> get props => [devUsername, devPassword];
}