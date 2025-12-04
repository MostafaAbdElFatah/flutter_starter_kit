import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/device_services.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/requests/login_request.dart';
import '../models/requests/register_request.dart';
import '../models/responses/login_response.dart';

/// The concrete implementation of the [AuthRepository] interface.
///
/// This class orchestrates authentication-related operations by coordinating
/// between remote and local data sources. It is responsible for making API
/// calls, handling responses, and caching data locally.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final DeviceServices _deviceServices;
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({
    required DeviceServices deviceServices,
    required AuthLocalDataSource localDataSource,
    required AuthRemoteDataSource remoteDataSource,
  }) : _deviceServices = deviceServices,
       _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  // ---------------------------------------------------------------------------
  // Auth Management
  // ---------------------------------------------------------------------------

  @override
  Future<bool> isLoggedIn() async {
    final user = _localDataSource.getUser();
    final token = await _localDataSource.getToken();

    final hasToken = token != null && token.isNotEmpty;
    final hasUser = user != null && user.isVerified;

    return hasToken && hasUser;
  }

  @override
  Future<User?> getAuthenticatedUser() async {
    try {
      final token = await _localDataSource.getToken();
      if (token != null && token.isNotEmpty) {
        return _localDataSource.getUser();
      }
      return null;
    } catch (e) {
      // In case of an error, we assume the user is not authenticated.
      return null;
    }
  }

  @override
  Future<User> login({required String email, required String password}) async {
    try {
      final deviceName = await _deviceServices.getDeviceModel();
      final request = LoginRequest(
        email: email,
        password: password,
        deviceName: deviceName,
      );
      // Make the API call and process the response.
      final result = await _remoteDataSource.login(request);
      return _processAuthResponse(result);
    } catch (e) {
      // Re-throw the exception to be handled by the use case/cubit.
      throw Failure.handle(e);
    }
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final deviceName = await _deviceServices.getDeviceModel();
      final request = RegisterRequest(
        name: name,
        email: email,
        password: password,
        deviceName: deviceName,
      );
      // Make the API call and process the response.
      final result = await _remoteDataSource.register(request);
      return _processAuthResponse(result);
    } catch (e) {
      throw Failure.handle(e);
    }
  }

  /// A helper method to process a successful authentication response.
  ///
  /// This method saves the authentication token and caches the user information.
  Future<User> _processAuthResponse(LoginUser result) async {
    // 1. Save the token to secure storage.
    await _localDataSource.saveToken(result.token);
    // 2. Cache the user information.
    await _localDataSource.saveUser(result.user);
    // 3. Return the user entity.
    return result.user.toEntity();
  }

  // ---------------------------------------------------------------------------
  // Logout Management
  // ---------------------------------------------------------------------------

  @override
  Future<void> logout() async {
    try {
      // Attempt to log out from the server, but don't let it block the local logout.
      await _remoteDataSource.logout();
    } finally {
      // Ensure local data is always cleared.
      await _deleteUser();
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      // Attempt to log out from the server, but don't let it block the local logout.
      await _remoteDataSource.deleteAccount();
    } finally {
      // Ensure local data is always cleared.
      await _deleteUser();
    }
  }

  /// Deletes the user's data from local storage.
  Future<void> _deleteUser() async {
    await _localDataSource.deleteUser();
    await _localDataSource.deleteToken();
  }
}
