import 'package:flutter_starter_kit/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/helper_test.mocks.dart';


void main() {
  late MockOnboardingLocalDataSource localDataSource;
  late OnboardingRepositoryImpl repository;

  setUp(() {
    localDataSource = MockOnboardingLocalDataSource();
    repository = OnboardingRepositoryImpl(localDataSource);
  });

  group('isOnboardingCompleted', () {
    test('returns the value from local data source', () {
      when(localDataSource.isOnboardingCompleted()).thenReturn(true);

      final result = repository.isOnboardingCompleted();

      expect(result, true);
      verify(localDataSource.isOnboardingCompleted()).called(1);
    });
  });

  group('completeOnboarding', () {
    test('delegates to local data source', () async {
      when(localDataSource.completeOnboarding())
          .thenAnswer((_) async => Future.value());

      expect(repository.completeOnboarding(), completes);

      verify(localDataSource.completeOnboarding()).called(1);
    });
  });
}
