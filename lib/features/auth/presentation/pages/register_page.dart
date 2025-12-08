import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


import '../../../../core/assets/localization_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/validators/email_validator.dart';
import '../../../../core/utils/validators/password_validator.dart';
import '../../../../core/utils/validators/user_name_validator.dart';
import '../cubit/auth_cubit.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: const _RegisterForm(),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocalizationKeys.register)),
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
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: UsernameValidator.validateUsername,
                    // Custom Username Requirements
                    // validator: (value) => UsernameValidator.validateUsername(
                    //   value,
                    //   minLength: 5,
                    //   maxLength: 15,
                    //   allowNumbers: false,
                    // ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: EmailValidator.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: PasswordValidator.validatePassword,
                    // Custom Password Requirements
                    // validator: (value) => PasswordValidator.validatePassword(
                    //   value,
                    //   minLength: 12,
                    //   requireSpecialChar: false,
                    // ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) => PasswordValidator.validatePasswordConfirmation(
                      value,
                      _passwordController.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        AuthCubit.of(context).register(
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      }
                    },
                    child: const Text('Register'),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go to Login'),
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
