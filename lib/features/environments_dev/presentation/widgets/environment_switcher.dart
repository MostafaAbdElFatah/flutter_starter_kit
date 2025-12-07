import 'package:flutter/material.dart';
import '../../domain/entities/environment.dart';

class EnvironmentSwitcher extends StatelessWidget {
  final Environment currentEnvironment;
  final PopupMenuItemSelected<Environment>? onEnvironmentSelected;
  const EnvironmentSwitcher({
    super.key,
    required this.currentEnvironment,
    this.onEnvironmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Environment>(
      initialValue: currentEnvironment,
      icon: const Icon(Icons.settings),
      onSelected: onEnvironmentSelected,
      //     (Environment env) async {
      //   if (env != currentEnvironment) {
      //     await di.configService.setEnvironment(env);
      //     // Show dialog to restart
      //     if (context.mounted) {
      //       showEnvironmentChangedDialog(
      //         context,
      //         envName: env.name,
      //         environmentChanged: environmentChanged,
      //       );
      //     }
      //   }
      // },
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
