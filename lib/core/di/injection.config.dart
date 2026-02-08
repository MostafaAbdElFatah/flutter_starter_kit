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
import '../../features/environments_dev/data/datasources/environment_local_data_source.dart'
    as _i766;
import '../../features/environments_dev/data/repositories/environment_repository_impl.dart'
    as _i305;
import '../../features/environments_dev/data/storage/environment_config_service.dart'
    as _i109;
import '../../features/environments_dev/domain/repositories/environment_repository.dart'
    as _i365;
import '../../features/environments_dev/domain/usecases/developer_login_usecase.dart'
    as _i668;
import '../../features/environments_dev/domain/usecases/get_current_config_use_case.dart'
    as _i223;
import '../../features/environments_dev/domain/usecases/get_current_environment_use_case.dart'
    as _i272;
import '../../features/environments_dev/domain/usecases/get_environment_config_use_case.dart'
    as _i572;
import '../../features/environments_dev/domain/usecases/update_environment_configuration_use_case.dart'
    as _i4;
import '../../features/environments_dev/presentation/cubit/environment_cubit.dart'
    as _i266;
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
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart'
    as _i807;
import '../../features/splash/presentation/cubit/splash_cubit.dart' as _i125;
import '../infrastructure/data/network/api_client.dart' as _i456;
import '../infrastructure/data/network/api_interceptor.dart' as _i50;
import '../infrastructure/data/network/dio_api_client.dart' as _i1035;
import '../infrastructure/data/network/dio_module.dart' as _i183;
import '../infrastructure/data/network/network_connectivity.dart' as _i498;
import '../infrastructure/data/storage/hive_storage_service.dart' as _i581;
import '../infrastructure/data/storage/secure_storage_service.dart' as _i224;
import '../infrastructure/data/storage/storage_service.dart' as _i419;
import '../utils/app_locale.dart' as _i845;
import '../utils/device_services.dart' as _i440;
import '../utils/platform_checker.dart' as _i48;
import 'injection.dart' as _i464;

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
    gh.lazySingleton<_i845.AppLocaleState>(() => _i845.AppLocaleState());
    gh.lazySingleton<_i48.PlatformChecker>(() => const _i48.PlatformChecker());
    gh.lazySingleton<_i802.AuthEndpoints>(() => _i802.AuthEndpoints());
    gh.lazySingleton<_i224.SecureStorageService>(
      () => _i224.SecureStorageServiceImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i498.NetworkConnectivity>(
      () => _i498.NetworkConnectivityImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i440.DeviceServices>(
      () => _i440.DeviceServices(
        platformChecker: gh<_i48.PlatformChecker>(),
        deviceInfoPlugin: gh<_i833.DeviceInfoPlugin>(),
      ),
    );
    await gh.factoryAsync<_i419.StorageService>(() {
      final i = _i581.HiveStorageService(gh<_i224.SecureStorageService>());
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.factory<_i109.EnvironmentConfigService>(
      () => _i109.EnvironmentConfigStorageService(
        storageService: gh<_i419.StorageService>(),
      ),
    );
    gh.lazySingleton<_i50.APIInterceptor>(
      () => _i50.APIInterceptor(
        appLocaleState: gh<_i845.AppLocaleState>(),
        secureStorage: gh<_i224.SecureStorageService>(),
        environmentConfigService: gh<_i109.EnvironmentConfigService>(),
      ),
    );
    gh.lazySingleton<_i766.EnvironmentLocalDataSource>(
      () => _i766.EnvironmentLocalDataSourceImpl(
        environmentConfigService: gh<_i109.EnvironmentConfigService>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(gh<_i50.APIInterceptor>()),
    );
    gh.lazySingleton<_i992.AuthLocalDataSource>(
      () => _i992.AuthLocalDataSourceImpl(
        storageService: gh<_i419.StorageService>(),
        secureStorageService: gh<_i224.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i804.OnboardingLocalDataSource>(
      () => _i804.OnboardingLocalDataSourceImpl(gh<_i419.StorageService>()),
    );
    gh.lazySingleton<_i456.APIClient>(
      () => _i1035.DioAPIClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSourceImpl(
        apiClient: gh<_i456.APIClient>(),
        connectivity: gh<_i498.NetworkConnectivity>(),
        authEndpoints: gh<_i802.AuthEndpoints>(),
      ),
    );
    gh.lazySingleton<_i430.OnboardingRepository>(
      () =>
          _i452.OnboardingRepositoryImpl(gh<_i804.OnboardingLocalDataSource>()),
    );
    gh.lazySingleton<_i365.EnvironmentRepository>(
      () => _i305.EnvironmentRepositoryImpl(
        gh<_i766.EnvironmentLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i573.AuthRepositoryImpl(
        deviceServices: gh<_i440.DeviceServices>(),
        localDataSource: gh<_i992.AuthLocalDataSource>(),
        remoteDataSource: gh<_i161.AuthRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i462.CheckOnboardingStatusUseCase>(
      () =>
          _i462.CheckOnboardingStatusUseCase(gh<_i430.OnboardingRepository>()),
    );
    gh.lazySingleton<_i360.CompleteOnboardingUseCase>(
      () => _i360.CompleteOnboardingUseCase(gh<_i430.OnboardingRepository>()),
    );
    gh.lazySingleton<_i668.DeveloperLoginUseCase>(
      () => _i668.DeveloperLoginUseCase(gh<_i365.EnvironmentRepository>()),
    );
    gh.lazySingleton<_i223.GetCurrentApiConfigUseCase>(
      () => _i223.GetCurrentApiConfigUseCase(gh<_i365.EnvironmentRepository>()),
    );
    gh.lazySingleton<_i272.GetCurrentEnvironmentUseCase>(
      () =>
          _i272.GetCurrentEnvironmentUseCase(gh<_i365.EnvironmentRepository>()),
    );
    gh.lazySingleton<_i572.GetEnvironmentConfigUseCase>(
      () =>
          _i572.GetEnvironmentConfigUseCase(gh<_i365.EnvironmentRepository>()),
    );
    gh.lazySingleton<_i4.UpdateEnvironmentConfigUseCase>(
      () =>
          _i4.UpdateEnvironmentConfigUseCase(gh<_i365.EnvironmentRepository>()),
    );
    gh.lazySingleton<_i914.DeleteAccountUseCase>(
      () => _i914.DeleteAccountUseCase(gh<_i787.AuthRepository>()),
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
    gh.factory<_i807.OnboardingCubit>(
      () => _i807.OnboardingCubit(gh<_i360.CompleteOnboardingUseCase>()),
    );
    gh.factory<_i125.SplashCubit>(
      () => _i125.SplashCubit(
        gh<_i48.IsLoggedInUseCase>(),
        gh<_i462.CheckOnboardingStatusUseCase>(),
      ),
    );
    gh.factory<_i266.EnvironmentCubit>(
      () => _i266.EnvironmentCubit(
        developerLoginUseCase: gh<_i668.DeveloperLoginUseCase>(),
        getCurrentApiConfigUseCase: gh<_i223.GetCurrentApiConfigUseCase>(),
        getEnvironmentConfigUseCase: gh<_i572.GetEnvironmentConfigUseCase>(),
        getCurrentEnvironmentUseCase: gh<_i272.GetCurrentEnvironmentUseCase>(),
        updateEnvironmentConfigUseCase:
            gh<_i4.UpdateEnvironmentConfigUseCase>(),
      ),
    );
    gh.factory<_i117.AuthCubit>(
      () => _i117.AuthCubit(
        loginUseCase: gh<_i188.LoginUseCase>(),
        registerUseCase: gh<_i941.RegisterUseCase>(),
        logoutUseCase: gh<_i48.LogoutUseCase>(),
        isLoggedInUseCase: gh<_i48.IsLoggedInUseCase>(),
        deleteAccountUseCase: gh<_i914.DeleteAccountUseCase>(),
        getAuthenticatedUserUseCase: gh<_i435.GetAuthenticatedUserUseCase>(),
      ),
    );
    return this;
  }
}

class _$InjectionModule extends _i464.InjectionModule {}

class _$NetworkModule extends _i183.NetworkModule {}
