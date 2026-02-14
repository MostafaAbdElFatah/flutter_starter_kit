import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/text_fields/text_fields.dart';
import '../../../../core/assets/localization_keys.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/validators/password_validator.dart';
import '../cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  EmailTextField(controller: _emailController),
                  const SizedBox(height: 16),
                  PasswordTextField(
                    controller: _passwordController,
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
                    child: Text(LocalizationKeys.login),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => context.push('/this-route-does-not-exist'),
                    //onPressed: () => GoRouter.of(context).pushRegister(),
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
