import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_starter_kit/core/infrastructure/data/storage/storage_service.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/storage/secure_storage_service.dart';
import 'package:flutter_starter_kit/features/environments_dev/data/storage/environment_config_service.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/api_config.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/network/api_endpoint.dart';

@GenerateMocks([

  // Network
  Dio,
  APIConfig,
  APIEndpoint,
  Connectivity,
  RequestInterceptorHandler,


  // Storage
  FlutterSecureStorage,
  StorageService,
  SecureStorageService,
  EnvironmentConfigService,
])
void main() {}
