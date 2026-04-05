import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart' hide Environment;

import '../../../env/env_data.dart';
import '../../../utils/app_locale.dart';
import '../storage/secure_storage_service.dart';
import 'api_endpoint.dart';

/// A Dio interceptor that adds the API key and authorization token to requests.
///
/// This interceptor is responsible for:
/// - Adding the `X-Api-Key` header from the application's configuration.
/// - Adding the `Authorization` header with a bearer token if one is available.

@lazySingleton
class APIInterceptor extends Interceptor {
  final AppConfig _appConfig;
  final AppLocaleState _appLocaleState;
  final SecureStorageService _secureStorage;

  /// Creates a new [APIInterceptor] instance.
  APIInterceptor({
    required AppConfig appConfig,
    required AppLocaleState appLocaleState,
    required SecureStorageService secureStorage,
  })  : _appLocaleState = appLocaleState,
        _secureStorage = secureStorage,
        _appConfig = appConfig;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add the current languageCode to the requests headers.
    options.headers['Accept-Language'] = _appLocaleState.current.languageCode;

    // Add the authorization token if it exists.
    final token = await _secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    final endpoint = options.extra['endpoint'] as APIEndpoint?;

    if (endpoint != null && endpoint.isCompositeUrl) {
      // BASE + ENDPOINT -> inject the current base URL from ConfigService
      options.baseUrl = _appConfig.baseUrl;
    }
    options.extra.remove('endpoint');
    super.onRequest(options, handler);
  }
}
