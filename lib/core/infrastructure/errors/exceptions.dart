part of 'failure.dart';

/// An exception for unexpected errors that are not covered by other exception types.
///
/// This can be used as a fallback for unknown errors.
class UnexpectedException extends Failure {
  const UnexpectedException(super.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

/// An exception that occurs when there is a problem with the server.
///
/// This is thrown when the server returns a non-200 status code, or if
/// there's an issue with the network connection during a server request.
class ServerException extends Failure {
  const ServerException(super.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

/// An exception that occurs when there is a problem with the local cache.
///
/// This is thrown when there is an issue reading from or writing to the
/// local cache (e.g., Hive).
class CacheException extends Failure {
  const CacheException(super.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}
