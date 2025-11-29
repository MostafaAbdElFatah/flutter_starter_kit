import '../constants/app_constants.dart';

enum HttpMethod { get, post, put, delete, patch }

/// Represents an API endpoint with necessary details for making HTTP requests.
abstract class ApiEndpoint {
  // Private field to hold the potentially nullable baseUrl.
  final String? _baseUrl;

  /// Constructor accepts an optional baseUrl.
  ApiEndpoint({String? baseUrl}) : _baseUrl = baseUrl;

  /// If [_baseUrl] is null, this getter returns the default value.
  /// Note: In our architecture, the ApiClient will typically override this 
  /// with the ConfigService's base URL if this returns the default placeholder.
  String get baseUrl => _baseUrl ?? AppConstants.apiBaseUrl;

  /// The full URL for the endpoint, computed by concatenating the baseUrl and the path.
  String get endpoint => '$baseUrl$path';

  /// The path appended to the base URL.
  String get path;

  /// The HTTP method used in the request.
  HttpMethod get method;

  /// The parameters included in the request body.
  Map<String, dynamic>? get body => null;

  /// The headers included in the request.
  Map<String, dynamic>? get headers => null;

  /// The query parameters included in the request.
  Map<String, dynamic>? get queryParameters => null;
}
