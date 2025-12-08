import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/di.dart' as di;
import '../../../../core/assets/localization_keys.dart';
import '../../../../core/router/app_router.dart';
import '../cubit/environment_cubit.dart';

class DeveloperLoginDialog extends StatefulWidget {
  final Function(bool) onLoginResult;

  const DeveloperLoginDialog({super.key, required this.onLoginResult});

  @override
  State<DeveloperLoginDialog> createState() => _DeveloperLoginDialogState();

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BlocProvider(
        create: (context) => di.get<EnvironmentCubit>(),
        child: DeveloperLoginDialog(
          onLoginResult: (bool p1) {
            GoRouter.of(context).pushEnvironmentConfig();
          },
        ),
      ),
    );
  }
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
      // Placeholder check until AppConfig is updated
      final devUsername = _usernameController.text.trim();
      final devPassword = _passwordController.text.trim();

      if (EnvironmentCubit.of(
        context,
      ).loginAsDeveloper(username: devUsername, password: devPassword)) {
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
              validator: (value) =>
                  value!.isEmpty ? LocalizationKeys.required : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: LocalizationKeys.password,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _isObscure = !_isObscure),
                ),
              ),
              obscureText: _isObscure,
              validator: (value) =>
                  value!.isEmpty ? LocalizationKeys.required : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(LocalizationKeys.cancel),
        ),
        ElevatedButton(onPressed: _login, child: Text(LocalizationKeys.login)),
      ],
    );
  }
}
