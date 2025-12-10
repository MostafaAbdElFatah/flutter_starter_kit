import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';

import '../assets/localization_keys.dart';
part 'failure.dart';


abstract class AppException extends Equatable implements  Exception {
  final String message;
  const AppException([this.message = '']);

  // Returning true so that Equatable prints a string representation if needed.
  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [this];

  /// Returns a localized string representation of the failure for display.
  @override
  String toString() => "Exception: ${message.tr()}";

}

/// An exception for unexpected errors that are not covered by other exception types.
///
/// This can be used as a fallback for unknown errors.
class UnexpectedException extends AppException {
  const UnexpectedException(super.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => "UnexpectedException: $message";
}

/// An exception that occurs when there is a problem with the server.
///
/// This is thrown when the server returns a non-200 status code, or if
/// there's an issue with the network connection during a server request.
class ServerException extends AppException {
  const ServerException(super.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => "ServerException: $message";
}

/// An exception that occurs when there is a problem with the local cache.
///
/// This is thrown when there is an issue reading from or writing to the
/// local cache (e.g., Hive).
class CacheException extends AppException {
  const CacheException(super.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => "CacheException: $message";
}
