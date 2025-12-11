import 'package:flutter_starter_kit/core/constants/app_constants.dart';
import 'package:flutter_starter_kit/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/helper_test.mocks.dart';

void main() {
  late MockStorageService storageService;
  late OnboardingLocalDataSourceImpl dataSource;

  setUp(() {
    storageService = MockStorageService();
    dataSource = OnboardingLocalDataSourceImpl(storageService);
  });

  group('isOnboardingCompleted', () {
    test('returns stored value when available', () {

      // Arrange
      when(
        storageService.get(
          AppConstants.onboardingCompleteKey,
          defaultValue: anyNamed('defaultValue'),
        ),
      ).thenReturn(true);

      // Act
      final result = dataSource.isOnboardingCompleted();

      // Assert
      expect(result, true);
      verify(
        storageService.get(
          AppConstants.onboardingCompleteKey,
          defaultValue: false,
        ),
      ).called(1);
    });

    test('returns default value (false) when key is missing', () {

      // Arrange
      when(
        storageService.get(
          AppConstants.onboardingCompleteKey,
          defaultValue: anyNamed('defaultValue'),
        ),
      ).thenReturn(false);

      // Act
      final result = dataSource.isOnboardingCompleted();

      // Assert
      expect(result, false);
    });
  });

  group('completeOnboarding', () {
    test('stores true and completes', () async {

      // Arrange
      when(
        storageService.put(
          key: AppConstants.onboardingCompleteKey,
          value: true,
        ),
      ).thenAnswer((_) async => Future.value());

      // Act & Assert
      expect(dataSource.completeOnboarding(), completes);
      verify(
        storageService.put(
          key: AppConstants.onboardingCompleteKey,
          value: true,
        ),
      ).called(1);
    });
  });
}
