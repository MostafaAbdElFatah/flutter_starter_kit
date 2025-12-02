import 'package:injectable/injectable.dart';

import '../../../../core/network/api_endpoint.dart';
import '../models/requests/login_request.dart';
import '../models/requests/register_request.dart';

/// A provider class for authentication-related API endpoints.
///
/// This class encapsulates the creation of [APIEndpoint] instances for various
/// authentication actions, such as logging in, registering, logging out, and
/// deleting an account. It is registered as a lazy singleton, so a single
/// instance is created and shared throughout the application.
@lazySingleton
class AuthEndpoints {
  /// Returns the endpoint for logging in a user.
  APIEndpoint login(LoginRequest request) => APIEndpoint(
        endpoint: '/login',
        method: HttpMethod.post,
        body: request.toJson(),
      );

  /// Returns the endpoint for registering a new user.
  APIEndpoint register(RegisterRequest request) => APIEndpoint(
        endpoint: '/register',
        method: HttpMethod.post,
        body: request.toJson(),
      );

  /// Returns the endpoint for logging out the current user.
  APIEndpoint logout() =>
      APIEndpoint(endpoint: '/logout', method: HttpMethod.post);

  /// Returns the endpoint for deleting the current user's account.
  APIEndpoint deleteAccount() =>
      APIEndpoint(endpoint: '/profile/delete-account', method: HttpMethod.post);
}
