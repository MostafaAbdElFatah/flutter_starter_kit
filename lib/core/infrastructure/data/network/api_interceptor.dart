import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../features/environments_dev/storage/environment_config_service.dart';
import '../storage/secure_storage_service.dart';
import 'api_endpoint.dart';

/// A Dio interceptor that adds the API key and authorization token to requests.
///
/// This interceptor is responsible for:
/// - Adding the `X-Api-Key` header from the application's configuration.
/// - Adding the `Authorization` header with a bearer token if one is available.

@lazySingleton
class APIInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final EnvironmentConfigService _environmentConfigService;

  /// Creates a new [APIInterceptor] instance.
  APIInterceptor({
    required SecureStorageService secureStorage,
    required EnvironmentConfigService environmentConfigService,
  }) : _secureStorage = secureStorage,
       _environmentConfigService = environmentConfigService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final appConfig = _environmentConfigService.currentApiConfig;

    // Add the API key to the request headers.
    options.headers['X-Api-Key'] = appConfig.apiKey;

    // Add the authorization token if it exists.
    final token = await _secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    final endpoint = options.extra['endpoint'] as APIEndpoint?;

    if (endpoint != null && endpoint.isCompositeUrl) {
      // BASE + ENDPOINT -> inject the current base URL from ConfigService
      options.baseUrl = _environmentConfigService.currentApiConfig.baseUrl;
      options.extra.remove('endpoint');
    }

    super.onRequest(options, handler);
  }
}
