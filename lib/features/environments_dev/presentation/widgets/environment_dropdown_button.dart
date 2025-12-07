import 'package:flutter/material.dart';

import '../../../../core/assets/localization_keys.dart';
import '../../domain/entities/environment.dart';

class EnvironmentDropdownButtonFormField extends StatelessWidget {
  final Environment initialValue;
  final ValueChanged<Environment> onChanged;
  const EnvironmentDropdownButtonFormField({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Environment>(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: LocalizationKeys.environment,
        border: OutlineInputBorder(),
      ),
      items: Environment.values.map((env) {
        return DropdownMenuItem(
          value: env,
          child: Text(env.toString().split('.').last.toUpperCase()),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
