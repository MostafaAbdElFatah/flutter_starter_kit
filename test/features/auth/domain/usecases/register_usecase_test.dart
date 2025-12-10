import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_starter_kit/core/errors/exceptions.dart';
import 'package:flutter_starter_kit/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_kit/features/auth/domain/entities/register_credentials.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/register_usecase.dart';
import '../../../../helper/helper_test.mocks.dart';


void main() {
  late MockAuthRepository mockRepository;
  late RegisterUseCase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUseCase(mockRepository);
  });

  final testCredentials = RegisterCredentials(
    name: 'John Doe',
    email: 'test@mail.com',
    password: 'password123',
  );

  final testUser = User(
    id: '123',
    name: 'John Doe',
    email: 'test@mail.com',
    isVerified: true,
  );

  group('RegisterUseCase', () {
    test('should return User when registration is successful', () async {
      // Arrange
      when(mockRepository.register(testCredentials))
          .thenAnswer((_) async => testUser);

      // Act
      final result = await usecase.call(testCredentials);

      // Assert
      expect(result, equals(testUser));
      verify(mockRepository.register(testCredentials)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate Exception thrown by repository', () async {
      // Arrange
      final exception = ServerException('Network error');
      when(mockRepository.register(testCredentials))
          .thenAnswer((_) => Future.error(exception));

      // Act & Assert
      await expectLater(
        usecase.call(testCredentials),
        throwsA(isA<ServerException>()),
      );

      verify(mockRepository.register(testCredentials)).called(1);
    });

    test('should propagate Failure thrown by repository', () async {
      // Arrange
      final failure = ServerException('Server failure');
      when(mockRepository.register(testCredentials))
          .thenAnswer((_) => Future.error(failure));

      // Act & Assert
      await expectLater(
        usecase.call(testCredentials),
        throwsA(isA<ServerException>()),
      );

      verify(mockRepository.register(testCredentials)).called(1);
    });
  });
}