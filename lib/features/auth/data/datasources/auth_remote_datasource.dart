import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/infrastructure/data/data_sources/remote_datasource.dart';
import '../../../../core/infrastructure/data/models/api_response.dart';
import '../models/requests/login_request.dart';
import '../models/requests/register_request.dart';
import '../models/responses/login_response.dart';
import '../models/auth_endpoints.dart';

/// An abstract class representing the remote data source for authentication.
///
/// This class defines the contract for fetching authentication-related data
/// from a remote server, such as logging in, registering, logging out, and
/// deleting an account.
abstract class AuthRemoteDataSource {
  /// Logs in a user with the given [request].
  ///
  /// Returns a [LoginUser] object containing the user and token on success.
  /// Throws a [ServerException] if the request fails for any reason.
  Future<LoginUser> login(LoginRequest request);

  /// Registers a new user with the given [request].
  ///
  /// Returns a [LoginUser] object containing the user and token on success.
  /// Throws a [ServerException] if the request fails for any reason.
  Future<LoginUser> register(RegisterRequest request);

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
  final AuthEndpoints _authEndpoints;

  /// Creates an instance of [AuthRemoteDataSourceImpl].
  ///
  /// Requires an `ApiClient` for making network requests, a `Connectivity`
  /// service to check for internet connection (handled by the parent class),
  /// and an `AuthEndpoints` provider to get the API endpoint configurations.
  AuthRemoteDataSourceImpl({
    required super.apiClient,
    required super.connectivity,
    required AuthEndpoints authEndpoints,
  }) : _authEndpoints = authEndpoints;

  @override
  Future<LoginUser> login(LoginRequest request) async {
    final response = await fetch<LoginResponse>(
      target: _authEndpoints.login(request),
      fromJson: LoginResponse.fromJson,
    );

    if (response.statusCode == 200 && response.data != null) {
      return response.data!;
    }

    return throw ServerException(response.errorMessage);
  }

  @override
  Future<LoginUser> register(RegisterRequest request) async {
    final response = await fetch<LoginResponse>(
      target: _authEndpoints.register(request),
      fromJson: LoginResponse.fromJson,
    );

    if (response.statusCode == 200 && response.data != null) {
      return response.data!;
    }

    throw ServerException(response.errorMessage);
  }

  @override
  Future<void> logout() async {
    final response = await fetch<APIResponse>(
      target: _authEndpoints.logout(),
      fromJson: APIResponse.fromJson,
    );

    if (response.statusCode != 200) {
      throw ServerException(response.errorMessage);
    }
  }

  @override
  Future<void> deleteAccount() async {
    final response = await fetch<APIResponse>(
      target: _authEndpoints.deleteAccount(),
      fromJson: APIResponse.fromJson,
    );

    if (response.statusCode != 200) {
      throw ServerException(response.errorMessage);
    }
  }
}
