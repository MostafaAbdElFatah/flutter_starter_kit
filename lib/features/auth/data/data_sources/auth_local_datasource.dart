import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/storage/secure_storage_service.dart';
import '../../../../core/infrastructure/storage/storage_service.dart';
import '../models/user.dart';

/// A concrete implementation of [AuthLocalDataSource] that uses [StorageService]
/// for caching user data and [SecureStorageService] for managing the auth token.
@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService _storageService;
  final SecureStorageService _secureStorageService;

  /// The key used to store the authenticated user's data in the local cache.
  static const String _loginUserKey = 'auth_user_key';

  /// Creates an instance of [AuthLocalDataSourceImpl].
  ///
  /// Requires a [StorageService] for general data storage and a
  /// [SecureStorageService] for handling sensitive data like auth tokens.
  AuthLocalDataSourceImpl({
    required StorageService storageService,
    required SecureStorageService secureStorageService,
  }) : _storageService = storageService,
       _secureStorageService = secureStorageService;

  // ---------------------------------------------------------------------------
  // Token Management
  // ---------------------------------------------------------------------------

  @override
  Future<String?> getToken() => _secureStorageService.getToken();

  @override
  Future<void> saveToken(String token) =>
      _secureStorageService.saveToken(token);

  // ---------------------------------------------------------------------------
  // User Management
  // ---------------------------------------------------------------------------

  @override
  UserModel? getUser() =>
      _storageService.getJson(key: _loginUserKey, fromJson: UserModel.fromJson);

  @override
  Future<void> saveUser(UserModel user) =>
      _storageService.putJson(key: _loginUserKey, value: user);

  @override
  Future<void> deleteUser() async {
    await _storageService.delete(_loginUserKey);
    await _secureStorageService.deleteToken();
  }

  @override
  bool hasUser() => _storageService.has(_loginUserKey);
}

/// An abstract class representing the local data source for authentication.
///
/// This class defines the contract for caching authentication-related data,
/// such as the user's profile and authentication token.
abstract class AuthLocalDataSource
    implements TokenLocalDataSource, UserLocalDataSource {}

/// An abstract class representing the local data source for token management.
///
/// This class defines the contract for managing authentication tokens
/// in secure storage.
abstract class TokenLocalDataSource {
  // ---------------------------------------------------------------------------
  // Token Management
  // ---------------------------------------------------------------------------

  /// Saves an authentication token to secure storage.
  Future<void> saveToken(String token);

  /// Retrieves the saved authentication token from secure storage.
  ///
  /// Returns `null` if no token is found.
  Future<String?> getToken();

  /// Deletes the saved authentication token from secure storage.
  //Future<void> deleteToken();
}

/// An abstract class representing the local data source for user data.
///
/// This class defines the contract for caching user profile information
/// in local storage.
abstract class UserLocalDataSource {
  // ---------------------------------------------------------------------------
  // User Management
  // ---------------------------------------------------------------------------

  /// Caches the user data.
  ///
  /// The [user] object is serialized to JSON before being stored.
  Future<void> saveUser(UserModel user);

  /// Retrieves the cached user data.
  ///
  /// The stored JSON is deserialized into a [UserModel] object.
  /// Returns `null` if no user is cached.
  UserModel? getUser();

  /// Deletes the cached user data from local storage.
  Future<void> deleteUser();

  /// Checks if user data exists in local storage.
  bool hasUser();
}
