import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_starter_kit/core/infrastructure/usecases/usecase.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/is_logged_in_usecase.dart';
import '../../../../helper/helper_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late IsLoggedInUseCase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = IsLoggedInUseCase(mockRepository);
  });

  group('IsLoggedInUseCase', () {
    test(
      'should return true when repository indicates user is logged in',
      () async {
        // Arrange
        when(mockRepository.isLoggedIn()).thenAnswer((_) async => true);

        // Act
        final result = await usecase(NoParams());

        // Assert
        expect(result, isTrue);
        verify(mockRepository.isLoggedIn()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return false when repository indicates user is not logged in',
      () async {
        // Arrange
        when(mockRepository.isLoggedIn()).thenAnswer((_) async => false);

        // Act
        final result = await usecase.call(NoParams());

        // Assert
        expect(result, isFalse);
        verify(mockRepository.isLoggedIn()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
