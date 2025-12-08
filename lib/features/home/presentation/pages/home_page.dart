import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/assets/localization_keys.dart';
import '../../../../core/di/di.dart' as di;
import '../../../../core/infrastructure/domain/entities/no_params.dart';
import '../../../../core/router/app_router.dart';
import '../../../environments_dev/domain/usecases/get_current_environment_use_case.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentEnv = di.get<GetCurrentEnvironmentUseCase>()(NoParams());

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationKeys.homeTitle),
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).goToSettings(),
            icon: const Icon(Icons.settings),
          ),
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
