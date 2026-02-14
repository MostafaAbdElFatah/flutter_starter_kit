import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/usecases/usecase.dart';
import '../../../../core/infrastructure/cubits/base_cubit.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';

/// The concrete implementation of the [OnboardingCubit].
///
/// This cubit marks onboarding as completed.
@injectable
class OnboardingCubit extends BaseCubit<void> {
  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  OnboardingCubit(this._completeOnboardingUseCase) : super(null);

  /// A static helper method to retrieve the [OnboardingCubit] instance from the widget tree.
  ///
  /// This simplifies accessing the cubit from UI components.
  ///
  /// Example:
  /// ```dart
  /// OnboardingCubit.of(context).completeOnboarding();
  /// ```
  static OnboardingCubit of(BuildContext context, {bool listen = false}) =>
      BaseCubit.of(context, listen: listen);

  /// Marks onboarding as completed for the current user.
  Future<void> completeOnboarding() => _completeOnboardingUseCase(NoParams());
}
