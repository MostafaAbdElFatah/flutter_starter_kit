import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../storage/storage_service.dart';
import '../config/config_service.dart';
import 'api_endpoint.dart';

class ApiClient {
  final Dio _dio;
  final StorageService _storageService;
  final ConfigService _configService;

  ApiClient(this._storageService, this._configService)
      : _dio = Dio(
          BaseOptions(
            baseUrl: _configService.currentConfig.apiBaseUrl,
            connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
            receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Dynamic Base URL
          options.baseUrl = _configService.currentConfig.apiBaseUrl;

          final token = await _storageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response> request(ApiEndpoint endpoint) async {
    // If endpoint has a specific base URL (that isn't the default placeholder), use it.
    // Otherwise, the interceptor will set the dynamic base URL from ConfigService.
    // However, since we are using an interceptor for dynamic base URL, we need to be careful.
    // The interceptor sets options.baseUrl.
    // If we pass a full URL to dio.request, it overrides baseUrl.
    
    String path = endpoint.path;

    final options = Options(
      method: endpoint.method.name.toUpperCase(),
      headers: endpoint.headers,
    );

    return await _dio.request(
      path,
      data: endpoint.body,
      queryParameters: endpoint.queryParameters,
      options: options,
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) async {
    return await _dio.delete(path, data: data);
  }
}
