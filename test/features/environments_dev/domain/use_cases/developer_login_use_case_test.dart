import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/use_cases/developer_login_usecase.dart';

import '../../../../helper/helper_test.mocks.dart';

void main() {
  late DeveloperLoginUseCase useCase;
  late MockEnvironmentRepository mockRepository;

  setUp(() {
    mockRepository = MockEnvironmentRepository();
    useCase = DeveloperLoginUseCase(mockRepository);
  });

  group('DeveloperLoginUseCase', () {
    const tUsername = 'dev_user';
    const tPassword = 'dev_password';
    const tParams = DevLoginParams(username: tUsername, password: tPassword);

    test('should return true when credentials are correct', () {
      // arrange
      when(mockRepository.loginAsDeveloper(tParams)).thenReturn(true);

      // act
      final result = useCase(tParams);

      // assert
      expect(result, isTrue);
      verify(mockRepository.loginAsDeveloper(tParams));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return false when username is incorrect', () {
      // arrange
      const tWrongParams = DevLoginParams(
        username: 'wrong_user',
        password: tPassword,
      );

      when(mockRepository.loginAsDeveloper(tWrongParams)).thenReturn(false);

      // act
      final result = useCase(tWrongParams);

      // assert
      expect(result, isFalse);
      verify(mockRepository.loginAsDeveloper(tWrongParams));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return false when password is incorrect', () {
      // arrange
      const tWrongParams = DevLoginParams(
        username: tUsername,
        password: 'wrong_password',
      );

      when(mockRepository.loginAsDeveloper(tWrongParams)).thenReturn(false);

      // act
      final result = useCase(tWrongParams);

      // assert
      expect(result, isFalse);
      verify(mockRepository.loginAsDeveloper(tWrongParams));
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return false when both username and password are incorrect',
      () {
        // arrange
        const tWrongParams = DevLoginParams(
          username: 'wrong_user',
          password: 'wrong_password',
        );

        when(mockRepository.loginAsDeveloper(tWrongParams)).thenReturn(false);

        // act
        final result = useCase(tWrongParams);

        // assert
        expect(result, isFalse);
        verify(mockRepository.loginAsDeveloper(tWrongParams));
      },
    );

    test('should handle empty credentials', () {
      // arrange
      const tEmptyParams = DevLoginParams(username: '', password: '');

      when(mockRepository.loginAsDeveloper(tEmptyParams)).thenReturn(false);

      // act
      final result = useCase(tEmptyParams);

      // assert
      expect(result, isFalse);
      verify(mockRepository.loginAsDeveloper(tEmptyParams));
    });

    test('should handle whitespace-only credentials', () {
      // arrange
      const tWhitespaceParams = DevLoginParams(
        username: '   ',
        password: '   ',
      );

      when(
        mockRepository.loginAsDeveloper(tWhitespaceParams),
      ).thenReturn(false);

      // act
      final result = useCase(tWhitespaceParams);

      // assert
      expect(result, isFalse);
    });

    test('should call repository exactly once', () {
      // arrange
      when(mockRepository.loginAsDeveloper(tParams)).thenReturn(true);

      // act
      useCase(tParams);

      // assert
      verify(mockRepository.loginAsDeveloper(tParams)).called(1);
    });

    test('should work with special characters in credentials', () {
      // arrange
      const tSpecialParams = DevLoginParams(
        username: 'user@123',
        password: 'p@ss#w0rd!',
      );

      when(mockRepository.loginAsDeveloper(tSpecialParams)).thenReturn(true);

      // act
      final result = useCase(tSpecialParams);

      // assert
      expect(result, isTrue);
      verify(mockRepository.loginAsDeveloper(tSpecialParams));
    });
  });

  group('DevLoginParams', () {
    test('should support value equality', () {
      // arrange
      const params1 = DevLoginParams(username: 'user', password: 'pass');
      const params2 = DevLoginParams(username: 'user', password: 'pass');

      // assert
      expect(params1, equals(params2));
    });

    test('should not be equal when username differs', () {
      // arrange
      const params1 = DevLoginParams(username: 'user1', password: 'pass');
      const params2 = DevLoginParams(username: 'user2', password: 'pass');

      // assert
      expect(params1, isNot(equals(params2)));
    });

    test('should not be equal when password differs', () {
      // arrange
      const params1 = DevLoginParams(username: 'user', password: 'pass1');
      const params2 = DevLoginParams(username: 'user', password: 'pass2');

      // assert
      expect(params1, isNot(equals(params2)));
    });

    test('should have same hashCode for equal objects', () {
      // arrange
      const params1 = DevLoginParams(username: 'user', password: 'pass');
      const params2 = DevLoginParams(username: 'user', password: 'pass');

      // assert
      expect(params1.hashCode, equals(params2.hashCode));
    });

    test('props should contain username and password', () {
      // arrange
      const params = DevLoginParams(username: 'user', password: 'pass');

      // assert
      expect(params.props, equals(['user', 'pass']));
    });
  });
}
