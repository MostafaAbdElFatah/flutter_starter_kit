import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../assets/localization_keys.dart';
import '../../../errors/failure.dart';
import '../../../utils/log.dart';
import 'api_client.dart';
import 'api_endpoint.dart';

/// A concrete implementation of [ApiService] using the [Dio] package.
@LazySingleton(as: APIClient)
class DioAPIClient implements APIClient {
  final Dio _dio;

  /// Creates an instance of [DioApiService].
  ///
  /// - Parameter dio: A [Dio] instance for making HTTP requests.
  /// - Parameter connectivity: A [NetworkConnectivity] instance for  network connectivity.
  DioAPIClient(Dio dio) : _dio = dio;

  /// Sends an HTTP GET request to the given [path].
  ///
  /// [data] can be used to send a request body (if needed, although uncommon for GET).
  /// [headers] contains optional HTTP headers.
  /// [queryParameters] contains optional query parameters appended to the URL.
  /// Returns a [Response] from the server.
  @override
  Future<Model> get<Model>(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required APICallback parser,
  }) => request(
    RequestOptions(
      path: path,
      data: data,
      headers: headers,
      method: HttpMethod.get.rawValue,
      queryParameters: queryParameters,
    ),
    parser: parser,
  );

  /// Sends an HTTP POST request to the given [path].
  ///
  /// [data] contains the request body.
  /// [headers] contains optional HTTP headers.
  /// [queryParameters] contains optional query parameters.
  /// Returns a [Response] from the server.
  @override
  Future<Model> post<Model>(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required APICallback parser,
  }) => request(
    RequestOptions(
      path: path,
      data: data,
      headers: headers,
      method: HttpMethod.post.rawValue,
      queryParameters: queryParameters,
    ),
    parser: parser,
  );

  /// Sends an HTTP PUT request to the given [path].
  ///
  /// [data] contains the request body.
  /// [headers] contains optional HTTP headers.
  /// [queryParameters] contains optional query parameters.
  /// Returns a [Response] from the server.
  @override
  Future<Model> put<Model>(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required APICallback parser,
  }) => request(
    RequestOptions(
      path: path,
      data: data,
      headers: headers,
      method: HttpMethod.put.rawValue,
      queryParameters: queryParameters,
    ),
    parser: parser,
  );

  /// Sends an HTTP DELETE request to the given [path].
  ///
  /// [data] contains the request body (if supported by the server).
  /// [headers] contains optional HTTP headers.
  /// [queryParameters] contains optional query parameters.
  /// Returns a [Response] from the server.
  @override
  Future<Model> delete<Model>(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required APICallback parser,
  }) => request(
    RequestOptions(
      path: path,
      data: data,
      headers: headers,
      method: HttpMethod.delete.rawValue,
      queryParameters: queryParameters,
    ),
    parser: parser,
  );

  /// Sends an HTTP PATCH request to the given [path].
  ///
  /// [data] contains the request body.
  /// [headers] contains optional HTTP headers.
  /// [queryParameters] contains optional query parameters.
  /// Returns a [Response] from the server.
  @override
  Future<Model> patch<Model>(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required APICallback parser,
  }) => request(
    RequestOptions(
      path: path,
      data: data,
      headers: headers,
      method: HttpMethod.patch.rawValue,
      queryParameters: queryParameters,
    ),
    parser: parser,
  );

  /// Fetches data from a specific [APIEndpoint] and decodes it into [Model].
  ///
  /// [target] specifies the API endpoint.
  /// [parser] is a callback function used to decode the JSON response.
  /// [isFormData] indicates if the request body should be sent as `multipart/form-data`.
  /// Returns an instance of [Model].
  /// Throws [NetworkFailure] or decoding error on failure.
  @override
  Future<Model> fetch<Model>({
    bool isFormData = false,
    required APIEndpoint target,
    required APICallback parser,
  }) {
    final body = target.body;
    final queryParameters = target.queryParameters;
    final headers = target.headers ?? {};
    final diaHeaders = Map<String, String>.from(_dio.options.headers);
    headers.addAll(diaHeaders);

    // Remove null values from body and query parameters to prevent sending them in the request.
    body?.removeWhere((k, v) => v == null);
    queryParameters?.removeWhere((k, v) => v == null);
    final data = isFormData ? FormData.fromMap(body ?? {}) : body;

    return request(
      RequestOptions(
        data: data,
        headers: headers,
        path: target.path,
        method: target.method.rawValue,
        queryParameters: queryParameters,
        extra: {"endpoint": target},
      ),
      parser: parser,
    );
  }

  /// Sends a custom [RequestOptions] request and parses the response.
  ///
  /// [parser] is a callback function that converts a JSON map to the desired [Model].
  /// Returns an instance of [Model] decoded from the response.
  /// Throws a [NetworkFailure] or decoding error if the request fails or parsing fails.
  @override
  Future<Model> request<Model>(
    RequestOptions options, {
    required APICallback parser,
  }) async {
    try {
      // Make the HTTP request using Dio.
      final response = await _dio.fetch(options);

      // Parse the response data.
      //if (response.data is Map<String, dynamic>) {
      if (response.data is Map) {
        final data = Map<String, dynamic>.from(response.data as Map);
        //final data = response.data as Map<String, dynamic>;
        final statusCode = response.statusCode;
        final message = response.statusMessage;

        // Use the provided parser function to create the model instance.
        return parser(statusCode, message, data);
      } else {
        throw FailureType.invalidData;
      }
    } on DioException catch (error, stackTrace) {
      Log.error('[DIO API Exception]', error: error, stackTrace: stackTrace);
      // Handle specific Dio errors.
      if (error.type == DioExceptionType.badResponse &&
          error.response?.data != null &&
          error.response?.data is Map<String, dynamic>) {
        final errorData = error.response!.data as Map<String, dynamic>;
        final statusCode = error.response!.statusCode;
        final message =
            error.response!.statusMessage ?? LocalizationKeys.unknownError;
        // Attempt to create a model from the error response.
        final errorModel = parser(statusCode, message, errorData);
        return errorModel;
      }

      // For other types of Dio errors, throw a generic NetworkFailure.
      throw Failure.handle(error);
    } catch (error, stackTrace) {
      Log.error('[API Exception]', error: error, stackTrace: stackTrace);
      throw Failure.handle(error);
    }
  }
}
