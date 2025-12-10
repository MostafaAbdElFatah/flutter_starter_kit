import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_starter_kit/features/auth/data/datasources/auth_local_datasource.dart';

import '../../../../helper/helper_test.mocks.dart';


void main() {
  late AuthLocalDataSourceImpl dataSource;
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

  group('Token Management', () {
    const testToken = 'test_auth_token_12345';

    test('saveToken should call secureStorageService.saveToken', () async {
      // Arrange
      when(mockSecureStorageService.saveToken(testToken))
          .thenAnswer((_) async => Future.value());

      // Act
      await dataSource.saveToken(testToken);

      // Assert
      verify(mockSecureStorageService.saveToken(testToken)).called(1);
    });

    test('getToken should return token from secureStorageService', () async {
      // Arrange
      when(mockSecureStorageService.getToken())
          .thenAnswer((_) async => testToken);

      // Act
      final result = await dataSource.getToken();

      // Assert
      expect(result, testToken);
      verify(mockSecureStorageService.getToken()).called(1);
    });

    test('getToken should return null when no token exists', () async {
      // Arrange
      when(mockSecureStorageService.getToken())
          .thenAnswer((_) async => null);

      // Act
      final result = await dataSource.getToken();

      // Assert
      expect(result, isNull);
      verify(mockSecureStorageService.getToken()).called(1);
    });
  });

  group('User Management', () {

    test('saveUser should call storageService.putJson with correct parameters', () async {
      // Arrange
      when(mockStorageService.putJson(
        key: 'auth_user_key',
        value: anyNamed('value'),
      )).thenAnswer((_) async => Future.value());

      // Act
      await dataSource.saveUser(mockUserModel);

      // Assert
      verify(mockStorageService.putJson(
        key: 'auth_user_key',
        value: mockUserModel,
      )).called(1);
    });

    test('getUser should return UserModel from storageService', () {
      // Arrange
      when(mockStorageService.getJson<MockUserModel>(
        key: 'auth_user_key',
        fromJson: anyNamed('fromJson'),
      )).thenReturn(mockUserModel);

      // Act
      final result = dataSource.getUser();

      // Assert
      expect(result, mockUserModel);
      expect(result?.id, mockUserModel.id);
      expect(result?.name, mockUserModel.name);
      expect(result?.email, mockUserModel.email);
      verify(mockStorageService.getJson<MockUserModel>(
        key: 'auth_user_key',
        fromJson: anyNamed('fromJson'),
      )).called(1);
    });

    test('getUser should return null when no user exists', () {
      // Arrange
      when(mockStorageService.getJson<MockUserModel>(
        key: 'auth_user_key',
        fromJson: anyNamed('fromJson'),
      )).thenReturn(null);

      // Act
      final result = dataSource.getUser();

      // Assert
      expect(result, isNull);
      verify( mockStorageService.getJson<MockUserModel>(
        key: 'auth_user_key',
        fromJson: anyNamed('fromJson'),
      )).called(1);
    });

    test('deleteUser should call storageService.delete with correct key', () async {
      // Arrange
      when(mockStorageService.delete(any))
          .thenAnswer((_) async => Future.value());

      // Act
      await dataSource.deleteUser();

      // Assert
      verify(mockStorageService.delete('auth_user_key')).called(1);
    });
  });

  group('Integration Scenarios', () {
    test('should handle complete login flow - save token and user', () async {
      // Arrange
      const token = 'login_token_xyz';
      when(mockSecureStorageService.saveToken(token))
          .thenAnswer((_) async => Future.value());
      when(mockStorageService.putJson(
        key: anyNamed('key'),
        value: anyNamed('value'),
      )).thenAnswer((_) async => Future.value());

      // Act
      await dataSource.saveToken(token);
      await dataSource.saveUser(mockUserModel);

      // Assert
      verify(mockSecureStorageService.saveToken(token)).called(1);
      verify(mockStorageService.putJson(
        key: 'auth_user_key',
        value: mockUserModel,
      )).called(1);
    });

    test('should handle complete logout flow - delete token and user', () async {
      // Arrange
      when(mockSecureStorageService.deleteToken())
          .thenAnswer((_) async => Future.value());
      when(mockStorageService.delete(any))
          .thenAnswer((_) async => Future.value());

      // Act
      await dataSource.deleteUser();

      // Assert
      verify(mockSecureStorageService.deleteToken()).called(1);
      verify(mockStorageService.delete('auth_user_key')).called(1);
    });
  });
}