import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'injection.dart' show configureDependencies;

/// A global service locator instance for dependency injection.
final _sl = GetIt.instance;

// /// A convenient global accessor for the application's [ConfigService].
// ///
// /// This provides easy access to configuration settings without needing to
// /// repeatedly look up the service from the service locator.
// final ConfigService configService = _sl<ConfigService>();

/// A top-level convenience function for resolving dependencies from the service locator.
///
/// Example:
/// ```dart
/// final myService = get<MyService>();
/// ```
T get<T extends Object>() => _sl<T>();

/// Initializes the application's dependencies.
///
/// This function sets up Hive for local storage and then calls the injectable-generated
/// function `configureDependencies()` to register all the necessary services.
Future<void> setupDependencies() async {
  // Initialize Hive for local data storage before setting up dependencies.
  await Hive.initFlutter();

  // Let injectable handle the dependency registration.
  await configureDependencies();
}

/// A module for registering third-party dependencies that injectable cannot
/// construct on its own.
///
/// This module provides factory methods for external packages like [Connectivity],
/// [DeviceInfoPlugin], and [FlutterSecureStorage], allowing them to be injected
/// into other services.
@module
abstract class InjectionModule {
  /// Provides a lazy singleton instance of [Connectivity].
  @lazySingleton
  Connectivity get connectivity => Connectivity();

  /// Provides a lazy singleton instance of [DeviceInfoPlugin].
  @lazySingleton
  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();

  /// Provides a lazy singleton instance of [FlutterSecureStorage].
  @lazySingleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage();
}
