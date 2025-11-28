import 'package:flutter/material.dart';
import '../../../../core/config/config_service.dart';
import '../../../../core/di/injection_container.dart';
import '../widgets/environment_switcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final configService = sl<ConfigService>();
    final currentEnv = configService.currentConfig.environment;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [EnvironmentSwitcher()],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome to Flutter Starter Kit!'),
            SizedBox(height: 10),
            Text('Environment ${currentEnv.name.toUpperCase()}'),
          ],
        ),
      ),
    );
  }
}
