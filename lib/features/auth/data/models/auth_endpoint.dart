import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/data/network/api_endpoint.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/entities/register_credentials.dart';

/// A provider class for authentication-related API endpoints.
///
/// This class encapsulates the creation of [APIEndpoint] instances for various
/// authentication actions, such as logging in, registering, logging out, and
/// deleting an account. It is registered as a lazy singleton, so a single
/// instance is created and shared throughout the application.
@lazySingleton
class AuthEndpoints {

  /// Returns the endpoint for send otp logging phone.
  APIEndpoint sendOtp(String phone) => APIEndpoint(
    endpoint: '/request-otp',
    method: HttpMethod.post,
    body: {"phone": phone},
  );

  /// Returns the endpoint for logging in a user.
  APIEndpoint login(LoginCredentials credentials) => APIEndpoint(
    endpoint: '/login',
    method: HttpMethod.post,
    body: credentials.toQueryParams(),
  );

  /// Returns the endpoint for registering a new user.
  APIEndpoint register(RegisterCredentials credentials) => APIEndpoint(
    endpoint: '/register',
    method: HttpMethod.post,
    body: credentials.toQueryParams(),
  );

  /// Returns the endpoint for logging out the current user.
  APIEndpoint logout() =>
      APIEndpoint(endpoint: '/logout', method: HttpMethod.post);

  /// Returns the endpoint for deleting the current user's account.
  APIEndpoint deleteAccount() =>
      APIEndpoint(endpoint: '/delete-profile', method: HttpMethod.post);
}

