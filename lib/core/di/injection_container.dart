import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../network/api_client.dart';
import '../storage/storage_service.dart';
import '../config/config_service.dart';
import '../config/app_config.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  await Hive.initFlutter();
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Core
  final configService = ConfigService();
  await configService.init();
  sl.registerSingleton(configService);

  final storageService = StorageServiceImpl(sl());
  await storageService.init();
  sl.registerSingleton<StorageService>(storageService);

  sl.registerLazySingleton(() => ApiClient(sl(), sl()));

  // Features - Auth
  // TODO: Register Auth Bloc, UseCases, Repositories
}
