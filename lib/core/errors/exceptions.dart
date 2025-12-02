export 'failure.dart';

import 'package:equatable/equatable.dart';

/// An exception that occurs when there is a problem with the server.
///
/// This is thrown when the server returns a non-200 status code, or if
/// there's an issue with the network connection during a server request.
class ServerException extends Equatable implements Exception {
  final String message;
  const ServerException(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => "ServerException: $message";
}

/// An exception for unexpected errors that are not covered by other exception types.
///
/// This can be used as a fallback for unknown errors.
class UnexpectedException extends Equatable implements Exception {
  final String message;
  const UnexpectedException(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => "UnexpectedException: $message";
}

/// An exception that occurs when there is a problem with the local cache.
///
/// This is thrown when there is an issue reading from or writing to the
/// local cache (e.g., Hive).
class CacheException extends Equatable implements Exception {
  final String message;
  const CacheException(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => "CacheException: $message";
}
