import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_starter_kit/core/errors/failure.dart';
import 'package:flutter_starter_kit/core/infrastructure/domain/entities/no_params.dart';
import 'package:flutter_starter_kit/features/auth/domain/usecases/delete_account_usecase.dart';
import '../../../../helper/helper_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late DeleteAccountUseCase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = DeleteAccountUseCase(mockRepository);
  });

  group('DeleteAccountUsecase', () {
    test('should call repository.deleteAccount() once', () async {
      // Arrange
      when(
        mockRepository.deleteAccount(),
      ).thenAnswer((_) async => Future.value());

      // Act
      await usecase(NoParams());

      // Assert
      verify(mockRepository.deleteAccount()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      final exception = ServerException('Network error');
      when(
        mockRepository.deleteAccount(),
      ).thenAnswer((_) => Future.error(exception));

      // Act & Assert
      expect(usecase(NoParams()), throwsA(exception));
      verify(mockRepository.deleteAccount()).called(1);
      expect(usecase(NoParams()), throwsA(isA<Failure>()));
    });
  });
}
