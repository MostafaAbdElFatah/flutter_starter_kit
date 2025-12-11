import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/features/auth/data/network/auth_endpoints.dart';
import 'package:flutter_starter_kit/features/environments_dev/data/datasources/environment_local_data_source.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/repositories/environment_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'package:flutter_starter_kit/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_starter_kit/features/auth/data/models/user.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/storage/storage_service.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/storage/secure_storage_service.dart';
import 'package:flutter_starter_kit/features/environments_dev/data/storage/environment_config_service.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/api_config.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/network/api_endpoint.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/network/api_client.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/network/network_connectivity.dart';
import 'package:flutter_starter_kit/core/utils/device_services.dart';
import 'package:flutter_starter_kit/core/utils/platform_checker.dart';
import 'package:flutter_starter_kit/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_starter_kit/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/register_usecase.dart';

@GenerateMocks([
  // Network
  Dio,
  APIConfig,
  APIEndpoint,
  Connectivity,
  RequestInterceptorHandler,
  UserModel,
  APIClient,
  NetworkConnectivity,


  // Storage
  FlutterSecureStorage,
  StorageService,
  SecureStorageService,
  EnvironmentConfigService,

  // DeviceServices
  IosUtsname,
  IosDeviceInfo,
  AndroidDeviceInfo,
  DeviceInfoPlugin,
  PlatformChecker,
  DeviceServices,

  // Auth
  AuthEndpoints,
  AuthLocalDataSource,
  AuthRemoteDataSource,
  AuthRepository,
  LoginUseCase,
  RegisterUseCase,
  LogoutUseCase,
  DeleteAccountUsecase,
  GetAuthenticatedUserUseCase,

  // EnvironmentDev
  EnvironmentLocalDataSource,
  EnvironmentRepository,
])
void main() {}