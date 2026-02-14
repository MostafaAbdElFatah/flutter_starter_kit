import 'package:flutter/foundation.dart';

import '../../errors/failure.dart';
import '../network/api_client.dart';
import '../network/api_endpoint.dart';
import '../network/network_connectivity.dart';

/// Base class for remote data sources that handles API requests with connectivity checks.
///
/// This class provides a centralized way to handle network requests with automatic
/// connectivity verification. It should be extended by specific data source implementations.
abstract class RemoteDataSource {
  /// The [APIClient] instance responsible for making API requests.
  final APIClient _apiClient;

  /// The [NetworkConnectivity] instance to check for internet connection.
  final NetworkConnectivity _connectivity;

  /// Provides protected access to the [APIClient] instance.
  ///
  /// This getter allows derived classes to access the API service while keeping it
  /// encapsulated from external access.
  @protected
  APIClient get apiClient => _apiClient;

  /// Provides protected access to the [NetworkConnectivity] instance.
  ///
  /// This getter allows derived classes to access the connectivity service while keeping it
  /// encapsulated from external access.
  @protected
  NetworkConnectivity get connectivity => _connectivity;

  /// Creates a new [RemoteDataSource] instance.
  ///
  /// - [apiClient]: The API client for making network requests.
  /// - [connectivity]: The connectivity checker for network status.
  const RemoteDataSource({
    required APIClient apiClient,
    required NetworkConnectivity connectivity,
  }) : _apiClient = apiClient,
       _connectivity = connectivity;

  /// Fetches data from the specified [APIEndpoint] and decodes it into the desired model type [T].
  ///
  /// This method first checks for network connectivity. If connected, it proceeds
  /// to fetch data using the injected [APIClient] instance. It utilizes
  /// the provided [mapper] callback to parse the JSON response into the model.
  ///
  /// Example usage:
  /// ```dart
  /// final user = await fetch<User>(
  ///   target: UserEndpoint.getById(id: '123'),
  ///   fromJson: (json) => User.fromJson(json),
  /// );
  /// ```
  ///
  /// - [T]: The type of the model to be returned.
  /// - [target]: The [APIEndpoint] defining the API request details.
  /// - [mapper]: A callback function to convert JSON into an instance of [T].
  /// - [isFormData]: Whether the request body should be sent as form data (default: false).
  ///
  /// Returns: A [Future] containing an instance of [T] on success.
  ///
  /// Throws:
  /// - [FailureType.noInternetConnection] if there is no internet connection.
  /// - [FailureType] variants if the API request fails.
  @protected
  Future<T> fetch<T>({
    required APIEndpoint target,
    required APICallback mapper,
    bool isFormData = false,
  }) async {
    await _ensureConnectivity();

    return _apiClient.fetch<T>(
      target: target,
      mapper: mapper,
      isFormData: isFormData,
    );
  }

  /// Ensures that the device has internet connectivity.
  ///
  /// Throws: [FailureType.noInternetConnection] if there is no internet connection.
  Future<void> _ensureConnectivity() async {
    final isConnected = await _connectivity.isConnected;
    if (!isConnected) throw FailureType.noInternetConnection;
  }
}
