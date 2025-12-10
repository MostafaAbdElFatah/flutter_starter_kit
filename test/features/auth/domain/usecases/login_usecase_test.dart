import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_starter_kit/core/errors/exceptions.dart';
import 'package:flutter_starter_kit/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_starter_kit/features/auth/domain/entities/login_credentials.dart';
import '../../../../helper/helper_test.mocks.dart';


void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUseCase(mockRepository);
  });

  final testCredentials = LoginCredentials(
    email: 'test@mail.com',
    password: 'password123',
  );

  final testUser = User(
    id: '123',
    name: 'John Doe',
    email: 'test@mail.com',
    isVerified: true,
  );

  group('LoginUseCase', () {
    test('should return User when login is successful', () async {
      // Arrange
      when(mockRepository.login(testCredentials))
          .thenAnswer((_) async => testUser);

      // Act
      final result = await usecase(testCredentials);

      // Assert
      expect(result, equals(testUser));
      verify(mockRepository.login(testCredentials)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate Exception thrown by repository', () async {
      // Arrange
      final exception = Exception('Network error');
      when(mockRepository.login(testCredentials))
          .thenAnswer((_) => Future.error(exception));

      // Act & Assert
      await expectLater(
        usecase.call(testCredentials),
        throwsA(isA<Exception>()),
      );

      verify(mockRepository.login(testCredentials)).called(1);
    });

    test('should propagate Failure thrown by repository', () async {
      // Arrange
      final failure = ServerException('Server failure');
      when(mockRepository.login(testCredentials))
          .thenAnswer((_) => Future.error(failure));

      // Act & Assert
      await expectLater(
        usecase.call(testCredentials),
        throwsA(isA<ServerException>()),
      );

      verify(mockRepository.login(testCredentials)).called(1);
    });
  });
}