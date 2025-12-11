import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/assets/localization_keys.dart';
import '../../../../core/di/di.dart' as di;
import '../bloc/onboarding_cubit.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.get<OnboardingCubit>(),
      child: OnboardingPageContent(),
    );
  }
}

class OnboardingPageContent extends StatefulWidget {
  const OnboardingPageContent({super.key});

  @override
  State<OnboardingPageContent> createState() => _OnboardingPageContentState();
}

class _OnboardingPageContentState extends State<OnboardingPageContent> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  void _onNextPressed() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onSkipPressed();
    }
  }

  void _onSkipPressed() {
    OnboardingCubit.of(context).completeOnboarding();
    GoRouter.of(context).goToLogin();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildPage(
            title: LocalizationKeys.onboardingTitle1,
            description: LocalizationKeys.onboardingDesc1,
            color: Colors.blue,
            currentPage: 0,
            totalPages: _totalPages,
            onNext: _onNextPressed,
            onSkip: _onSkipPressed,
          ),
          _buildPage(
            title: LocalizationKeys.onboardingTitle2,
            description: LocalizationKeys.onboardingDesc2,
            color: Colors.green,
            currentPage: 1,
            totalPages: _totalPages,
            onNext: _onNextPressed,
            onSkip: _onSkipPressed,
          ),
          _buildPage(
            title: LocalizationKeys.onboardingTitle3,
            description: LocalizationKeys.onboardingDesc3,
            color: Colors.orange,
            currentPage: 2,
            totalPages: _totalPages,
            onNext: _onNextPressed,
            onSkip: _onSkipPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required Color color,
    required int currentPage,
    required int totalPages,
    VoidCallback? onNext,
    VoidCallback? onSkip,
  }) {
    final isLastPage = currentPage == totalPages - 1;

    return Container(
      color: color,
      child: SafeArea(
        child: Column(
          children: [
            // Skip button at the top
            if (!isLastPage)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: onSkip,
                  child: Text(
                    LocalizationKeys.skip, // 'Skip'
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

            // Main content
            Expanded(
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
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      description,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: isLastPage
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: color,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          LocalizationKeys.getStarted,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Page indicator dots (optional)
                        Row(
                          children: List.generate(
                            totalPages,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == currentPage
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),

                        // Next button
                        ElevatedButton(
                          onPressed: onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: color,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                LocalizationKeys.next, // 'Next'
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
