import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_starter_kit/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_kit/core/infrastructure/domain/usecases/usecase.dart';
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
          .thenReturn(testUser);

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
          .thenReturn(null);

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, isNull);
      verify(mockRepository.getAuthenticatedUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      when(mockRepository.getAuthenticatedUser())
          .thenReturn(null);

      // Act & Assert
      expect(usecase(NoParams()), isNull);
      verify(mockRepository.getAuthenticatedUser()).called(1);
    });
  });
}