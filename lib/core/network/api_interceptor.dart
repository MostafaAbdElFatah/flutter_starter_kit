import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../features/environments_dev/data/datasources/storage/env_config_service.dart';
import '../storage/secure_storage_service.dart';
import '../utils/log.dart';
import 'api_endpoint.dart';

/// A Dio interceptor that adds the API key and authorization token to requests.
///
/// This interceptor is responsible for:
/// - Adding the `X-Api-Key` header from the application's configuration.
/// - Adding the `Authorization` header with a bearer token if one is available.

@lazySingleton
class APIInterceptor extends Interceptor {
  final EnvConfigService _configService;
  final SecureStorageService _secureStorage;

  /// Creates a new [APIInterceptor] instance.
  APIInterceptor({
    required EnvConfigService configService,
    required SecureStorageService secureStorage,
  }) : _configService = configService,
       _secureStorage = secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final appConfig = _configService.currentApiConfig;

    // Add the API key to the request headers.
    options.headers['X-Api-Key'] = appConfig.apiKey;

    // Add the authorization token if it exists.
    final token = await _secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    final endpoint = options.extra['endpoint'] as APIEndpoint?;
    Log.debug("[DEBUG] options ${options.toString()}");
    Log.debug("[DEBUG] endpoint $endpoint");
    Log.debug("[DEBUG] path ${endpoint?.path}");
    Log.debug("[DEBUG] fullUrl ${endpoint?.fullUrl}");

    if (endpoint != null && endpoint.isCompositeUrl) {
      // BASE + ENDPOINT -> inject the current base URL from ConfigService
      options.baseUrl = _configService.currentApiConfig.baseUrl;
      options.extra.remove('endpoint');
      Log.debug("[DEBUG] options ${options.toString()}");
    }

    super.onRequest(options, handler);
  }
}
