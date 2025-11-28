import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/onboarding_cubit.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(sl()),
      child: Builder(
        builder: (context) => Scaffold(
          body: PageView(
            children: [
              _buildPage(
                title: 'Welcome',
                description: 'This is the best starter kit.',
                color: Colors.blue,
              ),
              _buildPage(
                title: 'Clean Architecture',
                description: 'Built with scalability in mind.',
                color: Colors.green,
              ),
              _buildPage(
                title: 'Get Started',
                description: 'Let\'s build something amazing.',
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
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          if (isLast) ...[
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: color,
              ),
              child: const Text('Get Started'),
            ),
          ],
        ],
      ),
    );
  }
}
