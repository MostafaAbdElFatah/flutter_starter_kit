import 'package:flutter/material.dart';
import '../../../../core/config/config_service.dart';
import '../../../../core/di/di.dart' as di;
import '../../../../core/assets/localization_keys.dart';

class DeveloperLoginDialog extends StatefulWidget {
  final Function(bool) onLoginResult;

  const DeveloperLoginDialog({super.key, required this.onLoginResult});

  @override
  State<DeveloperLoginDialog> createState() => _DeveloperLoginDialogState();
}

class _DeveloperLoginDialogState extends State<DeveloperLoginDialog> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Check credentials against AppConfig
      // Note: In a real app, these should probably be hashed or checked against a secure source.
      // For this requirement, we check against AppConfig.
      
      // Since AppConfig is static/singleton-like in how it's accessed usually, 
      // we might need to define these credentials in AppConfig first.
      // For now, let's assume hardcoded check based on "in AppConfig" requirement.
      // We will add `devUsername` and `devPassword` to AppConfig later.
      
      // Placeholder check until AppConfig is updated
      final config = di.get<ConfigService>().currentConfig;
      final validUsername = config.devUsername;
      final validPassword = config.devPassword;

      if (_usernameController.text == validUsername && 
          _passwordController.text == validPassword) {
        Navigator.of(context).pop();
        widget.onLoginResult(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocalizationKeys.invalidCredentials)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocalizationKeys.developerLogin),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: LocalizationKeys.username),
              validator: (value) => value!.isEmpty ? LocalizationKeys.required : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: LocalizationKeys.password,
                suffixIcon: IconButton(
                  icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _isObscure = !_isObscure),
                ),
              ),
              obscureText: _isObscure,
              validator: (value) => value!.isEmpty ? LocalizationKeys.required : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(LocalizationKeys.cancel),
        ),
        ElevatedButton(
          onPressed: _login,
          child: Text(LocalizationKeys.login),
        ),
      ],
    );
  }
}
