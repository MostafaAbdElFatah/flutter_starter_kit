import 'package:dio/dio.dart';
import 'api_endpoint.dart';

typedef APICallback<T> =
    T Function(int? statusCode, String? message, Map<String, dynamic> json);

/// An abstract base class that defines the interface for an API client.
///
/// This class outlines the core HTTP methods and provides a generic
/// way to fetch and decode API responses into model types.
/// Subclasses should implement the HTTP methods (`get`, `post`, `put`, `delete`, `patch`)
/// and the generic `request` method.
abstract class APIClient {
  /// Sends an HTTP GET request to the given [path].
  ///
  /// [data] can be used to send a request body (if needed, although uncommon for GET).
  /// [headers] contains optional HTTP headers.
  /// [queryParameters] contains optional query parameters appended to the URL.
  /// Returns a [Response] from the server.
  Future<Model> get<Model>(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required APICallback fromJson,
  });

  /// Sends an HTTP POST request to the given [path].
  ///
  /// [data] contains the request body.
  /// [headers] contains optional HTTP headers.
  /// [queryParameters] contains optional query parameters.
  /// Returns a [Response] from the server.
  Future<Model> post<Model>(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required APICallback fromJson,
  });

  /// Sends an HTTP PUT request to the given [path].
  ///
  /// [data] contains the request body.
  /// [headers] contains optional HTTP headers.
  /// [queryParameters] contains optional query parameters.
  /// Returns a [Response] from the server.
  Future<Model> put<Model>(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required APICallback fromJson,
  });

  /// Sends an HTTP DELETE request to the given [path].
  ///
  /// [data] contains the request body (if supported by the server).
  /// [headers] contains optional HTTP headers.
  /// [queryParameters] contains optional query parameters.
  /// Returns a [Response] from the server.
  Future<Model> delete<Model>(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required APICallback fromJson,
  });

  /// Sends an HTTP PATCH request to the given [path].
  ///
  /// [data] contains the request body.
  /// [headers] contains optional HTTP headers.
  /// [queryParameters] contains optional query parameters.
  /// Returns a [Response] from the server.
  Future<Model> patch<Model>(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required APICallback fromJson,
  });

  /// Sends a custom [RequestOptions] request and parses the response.
  ///
  /// [fromJson] is a callback function that converts a JSON map to the desired [Model].
  /// Returns an instance of [Model] decoded from the response.
  /// Throws a [NetworkFailure] or decoding error if the request fails or parsing fails.
  Future<Model> request<Model>(
    RequestOptions options, {
    required APICallback fromJson,
  });

  /// Fetches data from a specific [APIEndpoint] and decodes it into [Model].
  ///
  /// [target] specifies the API endpoint.
  /// [fromJson] is a callback function used to decode the JSON response.
  /// [isFormData] indicates if the request body should be sent as `multipart/form-data`.
  /// Returns an instance of [Model].
  /// Throws [NetworkFailure] or decoding error on failure.
  Future<Model> fetch<Model>({
    bool isFormData = false,
    required APIEndpoint target,
    required APICallback fromJson,
  });
}
