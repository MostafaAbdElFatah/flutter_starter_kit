import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/api_client.dart';
import '../storage/storage_service.dart';
import '../config/app_config.dart';

final sl = GetIt.instance;

Future<void> init(AppConfig appConfig) async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Core
  sl.registerLazySingleton(() => appConfig);
  
  final storageService = StorageServiceImpl(sl());
  await storageService.init();
  sl.registerSingleton<StorageService>(storageService);

  sl.registerLazySingleton(() => ApiClient(sl(), sl()));

  // Features - Auth
  // TODO: Register Auth Bloc, UseCases, Repositories
}
