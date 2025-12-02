import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/assets/localization_keys.dart';
import '../bloc/onboarding_cubit.dart';
import '../../../../core/di/di.dart' as di;

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.get<OnboardingCubit>(),
      child: Builder(
        builder: (context) => Scaffold(
          body: PageView(
            children: [
              _buildPage(
                title: LocalizationKeys.onboardingTitle1,
                description: LocalizationKeys.onboardingDesc1,
                color: Colors.blue,
              ),
              _buildPage(
                title: LocalizationKeys.onboardingTitle2,
                description: LocalizationKeys.onboardingDesc2,
                color: Colors.green,
              ),
              _buildPage(
                title: LocalizationKeys.onboardingTitle3,
                description: LocalizationKeys.onboardingDesc3,
                color: Colors.orange,
                isLast: true,
                onPressed: () {
                  context.read<OnboardingCubit>().completeOnboarding();
                  context.go('/home'); // TODO: Go to login
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required Color color,
    bool isLast = false,
    VoidCallback? onPressed,
  }) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          if (isLast) ...[
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: color,
              ),
              child: Text(LocalizationKeys.getStarted),
            ),
          ],
        ],
      ),
    );
  }
}
