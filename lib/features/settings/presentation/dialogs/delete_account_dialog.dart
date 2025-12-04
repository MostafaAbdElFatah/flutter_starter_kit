// Add this method to your widget class
import 'package:flutter/material.dart';

import '../../../../core/assets/localization_keys.dart';

void showDeleteAccountDialog(
  BuildContext context, {
  required VoidCallback deleteAccount,
}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          LocalizationKeys.deleteAccount,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          LocalizationKeys.deleteAccountWarning,
          // Or use a hardcoded string if you don't have the localization key:
          // 'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              LocalizationKeys.cancel,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              deleteAccount();
            },
            child: Text(
              LocalizationKeys.delete,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
