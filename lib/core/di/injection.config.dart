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

import '../../features/auth/data/data_sources/auth_local_datasource.dart'
    as _i498;
import '../../features/auth/data/data_sources/auth_remote_datasource.dart'
    as _i586;
import '../../features/auth/data/models/auth_endpoints.dart' as _i990;
import '../../features/auth/data/repository/auth_repository.dart' as _i104;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/use_cases/delete_account_usecase.dart'
    as _i367;
import '../../features/auth/domain/use_cases/get_authenticated_user_usecase.dart'
    as _i242;
import '../../features/auth/domain/use_cases/is_logged_in_usecase.dart'
    as _i391;
import '../../features/auth/domain/use_cases/login_usecase.dart' as _i1012;
import '../../features/auth/domain/use_cases/logout_usecase.dart' as _i844;
import '../../features/auth/domain/use_cases/register_usecase.dart' as _i957;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/environments_dev/data/data_sources/environment_local_data_source.dart'
    as _i1;
import '../../features/environments_dev/data/repository/environment_repository_impl.dart'
    as _i156;
import '../../features/environments_dev/data/storage/environment_config_service.dart'
    as _i109;
import '../../features/environments_dev/domain/repository/environment_repository.dart'
    as _i310;
import '../../features/environments_dev/domain/use_cases/developer_login_usecase.dart'
    as _i496;
import '../../features/environments_dev/domain/use_cases/get_current_config_use_case.dart'
    as _i422;
import '../../features/environments_dev/domain/use_cases/get_current_environment_use_case.dart'
    as _i593;
import '../../features/environments_dev/domain/use_cases/get_environment_config_use_case.dart'
    as _i273;
import '../../features/environments_dev/domain/use_cases/update_environment_configuration_use_case.dart'
    as _i651;
import '../../features/environments_dev/presentation/cubit/environment_cubit.dart'
    as _i266;
import '../../features/notifications/data/repository/notification_repository_impl.dart'
    as _i122;
import '../../features/notifications/domain/repository/notification_repository.dart'
    as _i1068;
import '../../features/notifications/domain/use_cases/cancel_all_notifications.dart'
    as _i331;
import '../../features/notifications/domain/use_cases/cancel_notification.dart'
    as _i624;
import '../../features/notifications/domain/use_cases/schedule_notification.dart'
    as _i1025;
import '../../features/notifications/domain/use_cases/show_notification.dart'
    as _i766;
import '../../features/notifications/presentation/cubit/notification_cubit.dart'
    as _i459;
import '../../features/onboarding/data/data_sources/onboarding_local_datasource.dart'
    as _i72;
import '../../features/onboarding/data/repository/onboarding_repository_impl.dart'
    as _i20;
import '../../features/onboarding/domain/repository/onboarding_repository.dart'
    as _i335;
import '../../features/onboarding/domain/use_cases/check_onboarding_status_usecase.dart'
    as _i808;
import '../../features/onboarding/domain/use_cases/complete_onboarding_usecase.dart'
    as _i897;
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart'
    as _i807;
import '../../features/splash/presentation/cubit/splash_cubit.dart' as _i125;
import '../infrastructure/network/api_client.dart' as _i450;
import '../infrastructure/network/api_interceptor.dart' as _i922;
import '../infrastructure/network/api_response_parser.dart' as _i990;
import '../infrastructure/network/dio_api_client.dart' as _i498;
import '../infrastructure/network/dio_module.dart' as _i75;
import '../infrastructure/network/network_connectivity.dart' as _i993;
import '../infrastructure/storage/hive_storage_service.dart' as _i378;
import '../infrastructure/storage/secure_storage_service.dart' as _i783;
import '../infrastructure/storage/storage_service.dart' as _i124;
import '../router/app_router.dart' as _i81;
import '../services/firebase/firebase_analytics_service.dart' as _i431;
import '../services/firebase/firebase_crashlytics_service.dart' as _i349;
import '../services/firebase/firebase_messaging_service.dart' as _i340;
import '../services/firebase/firebase_service.dart' as _i376;
import '../services/notification/local_notification_service.dart' as _i474;
import '../services/parser/payload_parser.dart' as _i356;
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
    gh.lazySingleton<_i376.FirebaseService>(() => _i376.FirebaseService());
    await gh.lazySingletonAsync<_i474.LocalNotificationService>(() {
      final i = _i474.LocalNotificationService();
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.lazySingleton<_i845.AppLocaleState>(() => _i845.AppLocaleState());
    gh.lazySingleton<_i48.PlatformChecker>(() => const _i48.PlatformChecker());
    gh.lazySingleton<_i990.AuthEndpoints>(() => _i990.AuthEndpoints());
    gh.lazySingleton<_i783.SecureStorageService>(
      () => _i783.SecureStorageServiceImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i356.PayloadParser>(() => _i356.IsolatePayloadParser());
    gh.lazySingleton<_i993.NetworkConnectivity>(
      () => _i993.NetworkConnectivityImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i431.FirebaseAnalyticsService>(
      () => _i431.FirebaseAnalyticsService(
        firebaseService: gh<_i376.FirebaseService>(),
      ),
    );
    gh.lazySingleton<_i349.FirebaseCrashlyticsService>(
      () => _i349.FirebaseCrashlyticsService(
        firebaseService: gh<_i376.FirebaseService>(),
      ),
    );
    gh.lazySingleton<_i1068.NotificationRepository>(
      () => _i122.NotificationRepositoryImpl(
        service: gh<_i474.LocalNotificationService>(),
      ),
    );
    gh.lazySingleton<_i440.DeviceServices>(
      () => _i440.DeviceServices(
        platformChecker: gh<_i48.PlatformChecker>(),
        deviceInfoPlugin: gh<_i833.DeviceInfoPlugin>(),
      ),
    );
    await gh.factoryAsync<_i124.StorageService>(() {
      final i = _i378.HiveStorageService(gh<_i783.SecureStorageService>());
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.lazySingleton<_i331.CancelAllNotificationsUseCase>(
      () => _i331.CancelAllNotificationsUseCase(
        gh<_i1068.NotificationRepository>(),
      ),
    );
    gh.lazySingleton<_i624.CancelNotificationUseCase>(
      () =>
          _i624.CancelNotificationUseCase(gh<_i1068.NotificationRepository>()),
    );
    gh.lazySingleton<_i1025.ScheduleNotificationUseCase>(
      () => _i1025.ScheduleNotificationUseCase(
        gh<_i1068.NotificationRepository>(),
      ),
    );
    gh.lazySingleton<_i766.ShowNotificationUseCase>(
      () => _i766.ShowNotificationUseCase(gh<_i1068.NotificationRepository>()),
    );
    gh.factory<_i459.NotificationCubit>(
      () => _i459.NotificationCubit(
        showNotificationUseCase: gh<_i766.ShowNotificationUseCase>(),
        scheduleNotificationUseCase: gh<_i1025.ScheduleNotificationUseCase>(),
        cancelNotificationUseCase: gh<_i624.CancelNotificationUseCase>(),
        cancelAllNotificationsUseCase:
            gh<_i331.CancelAllNotificationsUseCase>(),
      ),
    );
    gh.factory<_i109.EnvironmentConfigService>(
      () => _i109.EnvironmentConfigStorageService(
        storageService: gh<_i124.StorageService>(),
      ),
    );
    gh.lazySingleton<_i990.APIResponseParser>(
      () => _i990.IsolateAPIResponseParser(gh<_i356.PayloadParser>()),
    );
    gh.lazySingleton<_i922.APIInterceptor>(
      () => _i922.APIInterceptor(
        appLocaleState: gh<_i845.AppLocaleState>(),
        secureStorage: gh<_i783.SecureStorageService>(),
        environmentConfigService: gh<_i109.EnvironmentConfigService>(),
      ),
    );
    gh.lazySingleton<_i72.OnboardingLocalDataSource>(
      () => _i72.OnboardingLocalDataSourceImpl(gh<_i124.StorageService>()),
    );
    gh.lazySingleton<_i498.AuthLocalDataSource>(
      () => _i498.AuthLocalDataSourceImpl(
        storageService: gh<_i124.StorageService>(),
        secureStorageService: gh<_i783.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i1.EnvironmentLocalDataSource>(
      () => _i1.EnvironmentLocalDataSourceImpl(
        environmentConfigService: gh<_i109.EnvironmentConfigService>(),
      ),
    );
    gh.lazySingleton<_i310.EnvironmentRepository>(
      () =>
          _i156.EnvironmentRepositoryImpl(gh<_i1.EnvironmentLocalDataSource>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(gh<_i922.APIInterceptor>()),
    );
    gh.lazySingleton<_i335.OnboardingRepository>(
      () => _i20.OnboardingRepositoryImpl(gh<_i72.OnboardingLocalDataSource>()),
    );
    gh.lazySingleton<_i808.CheckOnboardingStatusUseCase>(
      () =>
          _i808.CheckOnboardingStatusUseCase(gh<_i335.OnboardingRepository>()),
    );
    gh.lazySingleton<_i897.CompleteOnboardingUseCase>(
      () => _i897.CompleteOnboardingUseCase(gh<_i335.OnboardingRepository>()),
    );
    gh.lazySingleton<_i496.DeveloperLoginUseCase>(
      () => _i496.DeveloperLoginUseCase(gh<_i310.EnvironmentRepository>()),
    );
    gh.lazySingleton<_i422.GetCurrentApiConfigUseCase>(
      () => _i422.GetCurrentApiConfigUseCase(gh<_i310.EnvironmentRepository>()),
    );
    gh.lazySingleton<_i593.GetCurrentEnvironmentUseCase>(
      () =>
          _i593.GetCurrentEnvironmentUseCase(gh<_i310.EnvironmentRepository>()),
    );
    gh.lazySingleton<_i273.GetEnvironmentConfigUseCase>(
      () =>
          _i273.GetEnvironmentConfigUseCase(gh<_i310.EnvironmentRepository>()),
    );
    gh.lazySingleton<_i651.UpdateEnvironmentConfigUseCase>(
      () => _i651.UpdateEnvironmentConfigUseCase(
        gh<_i310.EnvironmentRepository>(),
      ),
    );
    gh.factory<_i807.OnboardingCubit>(
      () => _i807.OnboardingCubit(gh<_i897.CompleteOnboardingUseCase>()),
    );
    gh.lazySingleton<_i450.APIClient>(
      () => _i498.DioAPIClient(gh<_i361.Dio>(), gh<_i990.APIResponseParser>()),
    );
    gh.factory<_i266.EnvironmentCubit>(
      () => _i266.EnvironmentCubit(
        developerLoginUseCase: gh<_i496.DeveloperLoginUseCase>(),
        getCurrentApiConfigUseCase: gh<_i422.GetCurrentApiConfigUseCase>(),
        getEnvironmentConfigUseCase: gh<_i273.GetEnvironmentConfigUseCase>(),
        getCurrentEnvironmentUseCase: gh<_i593.GetCurrentEnvironmentUseCase>(),
        updateEnvironmentConfigUseCase:
            gh<_i651.UpdateEnvironmentConfigUseCase>(),
      ),
    );
    gh.lazySingleton<_i586.AuthRemoteDataSource>(
      () => _i586.AuthRemoteDataSourceImpl(
        apiClient: gh<_i450.APIClient>(),
        connectivity: gh<_i993.NetworkConnectivity>(),
        authEndpoints: gh<_i990.AuthEndpoints>(),
      ),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i104.AuthRepositoryImpl(
        deviceServices: gh<_i440.DeviceServices>(),
        localDataSource: gh<_i498.AuthLocalDataSource>(),
        remoteDataSource: gh<_i586.AuthRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i367.DeleteAccountUseCase>(
      () => _i367.DeleteAccountUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i242.GetAuthenticatedUserUseCase>(
      () => _i242.GetAuthenticatedUserUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i391.IsLoggedInUseCase>(
      () => _i391.IsLoggedInUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i1012.LoginUseCase>(
      () => _i1012.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i844.LogoutUseCase>(
      () => _i844.LogoutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i957.RegisterUseCase>(
      () => _i957.RegisterUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i125.SplashCubit>(
      () => _i125.SplashCubit(
        gh<_i391.IsLoggedInUseCase>(),
        gh<_i808.CheckOnboardingStatusUseCase>(),
      ),
    );
    await gh.lazySingletonAsync<_i340.FirebaseMessageService>(() {
      final i = _i340.FirebaseMessageService(
        firebaseService: gh<_i376.FirebaseService>(),
        analyticsService: gh<_i431.FirebaseAnalyticsService>(),
        crashlyticsService: gh<_i349.FirebaseCrashlyticsService>(),
        authRepository: gh<_i787.AuthRepository>(),
        localNotificationService: gh<_i474.LocalNotificationService>(),
      );
      return i.init().then((_) => i);
    }, preResolve: true);
    gh.factory<_i117.AuthCubit>(
      () => _i117.AuthCubit(
        loginUseCase: gh<_i1012.LoginUseCase>(),
        registerUseCase: gh<_i957.RegisterUseCase>(),
        logoutUseCase: gh<_i844.LogoutUseCase>(),
        isLoggedInUseCase: gh<_i391.IsLoggedInUseCase>(),
        deleteAccountUseCase: gh<_i367.DeleteAccountUseCase>(),
        getAuthenticatedUserUseCase: gh<_i242.GetAuthenticatedUserUseCase>(),
      ),
    );
    gh.lazySingleton<_i81.AuthGuard>(
      () => _i81.AuthGuard(gh<_i117.AuthCubit>()),
    );
    gh.lazySingleton<_i81.AppRouter>(
      () => _i81.AppRouter(gh<_i81.AuthGuard>()),
    );
    return this;
  }
}

class _$InjectionModule extends _i464.InjectionModule {}

class _$NetworkModule extends _i75.NetworkModule {}
