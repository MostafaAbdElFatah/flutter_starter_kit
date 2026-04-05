import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_starter_kit/core/infrastructure/data/errors/failure.dart';
import 'package:flutter_starter_kit/core/services/device_services.dart';
import 'package:flutter_starter_kit/core/utils/log.dart';
import 'package:flutter_starter_kit/features/auth/data/models/login_user_model.dart';
import 'package:flutter_starter_kit/features/auth/data/models/user_model.dart';
import 'package:flutter_starter_kit/features/auth/data/repository/auth_repository.dart';
import 'package:flutter_starter_kit/features/auth/domain/entities/login_credentials.dart';
import 'package:flutter_starter_kit/features/auth/domain/entities/register_credentials.dart';
import 'package:flutter_starter_kit/features/auth/domain/entities/user.dart';

import '../../../../helper/helper_test.mocks.dart';

class _FakeDeviceServices implements DeviceServices {
  String? deviceModel;
  Object? throwable;
  int getDeviceModelCallCount = 0;

  @override
  Future<String?> getDeviceModel() async {
    getDeviceModelCallCount++;

    if (throwable != null) {
      throw throwable!;
    }

    return deviceModel;
  }
}

void main() {
  Log.overrideShouldDebugForTests = true;

  late AuthRepositoryImpl repository;
  late _FakeDeviceServices mockDeviceServices;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockDeviceServices = _FakeDeviceServices();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockRemoteDataSource = MockAuthRemoteDataSource();

    repository = AuthRepositoryImpl(
      deviceServices: mockDeviceServices,
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('isLoggedIn', () {
    test('should return true when a non-empty token exists', () async {
      when(
        mockLocalDataSource.getToken(),
      ).thenAnswer((_) async => 'valid_token');

      final result = await repository.isLoggedIn();

      expect(result, true);
      verify(mockLocalDataSource.getToken()).called(1);
      verifyNever(mockLocalDataSource.getUser());
    });

    test('should return false when token is null', () async {
      when(mockLocalDataSource.getToken()).thenAnswer((_) async => null);

      final result = await repository.isLoggedIn();

      expect(result, false);
      verify(mockLocalDataSource.getToken()).called(1);
      verifyNever(mockLocalDataSource.getUser());
    });

    test('should return false when token is empty', () async {
      when(mockLocalDataSource.getToken()).thenAnswer((_) async => '');

      final result = await repository.isLoggedIn();

      expect(result, false);
      verify(mockLocalDataSource.getToken()).called(1);
      verifyNever(mockLocalDataSource.getUser());
    });

    test('should return false if token lookup throws', () async {
      when(mockLocalDataSource.getToken()).thenThrow(Exception('Error'));

      final result = await repository.isLoggedIn();

      expect(result, false);
      verify(mockLocalDataSource.getToken()).called(1);
      verifyNever(mockLocalDataSource.getUser());
    });
  });

  group('getAuthenticatedUser', () {
    test('should return the cached user as an entity', () {
      final mockUser = UserModel(
        id: '1',
        email: 'test@test.com',
        name: 'Test User',
        isVerified: true,
      );
      when(mockLocalDataSource.getUser()).thenReturn(mockUser);

      final result = repository.getAuthenticatedUser();

      expect(result, isNotNull);
      expect(result, isA<User>());
      expect(result?.id, '1');
      expect(result?.email, 'test@test.com');
      expect(result?.name, 'Test User');
      verify(mockLocalDataSource.getUser()).called(1);
      verifyNever(mockLocalDataSource.getToken());
    });

    test('should return null when no cached user exists', () {
      when(mockLocalDataSource.getUser()).thenReturn(null);

      final result = repository.getAuthenticatedUser();

      expect(result, isNull);
      verify(mockLocalDataSource.getUser()).called(1);
      verifyNever(mockLocalDataSource.getToken());
    });

    test('should propagate errors from the local datasource', () {
      when(mockLocalDataSource.getUser()).thenThrow(Exception('Error'));

      expect(() => repository.getAuthenticatedUser(), throwsException);
      verify(mockLocalDataSource.getUser()).called(1);
      verifyNever(mockLocalDataSource.getToken());
    });
  });

  group('login', () {
    test(
      'should successfully login and cache the authenticated user',
      () async {
        final credentials = LoginCredentials(
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
        final mockLoginUser = LoginUserModel(
          token: 'auth_token',
          user: mockUserModel,
        );

        mockDeviceServices.deviceModel = deviceName;
        when(
          mockRemoteDataSource.login(any),
        ).thenAnswer((_) async => mockLoginUser);
        when(
          mockLocalDataSource.saveToken('auth_token'),
        ).thenAnswer((_) async {});
        when(
          mockLocalDataSource.saveUser(mockUserModel),
        ).thenAnswer((_) async {});

        final result = await repository.login(credentials);

        final verification = verify(mockRemoteDataSource.login(captureAny));
        final capturedCredentials =
            verification.captured.single as LoginCredentials;

        expect(result, isA<User>());
        expect(result.id, '1');
        expect(result.email, 'test@example.com');
        expect(capturedCredentials.email, credentials.email);
        expect(capturedCredentials.password, credentials.password);
        expect(capturedCredentials.deviceName, deviceName);
        expect(mockDeviceServices.getDeviceModelCallCount, 1);
        verification.called(1);
        verify(mockLocalDataSource.saveToken('auth_token')).called(1);
        verify(mockLocalDataSource.saveUser(mockUserModel)).called(1);
      },
    );

    test('should throw Failure when login fails', () async {
      final credentials = LoginCredentials(
        email: 'test@example.com',
        password: 'wrong_password',
      );
      const deviceName = 'iPhone 15';

      mockDeviceServices.deviceModel = deviceName;
      when(
        mockRemoteDataSource.login(any),
      ).thenThrow(const ServerException('Invalid credentials'));

      await expectLater(repository.login(credentials), throwsA(isA<Failure>()));

      expect(mockDeviceServices.getDeviceModelCallCount, 1);
      verify(mockRemoteDataSource.login(any)).called(1);
      verifyNever(mockLocalDataSource.saveToken(any));
      verifyNever(mockLocalDataSource.saveUser(any));
    });
  });

  group('register', () {
    test(
      'should successfully register and cache the authenticated user',
      () async {
        const credentials = RegisterCredentials(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        );
        final mockUserModel = UserModel(
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          isVerified: true,
        );
        final mockLoginUser = LoginUserModel(
          token: 'auth_token',
          user: mockUserModel,
        );

        when(
          mockRemoteDataSource.register(credentials),
        ).thenAnswer((_) async => mockLoginUser);
        when(
          mockLocalDataSource.saveToken('auth_token'),
        ).thenAnswer((_) async {});
        when(
          mockLocalDataSource.saveUser(mockUserModel),
        ).thenAnswer((_) async {});

        final result = await repository.register(credentials);

        expect(result, isA<User>());
        expect(result.id, '1');
        expect(result.email, 'test@example.com');
        expect(mockDeviceServices.getDeviceModelCallCount, 0);
        verify(mockRemoteDataSource.register(credentials)).called(1);
        verify(mockLocalDataSource.saveToken('auth_token')).called(1);
        verify(mockLocalDataSource.saveUser(mockUserModel)).called(1);
      },
    );

    test('should throw Failure when registration fails', () async {
      const credentials = RegisterCredentials(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
      );

      when(
        mockRemoteDataSource.register(credentials),
      ).thenThrow(const ServerException('Email already exists'));

      await expectLater(
        repository.register(credentials),
        throwsA(isA<Failure>()),
      );

      expect(mockDeviceServices.getDeviceModelCallCount, 0);
      verify(mockRemoteDataSource.register(credentials)).called(1);
      verifyNever(mockLocalDataSource.saveToken(any));
      verifyNever(mockLocalDataSource.saveUser(any));
    });
  });

  group('logout', () {
    test('should logout from server and clear local data', () async {
      when(mockRemoteDataSource.logout()).thenAnswer((_) async {});
      when(mockLocalDataSource.deleteUser()).thenAnswer((_) async {});

      await repository.logout();

      verify(mockRemoteDataSource.logout()).called(1);
      verify(mockLocalDataSource.deleteUser()).called(1);
    });

    test('should clear local data even when server logout fails', () async {
      when(
        mockRemoteDataSource.logout(),
      ).thenThrow(const ServerException('Network error'));
      when(mockLocalDataSource.deleteUser()).thenAnswer((_) async {});

      await expectLater(repository.logout(), throwsA(isA<Failure>()));

      verify(mockRemoteDataSource.logout()).called(1);
      verify(mockLocalDataSource.deleteUser()).called(1);
    });
  });

  group('deleteAccount', () {
    test('should delete account from server and clear local data', () async {
      when(mockRemoteDataSource.deleteAccount()).thenAnswer((_) async {});
      when(mockLocalDataSource.deleteUser()).thenAnswer((_) async {});

      await repository.deleteAccount();

      verify(mockRemoteDataSource.deleteAccount()).called(1);
      verify(mockLocalDataSource.deleteUser()).called(1);
    });

    test('should not clear local data when server delete fails', () async {
      when(
        mockRemoteDataSource.deleteAccount(),
      ).thenThrow(const ServerException('Network error'));
      when(mockLocalDataSource.deleteUser()).thenAnswer((_) async {});

      await expectLater(repository.deleteAccount(), throwsA(isA<Failure>()));

      verify(mockRemoteDataSource.deleteAccount()).called(1);
      verifyNever(mockLocalDataSource.deleteUser());
    });
  });
}
