import 'package:flutter/material.dart';
import 'app.dart';
import 'core/config/env.dart';
import 'core/config/app_config.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prodConfig = AppConfig(
    environment: Environment.prod,
    apiBaseUrl: EnvProd.baseUrl,
    appName: 'Flutter Starter Kit',
  );

  await di.init(prodConfig);
  runApp(const App());
}
