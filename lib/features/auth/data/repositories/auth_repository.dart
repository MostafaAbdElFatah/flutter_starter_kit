import 'package:injectable/injectable.dart';

import '../../../../core/utils/log.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/device_services.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/entities/register_credentials.dart';
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
  User? getAuthenticatedUser() =>  _localDataSource.getUser();

  @override
  Future<bool> isLoggedIn() async {
    try {
      final user = _localDataSource.getUser();
      final token = await _localDataSource.getToken();

      final hasToken = token != null && token.isNotEmpty;
      final hasUser = user != null && user.isVerified;

      return hasToken && hasUser;
    } catch (e) {
      Log.error(e.toString());
      return false;
    }
  }


  @override
  Future<User> login(LoginCredentials params) async {
    try {
      final deviceName = await _deviceServices.getDeviceModel();
      final request = LoginRequest.credentials(
        credentials: params,
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
  Future<User> register(RegisterCredentials params) async {
    try {
      final deviceName = await _deviceServices.getDeviceModel();
      final request = RegisterRequest.credentials(
        credentials: params,
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
    Exception? failure;
    try {
      await _remoteDataSource.logout();
    } catch (e) {
      failure = Failure.handle(e);
    } finally {
      // Always run, even on network/server failure
      await _localDataSource
          .deleteUser(); // only after successful server delete
    }
    if (failure != null) throw failure;
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      await _localDataSource
          .deleteUser(); // only after successful server delete
    } catch (e) {
      throw Failure.handle(e); // don't clear local session on failure
    }
  }
}
