import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/di/injection.dart' as injection;
import '../cubit/splash_cubit.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injection.get<SplashCubit>()..checkAuth(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state == SplashState.onboarding) {
            GoRouter.of(context).goToOnboarding();
          } else if (state == SplashState.authenticated) {
            GoRouter.of(context).goToHome();
          } else if (state == SplashState.unauthenticated) {
            GoRouter.of(context).goToLogin();
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
