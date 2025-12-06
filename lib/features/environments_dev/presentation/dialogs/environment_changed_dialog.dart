import 'package:flutter/material.dart';

import '../../../../core/assets/localization_keys.dart';

/// A dialog that informs the user that the application environment has changed.
///
/// This dialog is shown after the user selects a new environment, confirming that
/// the change has been applied.
Future<void> showEnvironmentChangedDialog(
  BuildContext context, {
  required String envName,
  required VoidCallback environmentChanged,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // User must acknowledge the change.
    builder: (context) => AlertDialog(
      title: Text(LocalizationKeys.environmentChanged),
      content: Text(LocalizationKeys.switchedToEnv(envName)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            environmentChanged();
          },
          child: Text(LocalizationKeys.ok),
        ),
      ],
    ),
  );
}
