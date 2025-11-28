import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/config_service.dart';
import '../../../../core/di/injection_container.dart';

class EnvironmentSwitcher extends StatelessWidget {
  const EnvironmentSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final configService = sl<ConfigService>();
    final currentEnv = configService.currentConfig.environment;

    return PopupMenuButton<Environment>(
      initialValue: currentEnv,
      icon: const Icon(Icons.settings),
      onSelected: (Environment env) async {
        if (env != currentEnv) {
          await configService.setEnvironment(env);
          // Show dialog to restart
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('Environment Changed'),
                content: Text(
                  'Switched to ${env.name}. the app to apply changes fully.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // In a real app, we might trigger a full rebuild or restart
                      // For now, we just close the dialog and maybe navigate home
                      context.go('/');
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      },
      itemBuilder: (BuildContext context) {
        return Environment.values.map((Environment env) {
          return PopupMenuItem<Environment>(
            value: env,
            child: Text(env.name.toUpperCase()),
          );
        }).toList();
      },
    );
  }
}
