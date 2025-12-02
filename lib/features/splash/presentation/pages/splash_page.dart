import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/splash_cubit.dart';
import '../../../../core/di/di.dart' as di;


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.get<SplashCubit>()..checkAuth(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state == SplashState.onboarding) {
            context.go('/onboarding');
          } else if (state == SplashState.authenticated) {
            context.go('/home');
          } else if (state == SplashState.unauthenticated) {
            context.go('/login'); // TODO: Go to login
          }
        },
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
