/// Enum representing HTTP methods.
enum HttpMethod { get, post, put, delete, patch, head, options }

/// Extension to get the raw string value for an [HttpMethod].
extension HttpMethodExtension on HttpMethod {
  /// The uppercase string representation of the HTTP method (e.g., 'GET').
  String get rawValue {
    switch (this) {
      case HttpMethod.get:
        return 'GET';
      case HttpMethod.post:
        return 'POST';
      case HttpMethod.put:
        return 'PUT';
      case HttpMethod.delete:
        return 'DELETE';
      case HttpMethod.patch:
        return 'PATCH';
      case HttpMethod.head:
        return 'HEAD';
      case HttpMethod.options:
        return 'OPTIONS';
    }
  }
}

/// Represents an API endpoint with all necessary details for an HTTP request.
///
/// This class is immutable and provides a structured way to define API endpoints.
/// It supports two types of endpoints:
/// 1.  **Composite**: A relative path that is combined with a base URL.
/// 2.  **Full URL**: A complete, absolute URL that is used as-is.
class APIEndpoint {
  /// The full, absolute URL for the request. Is `null` for composite endpoints.
  final String? fullUrl;

  /// The relative endpoint path. Is `null` for full URL endpoints.
  final String? _endpoint;

  /// The HTTP method for the request (e.g., GET, POST).
  final HttpMethod method;

  /// The body of the request, used for POST, PUT, and PATCH requests.
  final Map<String, dynamic>? body;

  /// The headers to be included in the request.
  final Map<String, dynamic>? headers;

  /// The query parameters to be appended to the URL.
  final Map<String, dynamic>? queryParameters;

  /// Creates a composite endpoint with a relative [endpoint] path.
  ///
  /// The [endpoint] will be combined with a base URL by the HTTP client.
  /// Creates a standard API endpoint with automatic versioning
  const APIEndpoint({
    required String endpoint,
    required this.method,
    String apiVersion = 'v1',
    this.queryParameters,
    this.headers,
    this.body,
  }) : fullUrl = null,
       _endpoint = '/api/$apiVersion$endpoint';

  /// Creates a custom API endpoint without automatic versioning
  const APIEndpoint.custom({
    required String endpoint,
    required this.method,
    this.queryParameters,
    this.headers,
    this.body,
  }) : fullUrl = null,
       _endpoint = endpoint;

  /// Creates an endpoint with a full, absolute URL.
  ///
  /// The [fullUrl] will be used directly by the HTTP client, ignoring any base URL.
  const APIEndpoint.fullUrl({
    required this.fullUrl,
    required this.method,
    this.queryParameters,
    this.headers,
    this.body,
  }) : _endpoint = null;

  /// Returns `true` if this endpoint uses a full, absolute URL.
  bool get isFullUrl => fullUrl != null;

  /// Returns `true` if this endpoint uses a relative path to be combined with a base URL.
  bool get isCompositeUrl => _endpoint != null;

  /// Returns the configured URL part, either the full URL or the relative endpoint path.
  ///
  /// The constructors guarantee that this will not throw an error, as either
  /// [fullUrl] or [endpoint] will be non-null.
  String get path => isFullUrl ? fullUrl! : _endpoint!;
}
