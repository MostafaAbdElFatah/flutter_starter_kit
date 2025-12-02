import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/infrastructure/data/datasources/remote_datasource.dart';
import '../../../../core/infrastructure/data/models/api_response.dart';
import '../models/requests/login_request.dart';
import '../models/requests/register_request.dart';
import '../models/responses/login_response.dart';
import '../network/auth_endpoints.dart';

/// An abstract class representing the remote data source for authentication.
///
/// This class defines the contract for fetching authentication-related data
/// from a remote server.
abstract class AuthRemoteDataSource {

  Future<void> logout();

  /// Logs in a user with the given [request].
  ///
  /// Returns a [LoginUser] object on success.
  /// Throws a [ServerException] if the request fails.
  Future<LoginUser> login(LoginRequest request);

  /// Registers a new user with the given [request].
  ///
  /// Returns a [LoginUser] object on success.
  /// Throws a [ServerException] if the request fails.
  Future<LoginUser> register(RegisterRequest request);
}

/// The concrete implementation of [AuthRemoteDataSource].
///
/// This class communicates with the remote authentication API, handles making
/// the API calls, and processes the responses.
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends RemoteDataSource
    implements AuthRemoteDataSource {
  final AuthEndpoints _authEndpoints;

  /// Creates an instance of [AuthRemoteDataSourceImpl].
  ///
  /// Requires an `ApiClient` for making network requests, a `Connectivity`
  /// service to check for internet connection, and an `AuthEndpoints` provider
  /// to get the API endpoint configurations.
  AuthRemoteDataSourceImpl({
    required super.apiClient,
    required super.connectivity,
    required AuthEndpoints authEndpoints,
  }) : _authEndpoints = authEndpoints;

  @override
  Future<void> logout() async {
    final response = await fetch<APIResponse>(
      // Specifies the target endpoint for the logout request.
      target: _authEndpoints.logout(),
      // Provides the function to deserialize the JSON response into a LoginResponse object.
      fromJson: APIResponse.fromJson,
    );

    // If the request is successful (statusCode 200),
    if (response.statusCode == 200) return;

    // Otherwise, throw a ServerException with a descriptive error message.
    throw ServerException(response.errorMessage);
  }

  @override
  Future<LoginUser> login(LoginRequest request) async {
    // Uses the generic `fetch` method from the base `RemoteDataSource`
    // to make the API call.
    final response = await fetch<LoginResponse>(
      // Specifies the target endpoint for the login request.
      target: _authEndpoints.login(request),
      // Provides the function to deserialize the JSON response into a LoginResponse object.
      fromJson: LoginResponse.fromJson,
    );

    // If the request is successful (statusCode 200) and data is not null,
    // return the user data.
    if (response.statusCode == 200 && response.data != null) {
      return response.data!;
    }

    // Otherwise, throw a ServerException with a descriptive error message.
    throw ServerException(response.errorMessage);
  }

  @override
  Future<LoginUser> register(RegisterRequest request) async {
    // Uses the generic `fetch` method from the base `RemoteDataSource`
    // to make the API call.
    final response = await fetch<LoginResponse>(
      // Specifies the target endpoint for the register request.
    target: _authEndpoints.register(request),
      // Provides the function to deserialize the JSON response into a LoginResponse object.
      fromJson: LoginResponse.fromJson,
    );

    // If the request is successful (statusCode 200) and data is not null,
    // return the user data.
    if (response.statusCode == 200 && response.data != null) {
      return response.data!;
    }

    // Otherwise, throw a ServerException with a descriptive error message.
    throw ServerException(response.errorMessage);
  }


}
