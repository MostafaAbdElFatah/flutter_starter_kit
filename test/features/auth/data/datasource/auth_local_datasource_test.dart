import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_starter_kit/features/auth/data/datasources/auth_local_datasource.dart';
import '../../../../helper/helper_test.mocks.dart';

void main() {
  late AuthLocalDataSource dataSource;
  late MockStorageService mockStorageService;
  late MockSecureStorageService mockSecureStorageService;
  final mockUserModel = MockUserModel();

  setUp(() {
    mockStorageService = MockStorageService();
    mockSecureStorageService = MockSecureStorageService();
    dataSource = AuthLocalDataSourceImpl(
      storageService: mockStorageService,
      secureStorageService: mockSecureStorageService,
    );

    // Default setup
    when(mockUserModel.id).thenReturn('123');
    when(mockUserModel.name).thenReturn('Test User');
    when(mockUserModel.email).thenReturn('test@example.com');
  });

  group('AuthLocalDataSourceImpl -', () {
    group('Token Management', () {
      const testToken = 'test_auth_token_12345';

      test('saveToken should call secureStorageService.saveToken', () async {
        // Arrange
        when(
          mockSecureStorageService.saveToken(testToken),
        ).thenAnswer((_) async => {});

        // Act
        await dataSource.saveToken(testToken);

        // Assert
        verify(mockSecureStorageService.saveToken(testToken)).called(1);
        verifyNoMoreInteractions(mockSecureStorageService);
      });

      test('getToken should return token from secureStorageService', () async {
        // Arrange
        when(
          mockSecureStorageService.getToken(),
        ).thenAnswer((_) async => testToken);

        // Act
        final result = await dataSource.getToken();

        // Assert
        expect(result, testToken);
        verify(mockSecureStorageService.getToken()).called(1);
        verifyNoMoreInteractions(mockSecureStorageService);
      });

      test('getToken should return null when no token exists', () async {
        // Arrange
        when(mockSecureStorageService.getToken()).thenAnswer((_) async => null);

        // Act
        final result = await dataSource.getToken();

        // Assert
        expect(result, isNull);
        verify(mockSecureStorageService.getToken()).called(1);
      });
    });

    group('User Management', () {
      test(
        'saveUser should call storageService.putJson with correct key',
        () async {
          // Arrange
          when(
            mockStorageService.putJson(
              key: anyNamed('key'),
              value: anyNamed('value'),
            ),
          ).thenAnswer((_) async => {});

          // Act
          await dataSource.saveUser(mockUserModel);

          // Assert
          verify(
            mockStorageService.putJson(
              key: 'auth_user_key',
              value: mockUserModel,
            ),
          ).called(1);
          verifyNoMoreInteractions(mockStorageService);
        },
      );

      test('getUser should return UserModel from storageService', () {
        // Arrange
        when(
          mockStorageService.getJson<MockUserModel>(
            key: anyNamed('key'),
            fromJson: anyNamed('fromJson'),
          ),
        ).thenReturn(mockUserModel);

        // Act
        final result = dataSource.getUser();

        // Assert
        expect(result, isNotNull);
        expect(result, mockUserModel);
        expect(result?.id, '123');
        expect(result?.name, 'Test User');
        expect(result?.email, 'test@example.com');
        verify(
          mockStorageService.getJson<MockUserModel>(
            key: 'auth_user_key',
            fromJson: anyNamed('fromJson'),
          ),
        ).called(1);
      });

      test('getUser should return null when no user exists', () {
        // Arrange
        when(
          mockStorageService.getJson<MockUserModel>(
            key: anyNamed('key'),
            fromJson: anyNamed('fromJson'),
          ),
        ).thenReturn(null);

        // Act
        final result = dataSource.getUser();

        // Assert
        expect(result, isNull);
        verify(
          mockStorageService.getJson<MockUserModel>(
            key: 'auth_user_key',
            fromJson: anyNamed('fromJson'),
          ),
        ).called(1);
      });

      test(
        'deleteUser should call storageService.delete with correct key',
        () async {
          // Arrange
          when(mockStorageService.delete(any)).thenAnswer((_) async => {});

          // Act
          await dataSource.deleteUser();

          // Assert
          verify(mockStorageService.delete('auth_user_key')).called(1);
          verifyNoMoreInteractions(mockStorageService);
        },
      );

      test('getUser should use UserModel.fromJson as fromJson callback', () {
        // Arrange
        final capturedFromJson = <Function>[];
        when(
          mockStorageService.getJson<MockUserModel>(
            key: anyNamed('key'),
            fromJson: captureAnyNamed('fromJson'),
          ),
        ).thenAnswer((invocation) {
          capturedFromJson.add(invocation.namedArguments[#fromJson]);
          return mockUserModel;
        });

        // Act
        dataSource.getUser();

        // Assert
        expect(capturedFromJson.length, 1);
        verify(
          mockStorageService.getJson<MockUserModel>(
            key: 'auth_user_key',
            fromJson: anyNamed('fromJson'),
          ),
        ).called(1);
      });
    });

    group('Integration Scenarios', () {
      test('should save both token and user during login', () async {
        // Arrange
        const token = 'login_token_xyz';

        when(
          mockSecureStorageService.saveToken(token),
        ).thenAnswer((_) async => {});
        when(
          mockStorageService.putJson(
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async => {});

        // Act
        await dataSource.saveToken(token);
        await dataSource.saveUser(mockUserModel);

        // Assert
        verify(mockSecureStorageService.saveToken(token)).called(1);
        verify(
          mockStorageService.putJson(
            key: 'auth_user_key',
            value: mockUserModel,
          ),
        ).called(1);
      });

      test(
        'should retrieve both token and user when checking auth state',
        () async {
          // Arrange
          const token = 'stored_token';

          when(
            mockSecureStorageService.getToken(),
          ).thenAnswer((_) async => token);
          when(
            mockStorageService.getJson<MockUserModel>(
              key: anyNamed('key'),
              fromJson: anyNamed('fromJson'),
            ),
          ).thenReturn(mockUserModel);

          // Act
          final retrievedToken = await dataSource.getToken();
          final retrievedUser = dataSource.getUser();

          // Assert
          expect(retrievedToken, token);
          expect(retrievedUser, mockUserModel);
          verify(mockSecureStorageService.getToken()).called(1);
          verify(
            mockStorageService.getJson<MockUserModel>(
              key: 'auth_user_key',
              fromJson: anyNamed('fromJson'),
            ),
          ).called(1);
        },
      );
    });

    group('Integration Scenarios', () {
      test(
        'should handle complete logout flow - delete both token and user delete user',
        () async {
          // Arrange
          when(
            mockSecureStorageService.deleteToken(),
          ).thenAnswer((_) async => {});
          when(mockStorageService.delete(any)).thenAnswer((_) async => {});

          // Act
          await dataSource.deleteUser();

          // Assert
          verify(mockStorageService.delete('auth_user_key')).called(1);
          verifyNoMoreInteractions(mockStorageService);
          verify(mockSecureStorageService.deleteToken()).called(1);
          verifyNoMoreInteractions(mockSecureStorageService);
        },
      );
    });
    group('Edge Cases', () {
      test('should handle empty string token', () async {
        // Arrange
        const emptyToken = '';
        when(
          mockSecureStorageService.saveToken(emptyToken),
        ).thenAnswer((_) async => {});

        // Act
        await dataSource.saveToken(emptyToken);

        // Assert
        verify(mockSecureStorageService.saveToken(emptyToken)).called(1);
      });

      test('should handle very long token string', () async {
        // Arrange
        final longToken = 'a' * 1000;
        when(
          mockSecureStorageService.saveToken(longToken),
        ).thenAnswer((_) async => {});

        // Act
        await dataSource.saveToken(longToken);

        // Assert
        verify(mockSecureStorageService.saveToken(longToken)).called(1);
      });

      test('should propagate exceptions from secureStorageService', () async {
        // Arrange
        when(
          mockSecureStorageService.getToken(),
        ).thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(() => dataSource.getToken(), throwsException);
      });

      test('should propagate exceptions from storageService', () async {
        // Arrange
        when(
          mockStorageService.delete(any),
        ).thenThrow(Exception('Delete error'));

        // Act & Assert
        expect(() => dataSource.deleteUser(), throwsException);
      });
    });
  });
}
