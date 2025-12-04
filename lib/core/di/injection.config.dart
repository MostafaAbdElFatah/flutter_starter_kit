// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/network/auth_endpoints.dart' as _i802;
import '../../features/auth/data/repositories/auth_repository.dart' as _i573;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/delete_account_usecase.dart'
    as _i914;
import '../../features/auth/domain/usecases/get_authenticated_user_usecase.dart'
    as _i435;
import '../../features/auth/domain/usecases/is_logged_in_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/register_usecase.dart' as _i941;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart'
    as _i804;
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i452;
import '../../features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i430;
import '../../features/onboarding/domain/usecases/check_onboarding_status_usecase.dart'
    as _i462;
import '../../features/onboarding/domain/usecases/complete_onboarding_usecase.dart'
    as _i360;
import '../../features/onboarding/presentation/bloc/onboarding_cubit.dart'
    as _i153;
import '../../features/splash/presentation/bloc/splash_cubit.dart' as _i955;
import '../config/config_service.dart' as _i628;
import '../network/api_client.dart' as _i557;
import '../network/api_interceptor.dart' as _i724;
import '../network/dio_api_client.dart' as _i167;
import '../network/dio_module.dart' as _i614;
import '../network/network_connectivity.dart' as _i620;
import '../storage/hive_storage_service.dart' as _i131;
import '../storage/secure_storage_service.dart' as _i666;
import '../storage/storage_service.dart' as _i865;
import '../utils/device_services.dart' as _i440;
import 'di.dart' as _i913;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectionModule = _$InjectionModule();
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i895.Connectivity>(() => injectionModule.connectivity);
    gh.lazySingleton<_i833.DeviceInfoPlugin>(
      () => injectionModule.deviceInfoPlugin,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => injectionModule.flutterSecureStorage,
    );
    gh.lazySingleton<_i802.AuthEndpoints>(() => _i802.AuthEndpoints());
    gh.lazySingleton<_i440.DeviceServices>(
      () => _i440.DeviceServices(gh<_i833.DeviceInfoPlugin>()),
    );
    gh.lazySingleton<_i620.NetworkConnectivity>(
      () => _i620.NetworkConnectivityImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i666.SecureStorageService>(
      () => _i666.SecureStorageServiceImpl(gh<_i558.FlutterSecureStorage>()),
    );
    await gh.factoryAsync<_i865.StorageService>(() {
      final i = _i131.HiveStorageService(gh<_i666.SecureStorageService>());
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.factory<_i628.ConfigService>(
      () => _i628.ConfigService(storageService: gh<_i865.StorageService>()),
    );
    gh.lazySingleton<_i724.APIInterceptor>(
      () => _i724.APIInterceptor(
        configService: gh<_i628.ConfigService>(),
        secureStorage: gh<_i666.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i992.AuthLocalDataSource>(
      () => _i992.AuthLocalDataSourceImpl(
        storageService: gh<_i865.StorageService>(),
        secureStorageService: gh<_i666.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(gh<_i724.APIInterceptor>()),
    );
    gh.lazySingleton<_i804.OnboardingLocalDataSource>(
      () => _i804.OnboardingLocalDataSourceImpl(gh<_i865.StorageService>()),
    );
    gh.lazySingleton<_i557.APIClient>(
      () => _i167.DioAPIClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i430.OnboardingRepository>(
      () =>
          _i452.OnboardingRepositoryImpl(gh<_i804.OnboardingLocalDataSource>()),
    );
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSourceImpl(
        apiClient: gh<_i557.APIClient>(),
        connectivity: gh<_i620.NetworkConnectivity>(),
        authEndpoints: gh<_i802.AuthEndpoints>(),
      ),
    );
    gh.lazySingleton<_i462.CheckOnboardingStatusUseCase>(
      () =>
          _i462.CheckOnboardingStatusUseCase(gh<_i430.OnboardingRepository>()),
    );
    gh.lazySingleton<_i360.CompleteOnboardingUseCase>(
      () => _i360.CompleteOnboardingUseCase(gh<_i430.OnboardingRepository>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i573.AuthRepositoryImpl(
        deviceServices: gh<_i440.DeviceServices>(),
        localDataSource: gh<_i992.AuthLocalDataSource>(),
        remoteDataSource: gh<_i161.AuthRemoteDataSource>(),
      ),
    );
    gh.factory<_i153.OnboardingCubit>(
      () => _i153.OnboardingCubit(gh<_i360.CompleteOnboardingUseCase>()),
    );
    gh.lazySingleton<_i914.DeleteAccountUsecase>(
      () => _i914.DeleteAccountUsecase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i435.GetAuthenticatedUserUseCase>(
      () => _i435.GetAuthenticatedUserUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i48.IsLoggedInUseCase>(
      () => _i48.IsLoggedInUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i48.LogoutUseCase>(
      () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i941.RegisterUseCase>(
      () => _i941.RegisterUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i117.AuthCubit>(
      () => _i117.AuthCubitImpl(
        loginUseCase: gh<_i188.LoginUseCase>(),
        registerUseCase: gh<_i941.RegisterUseCase>(),
        logoutUseCase: gh<_i48.LogoutUseCase>(),
        isLoggedInUseCase: gh<_i48.IsLoggedInUseCase>(),
        deleteAccountUsecase: gh<_i914.DeleteAccountUsecase>(),
        getAuthenticatedUserUseCase: gh<_i435.GetAuthenticatedUserUseCase>(),
      ),
    );
    gh.factory<_i955.SplashCubit>(
      () => _i955.SplashCubit(
        gh<_i48.IsLoggedInUseCase>(),
        gh<_i462.CheckOnboardingStatusUseCase>(),
      ),
    );
    return this;
  }
}

class _$InjectionModule extends _i913.InjectionModule {}

class _$NetworkModule extends _i614.NetworkModule {}
