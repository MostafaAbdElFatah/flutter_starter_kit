import 'package:flutter/material.dart';
import 'app.dart';
import 'core/config/env.dart';
import 'core/config/app_config.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final devConfig = AppConfig(
    environment: Environment.dev,
    apiBaseUrl: EnvDev.baseUrl,
    appName: 'Flutter Starter Kit (Dev)',
  );

  await di.init(devConfig);
  runApp(const App());
}
