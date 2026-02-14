import 'package:flutter_starter_kit/core/infrastructure/use_cases/usecase.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/environment.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/use_cases/get_current_environment_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/helper_test.mocks.dart';



void main() {
  late GetCurrentEnvironmentUseCase useCase;
  late MockEnvironmentRepository mockRepository;

  setUp(() {
    mockRepository = MockEnvironmentRepository();
    useCase = GetCurrentEnvironmentUseCase(mockRepository);
  });

  group('GetCurrentEnvironmentUseCase', () {
    test('should return current environment from repository', () {
      // arrange
      const tEnvironment = Environment.dev;

      when(mockRepository.currentEnvironment).thenReturn(tEnvironment);

      // act
      final result = useCase(const NoParams());

      // assert
      expect(result, equals(Environment.dev));
      verify(mockRepository.currentEnvironment);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return development environment', () {
      // arrange
      const tEnvironment = Environment.dev;

      when(mockRepository.currentEnvironment).thenReturn(tEnvironment);

      // act
      final result = useCase(const NoParams());

      // assert
      expect(result, equals(Environment.dev));
      verify(mockRepository.currentEnvironment);
    });

    test('should return staging environment', () {
      // arrange
      const tEnvironment = Environment.stage;

      when(mockRepository.currentEnvironment).thenReturn(tEnvironment);

      // act
      final result = useCase(const NoParams());

      // assert
      expect(result, equals(Environment.stage));
      verify(mockRepository.currentEnvironment);
    });

    test('should return production environment', () {
      // arrange
      const tEnvironment = Environment.prod;

      when(mockRepository.currentEnvironment).thenReturn(tEnvironment);

      // act
      final result = useCase(const NoParams());

      // assert
      expect(result, equals(Environment.prod));
      verify(mockRepository.currentEnvironment);
    });

    test('should call repository exactly once', () {
      // arrange
      const tEnvironment = Environment.dev;

      when(mockRepository.currentEnvironment).thenReturn(tEnvironment);

      // act
      useCase(const NoParams());

      // assert
      verify(mockRepository.currentEnvironment).called(1);
    });

    test('should handle multiple consecutive calls', () {
      // arrange
      const tEnvironment = Environment.stage;

      when(mockRepository.currentEnvironment).thenReturn(tEnvironment);

      // act
      final result1 = useCase(const NoParams());
      final result2 = useCase(const NoParams());

      // assert
      expect(result1, equals(result2));
      expect(result1, equals(Environment.stage));
      verify(mockRepository.currentEnvironment).called(2);
    });

    test('should return same environment type across multiple calls', () {
      // arrange
      const tEnvironment = Environment.prod;

      when(mockRepository.currentEnvironment).thenReturn(tEnvironment);

      // act
      final result1 = useCase(const NoParams());
      final result2 = useCase(const NoParams());
      final result3 = useCase(const NoParams());

      // assert
      expect(result1, equals(result2));
      expect(result2, equals(result3));
      verify(mockRepository.currentEnvironment).called(3);
    });

    test('should distinguish between different environments', () {
      // arrange
      when(mockRepository.currentEnvironment).thenReturn(Environment.dev);

      // act
      final devResult = useCase(const NoParams());

      // arrange - change environment
      when(mockRepository.currentEnvironment).thenReturn(Environment.prod);

      // act
      final prodResult = useCase(const NoParams());

      // assert
      expect(devResult, isNot(equals(prodResult)));
      expect(devResult, equals(Environment.dev));
      expect(prodResult, equals(Environment.prod));
    });
  });
}