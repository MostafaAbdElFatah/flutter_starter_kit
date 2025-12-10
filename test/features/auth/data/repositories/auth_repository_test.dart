import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_starter_kit/features/auth/domain/entities/user.dart';
import 'package:flutter_starter_kit/features/auth/data/models/responses/login_response.dart';
import 'package:flutter_starter_kit/features/auth/data/models/user.dart';
import 'package:flutter_starter_kit/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_starter_kit/features/auth/domain/entities/login_credentials.dart';
import 'package:flutter_starter_kit/features/auth/domain/entities/register_credentials.dart';
import 'package:flutter_starter_kit/core/errors/failure.dart';
import 'package:flutter_starter_kit/core/utils/log.dart';
import '../../../../helper/helper_test.mocks.dart';

// Generate mocks for all dependencies.

void main() {
  Log.overrideShouldDebugForTests = true;

  late AuthRepositoryImpl repository;
  late MockDeviceServices mockDeviceServices;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockDeviceServices = MockDeviceServices();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockRemoteDataSource = MockAuthRemoteDataSource();

    repository = AuthRepositoryImpl(
      deviceServices: mockDeviceServices,
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('isLoggedIn', () {
    test('should return true when token and verified user exist', () async {
      // Arrange
      final mockUser = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        isVerified: true,
      );
      when(
        mockLocalDataSource.getToken(),
      ).thenAnswer((_) async => 'valid_token');
      when(mockLocalDataSource.getUser()).thenReturn(mockUser);

      // Act
      final result = await repository.isLoggedIn();

      // Assert
      expect(result, true);
      verify(mockLocalDataSource.getToken()).called(1);
      verify(mockLocalDataSource.getUser()).called(1);
    });

    test('should return false when token is null', () async {
      // Arrange
      final mockUser = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        isVerified: true,
      );
      when(mockLocalDataSource.getToken()).thenAnswer((_) async => null);
      when(mockLocalDataSource.getUser()).thenReturn(mockUser);

      // Act
      final result = await repository.isLoggedIn();

      // Assert
      expect(result, false);
    });

    test('should return false when token is empty', () async {
      // Arrange
      final mockUser = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        isVerified: true,
      );
      when(mockLocalDataSource.getToken()).thenAnswer((_) async => '');
      when(mockLocalDataSource.getUser()).thenReturn(mockUser);

      // Act
      final result = await repository.isLoggedIn();

      // Assert
      expect(result, false);
    });

    test('should return false when user is null', () async {
      // Arrange
      when(
        mockLocalDataSource.getToken(),
      ).thenAnswer((_) async => 'valid_token');
      when(mockLocalDataSource.getUser()).thenReturn(null);

      // Act
      final result = await repository.isLoggedIn();

      // Assert
      expect(result, false);
    });

    test('should return false when user is not verified', () async {
      // Arrange
      final mockUser = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        isVerified: false,
      );
      when(
        mockLocalDataSource.getToken(),
      ).thenAnswer((_) async => 'valid_token');
      when(mockLocalDataSource.getUser()).thenReturn(mockUser);

      // Act
      final result = await repository.isLoggedIn();

      // Assert
      expect(result, false);
    });

    test('should return false if exception occurs', () async {
      when(mockLocalDataSource.getToken())
          .thenThrow(Exception('Error'));
      when(mockLocalDataSource.getUser())
          .thenThrow(Exception('Error'));

      final result = await repository.isLoggedIn();

      expect(result, false);
    });

  });

  group('getAuthenticatedUser', () {
    test('should return user when logged in', () async {
      // Arrange
      final mockUser = UserModel(
        id: '1',
        email: 'test@test.com',
        isVerified: true,
      );
      when(mockLocalDataSource.getUser()).thenReturn(mockUser);
      when(
        mockLocalDataSource.getToken(),
      ).thenAnswer((_) async => 'valid_token');

      // Act
      final result = await repository.getAuthenticatedUser();

      // Assert
      expect(result, isNotNull);
      expect(result?.id, '1');
      expect(result?.email, 'test@test.com');
    });

    test('should return null when not logged in', () async {
      // Arrange
      when(mockLocalDataSource.getUser()).thenReturn(null);
      when(mockLocalDataSource.getToken()).thenAnswer((_) async => null);

      // Act
      final result = await repository.getAuthenticatedUser();

      // Assert
      expect(result, isNull);
    });

    test('should return null on error', () async {
      // Arrange
      when(mockLocalDataSource.getUser()).thenThrow(Exception('Error'));
      when(
        mockLocalDataSource.getToken(),
      ).thenAnswer((_) async => 'valid_token');

      // Act
      final result = await repository.getAuthenticatedUser();

      // Assert
      expect(result, isNull);
    });
  });

  group('login', () {
    test('should successfully login and return user', () async {
      // Arrange
      const credentials = LoginCredentials(
        email: 'test@example.com',
        password: 'password123',
      );
      const deviceName = 'iPhone 15';
      final mockUserModel = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        isVerified: true,
      );
      final mockLoginUser = LoginUser(token: 'auth_token', user: mockUserModel);

      when(
        mockDeviceServices.getDeviceModel(),
      ).thenAnswer((_) async => deviceName);
      when(
        mockRemoteDataSource.login(any),
      ).thenAnswer((_) async => mockLoginUser);
      when(mockLocalDataSource.saveToken(any)).thenAnswer((_) async => {});
      when(mockLocalDataSource.saveUser(any)).thenAnswer((_) async => {});

      // Act
      final result = await repository.login(credentials);

      // Assert
      expect(result, isA<User>());
      verify(mockDeviceServices.getDeviceModel()).called(1);
      verify(mockRemoteDataSource.login(any)).called(1);
      verify(mockLocalDataSource.saveToken('auth_token')).called(1);
      verify(mockLocalDataSource.saveUser(mockUserModel)).called(1);
    });

    test('should throw Failure when login fails', () async {
      // Arrange
      const credentials = LoginCredentials(
        email: 'test@example.com',
        password: 'wrong_password',
      );
      const deviceName = 'iPhone 15';

      when(
        mockDeviceServices.getDeviceModel(),
      ).thenAnswer((_) async => deviceName);
      when(
        mockRemoteDataSource.login(any),
      ).thenThrow(ServerException('Invalid credentials'));

      // Act & Assert
      expect(repository.login(credentials), throwsA(isA<Failure>()));
    });
  });

  group('register', () {
    test('should successfully register and return user', () async {
      // Arrange
      const credentials = RegisterCredentials(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
      );
      const deviceName = 'iPhone 15';
      final mockUserModel = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        isVerified: true,
      );
      final mockLoginUser = LoginUser(token: 'auth_token', user: mockUserModel);

      when(
        mockDeviceServices.getDeviceModel(),
      ).thenAnswer((_) async => deviceName);
      when(
        mockRemoteDataSource.register(any),
      ).thenAnswer((_) async => mockLoginUser);
      when(mockLocalDataSource.saveToken(any)).thenAnswer((_) async => {});
      when(mockLocalDataSource.saveUser(any)).thenAnswer((_) async => {});

      // Act
      final result = await repository.register(credentials);

      // Assert
      expect(result, isA<User>());
      verify(mockDeviceServices.getDeviceModel()).called(1);
      verify(mockRemoteDataSource.register(any)).called(1);
      verify(mockLocalDataSource.saveToken('auth_token')).called(1);
      verify(mockLocalDataSource.saveUser(mockUserModel)).called(1);
    });

    test('should throw Failure when registration fails', () async {
      // Arrange
      const credentials = RegisterCredentials(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
      );
      const deviceName = 'iPhone 15';

      when(
        mockDeviceServices.getDeviceModel(),
      ).thenAnswer((_) async => deviceName);
      when(
        mockRemoteDataSource.register(any),
      ).thenThrow(ServerException('Email already exists'));

      // Act & Assert
      expect(repository.register(credentials), throwsA(isA<Failure>()));
    });
  });

  group('logout', () {
    test('should logout from server and clear local data', () async {
      // Arrange
      when(mockRemoteDataSource.logout()).thenAnswer((_) async => {});
      when(mockLocalDataSource.deleteUser()).thenAnswer((_) async => {});

      // Act
      await repository.logout();

      // Assert
      verify(mockRemoteDataSource.logout()).called(1);
      verify(mockLocalDataSource.deleteUser()).called(1);
    });

    test('should clear local data even when server logout fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.logout(),
      ).thenThrow(ServerException('Network error'));
      when(mockLocalDataSource.deleteUser()).thenAnswer((_) async => {});

      // Act & Assert
      expect(repository.logout(), throwsA(isA<Failure>()));
      verify(mockRemoteDataSource.logout()).called(1);
      verify(mockLocalDataSource.deleteUser()).called(1);
    });
  });

  group('deleteAccount', () {
    test('should delete account from server and clear local data', () async {
      // Arrange
      when(mockRemoteDataSource.deleteAccount()).thenAnswer((_) async => {});
      when(mockLocalDataSource.deleteUser()).thenAnswer((_) async => {});

      // Act
      await repository.deleteAccount();

      // Assert
      verify(mockRemoteDataSource.deleteAccount()).called(1);
      verify(mockLocalDataSource.deleteUser()).called(1);
    });

    test('should clear local data even when server delete fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.deleteAccount(),
      ).thenThrow(ServerException('Network error'));

      when(mockLocalDataSource.deleteUser()).thenAnswer((_) async => {});

      // Act & Assert
      expect(repository.deleteAccount(), throwsA(isA<Failure>()));
      verify(mockRemoteDataSource.deleteAccount()).called(1);
      verifyNever(mockLocalDataSource.deleteUser());
    });
  });
}
