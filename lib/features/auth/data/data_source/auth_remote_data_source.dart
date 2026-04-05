import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/data/data_sources/remote_datasource.dart';
import '../../../../core/infrastructure/data/errors/failure.dart';
import '../../../../core/infrastructure/data/models/api_response.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/entities/register_credentials.dart';
import '../models/login_user_model.dart';
import '../models/auth_endpoint.dart';
import '../models/user_model.dart';

/// An abstract class representing the remote data source for authentication.
///
/// This class defines the contract for fetching authentication-related data
/// from a remote server, such as logging in, registering, logging out, and
/// deleting an account.
abstract class AuthRemoteDataSource {
  /// Logs in a user with the given [request].
  ///
  /// Returns a [UserModel] object containing the user and token on success.
  /// Throws a [ServerException] if the requests fails for any reason.
  Future<LoginUserModel> login(LoginCredentials request);

  /// Requests a One-Time Password (OTP) to be sent to the specified [phone] number.
  ///
  /// This is typically used for phone-based authentication or verification flows.
  /// Throws a [ServerException] if the request cannot be processed.
  Future<void> sendOtp(String phone);

  /// Registers a new user with the given [request].
  ///
  /// Throws a [ServerException] if the requests fails for any reason.
  Future<LoginUserModel> register(RegisterCredentials request);

  /// Logs out the currently authenticated user from the server.
  ///
  /// This typically invalidates the user's session or token on the backend.
  /// Throws a [ServerException] if the API call fails.
  Future<void> logout();

  /// Deletes the currently authenticated user's account from the server.
  ///
  /// This is a permanent action and should be used with caution.
  /// Throws a [ServerException] if the API call fails.
  Future<void> deleteAccount();
}

/// The concrete implementation of [AuthRemoteDataSource].
///
/// This class communicates with the remote authentication API by extending
/// [RemoteDataSource] and using the provided `fetch` method to handle API calls.
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends RemoteDataSource
    implements AuthRemoteDataSource {
  final AuthEndpoints _endpoints;

  /// Creates an instance of [AuthRemoteDataSourceImpl].
  ///
  /// Requires an `ApiClient` for making network requests, a `Connectivity`
  /// service to check for internet connection (handled by the parent class),
  /// and an `AuthEndpoints` provider to get the API endpoint configurations.
  AuthRemoteDataSourceImpl({
    required super.apiClient,
    required super.connectivity,
    required AuthEndpoints authEndpoints,
  }) : _endpoints = authEndpoints;

  @override
  Future<LoginUserModel> login(LoginCredentials credentials) async {
    final response = await getSingle<LoginUserModel>(
      target: _endpoints.login(credentials),
      mapper: LoginUserModel.fromJson,
    );
    if (response.isSuccess) return response.requireData;
    throw ServerException(response.errorMessage);
  }

  @override
  Future<void> sendOtp(String phone) async {
    final response = await fetch<APIResponse>(
      target: _endpoints.sendOtp(phone),
      mapper: APIResponse.fromJson,
    );
    if (response.isSuccess) return;
    throw ServerException(response.errorMessage);
  }

  @override
  Future<LoginUserModel> register(RegisterCredentials credentials) async {
    final response = await getSingle<LoginUserModel>(
      target: _endpoints.register(credentials),
      mapper: LoginUserModel.fromJson,
    );
    if (response.isSuccess) return response.requireData;
    throw ServerException(response.errorMessage);
  }

  @override
  Future<void> logout() async {
    final response = await fetch<APIResponse>(
      target: _endpoints.logout(),
      mapper: APIResponse.fromJson,
    );
    if (response.isSuccess) return;
    throw ServerException(response.errorMessage);
  }

  @override
  Future<void> deleteAccount() async {
    final response = await fetch<APIResponse>(
      target: _endpoints.deleteAccount(),
      mapper: APIResponse.fromJson,
    );
    if (response.isSuccess) return;
    throw ServerException(response.errorMessage);
  }
}
