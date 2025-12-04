import 'package:flutter/material.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/di/di.dart' as di;
import '../dialogs/environment_changed_dialog.dart';

class EnvironmentSwitcher extends StatelessWidget {
  final VoidCallback environmentChanged;
  const EnvironmentSwitcher({super.key, required this.environmentChanged});

  @override
  Widget build(BuildContext context) {
    final currentEnv = di.configService.currentConfig.environment;

    return PopupMenuButton<Environment>(
      initialValue: currentEnv,
      icon: const Icon(Icons.settings),
      onSelected: (Environment env) async {
        if (env != currentEnv) {
          await di.configService.setEnvironment(env);
          // Show dialog to restart
          if (context.mounted) {
            showEnvironmentChangedDialog(
              context,
              envName: env.name,
              environmentChanged: environmentChanged,
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
