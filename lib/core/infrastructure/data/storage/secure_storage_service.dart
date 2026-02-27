import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A service interface for interacting with secure, encrypted key–value storage.
///
/// This service is typically backed by plugins such as `flutter_secure_storage`,
/// and is responsible for storing sensitive information such as authentication
/// tokens, session identifiers, or encrypted user data.
///
/// Implementations must ensure that:
/// - All stored data is encrypted.
/// - Reads/writes are asynchronous.
/// - Data is isolated per application install.
abstract class SecureStorageService {
  // ---------------------------------------------------------------------------
  // Token-specific helpers
  // ---------------------------------------------------------------------------

  /// Saves an authentication token securely.
  ///
  /// Can be used after login or a token refresh.
  ///
  /// Example:
  /// ```dart
  /// await secureStorage.saveToken(token);
  /// ```
  Future<void> saveToken(String token);

  /// Retrieves the saved authentication token, if any.
  ///
  /// Returns `null` if no token exists.
  Future<String?> getToken();

  /// Deletes the saved authentication token.
  Future<void> deleteToken();

  // ---------------------------------------------------------------------------
  // Generic secure storage operations
  // ---------------------------------------------------------------------------

  /// Writes a `value` associated with the given `key` into secure storage.
  ///
  /// Both parameters are required because secure storage is key–value based.
  Future<void> write({required String key, required String value});

  /// Reads the value associated with the given `key` from secure storage.
  ///
  /// Returns `null` if the key does not exist.
  Future<String?> read({required String key});

  /// Deletes the value associated with the given `key` from secure storage.
  Future<void> delete({required String key});

  /// Deletes **all secure stored values**.
  ///
  /// Useful for logout flows where tokens, profile info, and sensitive settings
  /// must be removed.
  Future<void> deleteAll();
}

/// A concrete implementation of [SecureStorageService] that uses `flutter_secure_storage`.
///
/// This class is responsible for securely storing and retrieving sensitive data,
/// such as the authentication token. It is registered as a lazy singleton,
/// meaning a single instance will be created and shared throughout the application.
@LazySingleton(as: SecureStorageService)
class SecureStorageServiceImpl extends SecureStorageService {
  final FlutterSecureStorage _storage;
  static const String _tokenKey = 'auth_user_token';
  SecureStorageServiceImpl(FlutterSecureStorage storage) : _storage = storage;

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();

  @override
  Future<void> deleteToken() => delete(key: _tokenKey);

  @override
  Future<void> saveToken(String token) async {
    // Convert token string to bytes
    final tokenBytes = utf8.encode(token);

    // Encode bytes to Base64 URL-safe string
    final encryptionKeyString = base64UrlEncode(tokenBytes);

    // Save to secure storage
    await write(key: _tokenKey, value: encryptionKeyString);
  }

  @override
  Future<String?> getToken() async {
    final encodedToken = await read(key: _tokenKey);
    if (encodedToken == null) return null;

    // Decode Base64 back to string
    final decodedBytes = base64Url.decode(encodedToken);
    return utf8.decode(decodedBytes);
  }
}
