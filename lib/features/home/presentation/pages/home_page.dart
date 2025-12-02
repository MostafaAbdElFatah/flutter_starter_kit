import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/utils/app_locale.dart';

import '../../../../core/assets/localization_keys.dart';
import '../../../../core/di/di.dart' as di;
import '../widgets/environment_switcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentEnv = di.configService.currentConfig.environment;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationKeys.homeTitle),
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
            Text(LocalizationKeys.welcomeFlutterStarterKit),
            SizedBox(height: 10),
            Text('Environment ${currentEnv.name.toUpperCase()}'),
          ],
        ),
      ),
    );
  }
}
