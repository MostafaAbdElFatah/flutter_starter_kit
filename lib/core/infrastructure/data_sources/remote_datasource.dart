import 'package:flutter/foundation.dart';

import '../errors/failure.dart';
import '../models/list_api_response.dart';
import '../models/typed_api_response.dart';
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

  /// Ensures that the device has internet connectivity.
  ///
  /// Throws: [FailureType.noInternetConnection] if there is no internet connection.
  Future<void> _ensureConnectivity() async {
    final isConnected = await _connectivity.isConnected;
    if (!isConnected) throw FailureType.noInternetConnection;
  }

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

  /// Fetches a single item from the specified [APIEndpoint] and decodes it into [T].
  ///
  /// Wraps the response in a [TypedAPIResponse] containing the parsed model.
  ///
  /// Example usage:
  /// ```dart
  /// final response = await getOne<User>(
  ///   endpoint: UserEndpoint.getById(id: '123'),
  ///   itemFromJson: User.fromJson,
  /// );
  /// ```
  ///
  /// - [T]: The type of the model to be returned.
  /// - [target]: The [APIEndpoint] defining the API request details.
  /// - [itemFromJson]: A callback to convert JSON into an instance of [T].
  ///
  /// Returns: A [Future] containing a [TypedAPIResponse<T>] on success.
  ///
  /// Throws:
  /// - [FailureType.noInternetConnection] if there is no internet connection.
  /// - [FailureType] variants if the API request fails.
  @protected
  Future<TypedAPIResponse<T>> getSingle<T>({
    required APIEndpoint target,
    required T Function(Map<String, dynamic>) itemFromJson,
  }) => fetch<TypedAPIResponse<T>>(
    target: target,
    mapper: (statusCode, message, json) => TypedAPIResponse<T>.fromJson(
      statusCode: statusCode,
      message: message,
      json: json,
      itemFromJson: itemFromJson,
    ),
  );

  /// Fetches a list of items from the specified [APIEndpoint] and decodes each into [T].
  ///
  /// Wraps the response in a [ListAPIResponse] containing the parsed list of models.
  ///
  /// Example usage:
  /// ```dart
  /// final response = await getList<User>(
  ///   endpoint: UserEndpoint.getAll,
  ///   itemFromJson: User.fromJson,
  /// );
  /// ```
  ///
  /// - [T]: The type of each model in the list.
  /// - [target]: The [APIEndpoint] defining the API request details.
  /// - [mapper]: A callback to convert each JSON object into an instance of [T].
  ///
  /// Returns: A [Future] containing a [ListAPIResponse<T>] on success.
  ///
  /// Throws:
  /// - [FailureType.noInternetConnection] if there is no internet connection.
  /// - [FailureType] variants if the API request fails.
  @protected
  Future<ListAPIResponse<T>> getList<T>({
    required APIEndpoint target,
    required T Function(Map<String, dynamic>) mapper,
  }) => fetch<ListAPIResponse<T>>(
    target: target,
    mapper: (statusCode, message, json) => ListAPIResponse<T>.fromJson(
      statusCode: statusCode,
      message: message,
      json: json,
      itemFromJson: mapper,
    ),
  );
}
