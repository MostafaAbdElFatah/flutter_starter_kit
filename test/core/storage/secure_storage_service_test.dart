// secure_storage_service_impl_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/storage/secure_storage_service.dart';

import 'secure_storage_service_test.mocks.dart';


@GenerateMocks([FlutterSecureStorage])
void main() {
  late MockFlutterSecureStorage mockStorage;
  late SecureStorageServiceImpl service;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = SecureStorageServiceImpl(mockStorage);
  });

  group('SecureStorageServiceImpl', () {
    group('write', () {
      test('should call storage.write with correct key and value', () async {
        // Arrange
        const key = 'test_key';
        const value = 'test_value';
        when(mockStorage.write(key: key, value: value))
            .thenAnswer((_) async => {});

        // Act
        await service.write(key: key, value: value);

        // Assert
        verify(mockStorage.write(key: key, value: value)).called(1);
      });
    });

    group('read', () {
      test('should return value when key exists', () async {
        // Arrange
        const key = 'test_key';
        const value = 'test_value';
        when(mockStorage.read(key: key)).thenAnswer((_) async => value);

        // Act
        final result = await service.read(key: key);

        // Assert
        expect(result, equals(value));
        verify(mockStorage.read(key: key)).called(1);
      });

      test('should return null when key does not exist', () async {
        // Arrange
        const key = 'non_existent_key';
        when(mockStorage.read(key: key)).thenAnswer((_) async => null);

        // Act
        final result = await service.read(key: key);

        // Assert
        expect(result, isNull);
        verify(mockStorage.read(key: key)).called(1);
      });
    });

    group('delete', () {
      test('should call storage.delete with correct key', () async {
        // Arrange
        const key = 'test_key';
        when(mockStorage.delete(key: key)).thenAnswer((_) async => {});

        // Act
        await service.delete(key: key);

        // Assert
        verify(mockStorage.delete(key: key)).called(1);
      });
    });

    group('deleteAll', () {
      test('should call storage.deleteAll', () async {
        // Arrange
        when(mockStorage.deleteAll()).thenAnswer((_) async => {});

        // Act
        await service.deleteAll();

        // Assert
        verify(mockStorage.deleteAll()).called(1);
      });
    });

    group('deleteToken', () {
      test('should delete token with correct key', () async {
        // Arrange
        const tokenKey = 'auth_user_token';
        when(mockStorage.delete(key: tokenKey)).thenAnswer((_) async => {});

        // Act
        await service.deleteToken();

        // Assert
        verify(mockStorage.delete(key: tokenKey)).called(1);
      });
    });

    group('saveToken', () {
      test('should encode and save token correctly', () async {
        // Arrange
        const token = 'my_secret_token_123';
        final tokenBytes = utf8.encode(token);
        final expectedEncodedToken = base64UrlEncode(tokenBytes);
        const tokenKey = 'auth_user_token';

        when(mockStorage.write(key: tokenKey, value: expectedEncodedToken))
            .thenAnswer((_) async => {});

        // Act
        await service.saveToken(token);

        // Assert
        verify(mockStorage.write(key: tokenKey, value: expectedEncodedToken))
            .called(1);
      });

      test('should handle special characters in token', () async {
        // Arrange
        const token = 'token_with_special_chars!@#\$%^&*()';
        final tokenBytes = utf8.encode(token);
        final expectedEncodedToken = base64UrlEncode(tokenBytes);
        const tokenKey = 'auth_user_token';

        when(mockStorage.write(key: tokenKey, value: expectedEncodedToken))
            .thenAnswer((_) async => {});

        // Act
        await service.saveToken(token);

        // Assert
        verify(mockStorage.write(key: tokenKey, value: expectedEncodedToken))
            .called(1);
      });

      test('should handle empty token', () async {
        // Arrange
        const token = '';
        final tokenBytes = utf8.encode(token);
        final expectedEncodedToken = base64UrlEncode(tokenBytes);
        const tokenKey = 'auth_user_token';

        when(mockStorage.write(key: tokenKey, value: expectedEncodedToken))
            .thenAnswer((_) async => {});

        // Act
        await service.saveToken(token);

        // Assert
        verify(mockStorage.write(key: tokenKey, value: expectedEncodedToken))
            .called(1);
      });
    });

    group('getToken', () {
      test('should decode and return token correctly', () async {
        // Arrange
        const originalToken = 'my_secret_token_123';
        final tokenBytes = utf8.encode(originalToken);
        final encodedToken = base64UrlEncode(tokenBytes);
        const tokenKey = 'auth_user_token';

        when(mockStorage.read(key: tokenKey))
            .thenAnswer((_) async => encodedToken);

        // Act
        final result = await service.getToken();

        // Assert
        expect(result, equals(originalToken));
        verify(mockStorage.read(key: tokenKey)).called(1);
      });

      test('should return null when no token exists', () async {
        // Arrange
        const tokenKey = 'auth_user_token';
        when(mockStorage.read(key: tokenKey)).thenAnswer((_) async => null);

        // Act
        final result = await service.getToken();

        // Assert
        expect(result, isNull);
        verify(mockStorage.read(key: tokenKey)).called(1);
      });

      test('should handle special characters in decoded token', () async {
        // Arrange
        const originalToken = 'token_with_special_chars!@#\$%^&*()';
        final tokenBytes = utf8.encode(originalToken);
        final encodedToken = base64UrlEncode(tokenBytes);
        const tokenKey = 'auth_user_token';

        when(mockStorage.read(key: tokenKey))
            .thenAnswer((_) async => encodedToken);

        // Act
        final result = await service.getToken();

        // Assert
        expect(result, equals(originalToken));
        verify(mockStorage.read(key: tokenKey)).called(1);
      });
    });

    group('saveToken and getToken integration', () {
      test('should correctly encode and decode the same token', () async {
        // Arrange
        const originalToken = 'integration_test_token_456';
        final tokenBytes = utf8.encode(originalToken);
        final encodedToken = base64UrlEncode(tokenBytes);
        const tokenKey = 'auth_user_token';

        when(mockStorage.write(key: tokenKey, value: encodedToken))
            .thenAnswer((_) async => {});
        when(mockStorage.read(key: tokenKey))
            .thenAnswer((_) async => encodedToken);

        // Act
        await service.saveToken(originalToken);
        final result = await service.getToken();

        // Assert
        expect(result, equals(originalToken));
      });

      test('should handle JWT-like tokens', () async {
        // Arrange
        const jwtToken =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
        final tokenBytes = utf8.encode(jwtToken);
        final encodedToken = base64UrlEncode(tokenBytes);
        const tokenKey = 'auth_user_token';

        when(mockStorage.write(key: tokenKey, value: encodedToken))
            .thenAnswer((_) async => {});
        when(mockStorage.read(key: tokenKey))
            .thenAnswer((_) async => encodedToken);

        // Act
        await service.saveToken(jwtToken);
        final result = await service.getToken();

        // Assert
        expect(result, equals(jwtToken));
      });
    });
  });
}