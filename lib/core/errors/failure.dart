import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';

import '../assets/localization_keys.dart';
part 'exceptions.dart';

abstract class Failure extends Equatable implements Exception {
  final String message;
  const Failure([this.message = '']);

  // Returning true so that Equatable prints a string representation if needed.
  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [this];

  /// Returns a localized string representation of the failure for display.
  @override
  String toString() => "Exception: ${message.tr()}";

  /// Handles a dynamic error and converts it into a standardized [Exception].
  ///
  /// If the error is a [DioException], it is processed by [_handleDioError].
  /// If it's another type of [Exception], it's returned as is.
  /// Non-exception throwables are wrapped in an [UnexpectedException].
  static Exception handle(dynamic error) {
    switch (error) {
      case Failure failure:
        return failure;
      case DioException dioException:
        return _handleDioError(dioException);
      default:
        return UnexpectedException(error.toString());
    }
  }

  /// Maps a [DioException] to a specific [FailureType] type or a [ServerException].
  static Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return FailureType.connectTimeout;
      case DioExceptionType.sendTimeout:
        return FailureType.sendTimeout;
      case DioExceptionType.receiveTimeout:
        return FailureType.receiveTimeout;
      case DioExceptionType.connectionError:
        return FailureType.noConnectionError;
      case DioExceptionType.cancel:
        return FailureType.cancel;
      case DioExceptionType.badCertificate:
        return FailureType.badRequest;
      case DioExceptionType.unknown:
        return FailureType.errorOccurred;
      case DioExceptionType.badResponse:
        // For bad responses (e.g., 4xx, 5xx), we create a ServerException.
        // We attempt to extract a meaningful message from the server's response body.
        // If not available, we fall back to Dio's error message, the status message,
        // or a generic "unknown error" key.
        final messageError =
            error.response?.data?["message"] ??
            error.message ??
            error.response?.statusMessage ??
            LocalizationKeys.unknownError;
        return ServerException(messageError);
    }
  }
}

/// An enum representing the different types of failures that can occur within the application.
///
/// This enum centralizes error handling by mapping various exceptions, especially
/// [DioException], to a set of predefined failure types. Each failure type holds
/// a localization key for its corresponding error message.
///
/// By implementing [Exception], instances of [FailureType] can be thrown and caught like
/// standard exceptions. The implementation of [Equatable] allows for value-based comparison.
enum FailureType implements Equatable, Failure {
  /// Represents a 422 Unprocessable Content error from the server.
  unprocessableContent(ErrorKeys.invalidDataError),

  /// Represents a 204 No Content success status, which may be treated as a
  /// failure when content was expected.
  noContent(ErrorKeys.noContent),

  /// Represents a 400 Bad Request error.
  badRequest(ErrorKeys.badRequestError),

  /// Represents a 403 Forbidden error, indicating the user lacks permission.
  forbidden(ErrorKeys.forbiddenError),

  /// Represents a 401 Unauthorized error, indicating missing or invalid authentication.
  unauthorized(ErrorKeys.unauthorizedError),

  /// Represents a 404 Not Found error for a requested resource.
  notFound(ErrorKeys.notFoundError),

  /// Represents a failure due to invalid data format.
  invalidData(ErrorKeys.invalidDataError),

  /// Represents a 5xx Internal Server Error.
  internetServerError(ErrorKeys.internalServerError),

  /// Represents a user-cancelled request.
  cancel(ErrorKeys.cancelError),

  /// Represents a connection timeout error.
  connectTimeout(ErrorKeys.timeoutError),

  /// Represents a receive timeout error while waiting for data.
  receiveTimeout(ErrorKeys.timeoutError),

  /// Represents a send timeout error while sending data.
  sendTimeout(ErrorKeys.timeoutError),

  /// Represents a failure related to local data caching.
  cacheError(ErrorKeys.cacheError),

  /// Represents a 409 Conflict error, e.g., creating a resource that already exists.
  conflict(ErrorKeys.conflictError),

  /// Represents a failure due to a device connection issue (e.g., DNS, TCP handshake).
  noConnectionError(ErrorKeys.noConnectionError),

  /// Represents a failure due to no internet connectivity.
  noInternetConnection(ErrorKeys.noInternetError),

  /// Represents an unknown or unexpected error.
  errorOccurred(ErrorKeys.unknownError);

  /// The localization key for the user-facing error message.
  @override
  final String message;

  /// Associates a failure type with its corresponding message key.
  const FailureType(this.message);

  // Returning true so that Equatable prints a string representation if needed.
  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [this];

  /// Returns a localized string representation of the failure for display.
  @override
  String toString() => "Failure: ${message.tr()}";
}
