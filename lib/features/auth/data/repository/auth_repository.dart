import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/data/errors/failure.dart';
import '../../../../core/services/device_services.dart';
import '../../../../core/utils/log.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/auth_local_data_source.dart';
import '../data_source/auth_remote_data_source.dart';
import '../../domain/entities/register_credentials.dart';
import '../../domain/entities/login_credentials.dart';
import '../models/login_user_model.dart';
import '../models/user_model.dart';

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
  User? getAuthenticatedUser() => _localDataSource.getUser()?.toEntity();

  @override
  Future<void> cacheUser(User user) async {
    try {
      await _localDataSource.saveUser(UserModel.fromEntity(user));
    } catch (e) {
      throw Failure.handle(e);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await _localDataSource.getToken();

      final hasToken = token != null && token.isNotEmpty;
      return hasToken;
    } catch (e) {
      Log.error(e.toString());
      return false;
    }
  }

  @override
  Future<User> register(RegisterCredentials credentials) async {
    try {
      // Make the API call and process the response.
      final result = await _remoteDataSource.register(credentials);
      return _processAuthResponse(result);
    } catch (e) {
      throw Failure.handle(e);
    }
  }

  @override
  Future<void> sendOtp(String phone) async {
    try {
      // Make the API call and process the response.
      await _remoteDataSource.sendOtp(phone);
    } catch (e) {
      throw Failure.handle(e);
    }
  }

  @override
  Future<User> login(LoginCredentials credentials) async {
    try {
      final deviceName = await _deviceServices.getDeviceModel();
      // Make the API call and process the response.
      final result = await _remoteDataSource.login(
        credentials.copyWith(deviceName: deviceName),
      );
      return _processAuthResponse(result);
    } catch (e) {
      // Re-throw the exception to be handled by the use case/cubit.
      throw Failure.handle(e);
    }
  }

  /// A helper method to process a successful authentication response.
  ///
  /// This method saves the authentication token and caches the user information.
  Future<User> _processAuthResponse(LoginUserModel result) async {
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
      // only after successful server delete
      await _localDataSource.deleteUser();
    }
    if (failure != null) throw failure;
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      await _localDataSource.deleteUser();
    } catch (e) {
      throw Failure.handle(e); // don't clear local session on failure
    }
  }
}
