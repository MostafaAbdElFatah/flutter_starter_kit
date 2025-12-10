import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_starter_kit/core/errors/failure.dart';
import 'package:flutter_starter_kit/core/infrastructure/domain/entities/no_params.dart';
import 'package:flutter_starter_kit/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/get_authenticated_user_usecase.dart';
import '../../../../helper/helper_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late GetAuthenticatedUserUseCase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = GetAuthenticatedUserUseCase(mockRepository);
  });

  final testUser = User(
    id: '12345',
    name: 'John Doe',
    email: 'john@mail.com',
    isVerified: true,
  );

  group('GetAuthenticatedUserUseCase', () {
    test('should return the authenticated user if repository returns a user', () async {
      // Arrange
      when(mockRepository.getAuthenticatedUser())
          .thenAnswer((_) async => testUser);

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, equals(testUser));
      verify(mockRepository.getAuthenticatedUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return null if no authenticated user', () async {
      // Arrange
      when(mockRepository.getAuthenticatedUser())
          .thenAnswer((_) async => null);

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, isNull);
      verify(mockRepository.getAuthenticatedUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      final exception = ServerException('Server failure');
      when(mockRepository.getAuthenticatedUser())
          .thenAnswer((_) => Future.error(exception));

      // Act & Assert
      expect(usecase(NoParams()), throwsA(exception));
      verify(mockRepository.getAuthenticatedUser()).called(1);
      expect(usecase(NoParams()), throwsA(isA<Failure>()));
    });

    test('should propagate Failure from repository', () async {
      // Arrange
      final exception = CacheException('Cache error');
      when(mockRepository.getAuthenticatedUser())
          .thenAnswer((_) => Future.error(exception));

      // Act & Assert
      expect(usecase(NoParams()), throwsA(exception));
      verify(mockRepository.getAuthenticatedUser()).called(1);
    });
  });
}