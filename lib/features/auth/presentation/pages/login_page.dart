import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/assets/localization_keys.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/di.dart' as di;
import '../../../../core/validators/email_validator.dart';
import '../../../../core/validators/password_validator.dart';
import '../cubit/auth_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.get<AuthCubit>(),
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocalizationKeys.login)),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to home
            context.go('/');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: LocalizationKeys.email,
                    ),
                    validator: EmailValidator.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: LocalizationKeys.password,
                    ),
                    obscureText: true,
                    //validator: PasswordValidator.validatePassword,
                    // Custom Password Requirements
                    validator: (value) => PasswordValidator.validatePassword(
                      value,
                      minLength: 8,
                      requireSpecialChar: false,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        AuthCubit.of(context).login(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => GoRouter.of(context).pushRegister(),
                    child: const Text('Go to Register'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
