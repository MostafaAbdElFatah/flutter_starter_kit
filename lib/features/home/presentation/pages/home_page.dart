import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/utils/app_locale.dart';

import '../../../../core/assets/locale_keys.dart';
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
        title: Text(LocaleKeys.homeTitle),
        actions: [
          IconButton(
            onPressed: context.toggleLanguage,
            icon: Icon(Icons.language),
          ),
          EnvironmentSwitcher(),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(LocaleKeys.welcomeFlutterStarterKit),
            SizedBox(height: 10),
            Text('Environment ${currentEnv.name.toUpperCase()}'),
          ],
        ),
      ),
    );
  }
}
