import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_starter_kit/core/errors/failure.dart';
import 'package:flutter_starter_kit/core/infrastructure/use_cases/usecase.dart';
import 'package:flutter_starter_kit/features/auth/domain/use_cases/logout_usecase.dart';
import '../../../../helper/helper_test.mocks.dart';


void main() {
  late MockAuthRepository mockRepository;
  late LogoutUseCase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LogoutUseCase(mockRepository);
  });

  group('LogoutUseCase', () {
    test('should call repository.logout() once', () async {
      // Arrange
      when(mockRepository.logout()).thenAnswer((_) async => Future.value());

      // Act
      await usecase(NoParams());

      // Assert
      verify(mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate Exception from repository', () async {
      // Arrange
      final exception = ServerException('Network error');
      when(mockRepository.logout()).thenAnswer((_) => Future.error(exception));

      // Act & Assert
      await expectLater(
        usecase(NoParams()),
        throwsA(isA<Failure>()),
      );

      verify(mockRepository.logout()).called(1);
    });

    test('should propagate Failure from repository', () async {
      // Arrange
      final failure = ServerException('Server failure');
      when(mockRepository.logout()).thenAnswer((_) => Future.error(failure));

      // Act & Assert
      await expectLater(
        usecase.call(NoParams()),
        throwsA(isA<ServerException>()),
      );

      verify(mockRepository.logout()).called(1);
    });
  });
}