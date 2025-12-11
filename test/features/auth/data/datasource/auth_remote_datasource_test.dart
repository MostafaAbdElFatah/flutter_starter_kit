import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_starter_kit/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_starter_kit/core/errors/failure.dart';
import 'package:flutter_starter_kit/features/auth/data/models/requests/login_request.dart';
import 'package:flutter_starter_kit/features/auth/data/models/requests/register_request.dart';
import 'package:flutter_starter_kit/features/auth/data/models/responses/login_response.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/models/api_response.dart';
import 'package:flutter_starter_kit/features/auth/data/models/user.dart';
import '../../../../helper/helper_test.mocks.dart';

void main() {
  late MockAPIClient apiClient;
  late MockNetworkConnectivity connectivity;
  late MockAuthEndpoints authEndpoints;
  late AuthRemoteDataSourceImpl dataSource;
  final endpoint = MockAPIEndpoint();

  setUp(() {
    apiClient = MockAPIClient();
    connectivity = MockNetworkConnectivity();
    authEndpoints = MockAuthEndpoints();

    // Default: device is online
    when(connectivity.isConnected).thenAnswer((_) async => true);

    dataSource = AuthRemoteDataSourceImpl(
      apiClient: apiClient,
      connectivity: connectivity,
      authEndpoints: authEndpoints,
    );
  });

  group("Connectivity", () {
    test("throws noInternetConnection when offline", () async {
      // Arrange
      when(connectivity.isConnected).thenAnswer((_) async => false);
      final endpoint = MockAPIEndpoint();

      /// Calling fetch indirectly by using login()
      when(authEndpoints.login(any)).thenReturn(endpoint);

      // Act & Assert
      expect(
        dataSource.login(LoginRequest(email: "", password: "", deviceName: '')),
        throwsA(FailureType.noInternetConnection),
      );
      verify(connectivity.isConnected).called(1);
      verifyNever(
        apiClient.fetch(target: endpoint, fromJson: anyNamed("fromJson")),
      );
    });
  });

  group("Login", () {
    final request = LoginRequest(
      email: "a@mail.com",
      password: "123",
      deviceName: 'iPhone13,2',
    );
    final userModel = UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
      isVerified: true,
    );
    final loginUser = LoginUser(token: 'auth_token', user: userModel);

    setUp(() {
      when(authEndpoints.login(request)).thenReturn(endpoint);
    });

    test("returns LoginUser when API succeeds", () async {
      // Arrange
      final response = LoginResponse(statusCode: 200, data: loginUser);
      when(
        apiClient.fetch<LoginResponse>(
          target: endpoint,
          fromJson: LoginResponse.fromJson,
        ),
      ).thenAnswer((_) async => response);

      // Act
      final result = await dataSource.login(request);

      // Assert
      expect(result, loginUser);
      verify(connectivity.isConnected).called(1);
      verify(
        apiClient.fetch<LoginResponse>(
          target: endpoint,
          fromJson: anyNamed("fromJson"),
        ),
      ).called(1);
    });

    test("throws ServerException when API returns error", () async {
      // Arrange
      final response = LoginResponse(
        statusCode: 500,
        message: "Invalid credentials",
      );

      when(
        apiClient.fetch<LoginResponse>(
          target: endpoint,
          fromJson: LoginResponse.fromJson,
          isFormData: anyNamed("isFormData"),
        ),
      ).thenAnswer((_) async => response);

      // Act & Assert
      expect(
        dataSource.login(request),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            'Invalid credentials',
          ),
        ),
      );
    });
  });

  group("Register", () {
    final request = RegisterRequest(
      email: "b@mail.com",
      password: "111",
      name: "B",
    );
    final userModel = UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
      isVerified: true,
    );
    final loginUser = LoginUser(token: 'auth_token', user: userModel);

    setUp(() {
      when(authEndpoints.register(request)).thenReturn(endpoint);
    });

    test("returns LoginUser when API response is 200", () async {
      // Arrange
      final response = LoginResponse(statusCode: 200, data: loginUser);
      when(
        apiClient.fetch<LoginResponse>(
          target: endpoint,
          fromJson: LoginResponse.fromJson,
        ),
      ).thenAnswer((_) async => response);

      // Act
      final result = await dataSource.register(request);

      //Assert
      expect(result, loginUser);
    });

    test("throws ServerException on API failure", () async {
      // Arrange
      final response = LoginResponse(
        statusCode: 400,
        data: loginUser,
        message: "Email exists",
      );
      when(
        apiClient.fetch<LoginResponse>(
          target: endpoint,
          fromJson: LoginResponse.fromJson,
        ),
      ).thenAnswer((_) async => response);

      // Act & Arrange
      expect(
        dataSource.register(request),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            'Email exists',
          ),
        ),
      );
    });
  });

  group("Logout", () {
    final endpoint = MockAPIEndpoint();

    setUp(() {
      when(authEndpoints.logout()).thenReturn(endpoint);
    });

    test("completes when API is 200", () async {
      // Arrange
      final response = LoginResponse(statusCode: 200);
      when(
        apiClient.fetch<APIResponse>(
          target: endpoint,
          fromJson: APIResponse.fromJson,
        ),
      ).thenAnswer((_) async => response);

      // Act & Arrange
      expect(dataSource.logout(), completes);
    });

    test("throws ServerException when API is not 200", () async {
      // Arrange
      final response = LoginResponse(statusCode: 500, message: "Error");
      when(
        apiClient.fetch<APIResponse>(
          target: endpoint,
          fromJson: APIResponse.fromJson,
          isFormData: anyNamed("isFormData"),
        ),
      ).thenAnswer((_) async => response);
      // Act & Arrange
      expect(dataSource.logout(), throwsA(isA<ServerException>()));
    });
  });

  group("DeleteAccount", () {
    final endpoint = MockAPIEndpoint();

    setUp(() {
      when(authEndpoints.deleteAccount()).thenReturn(endpoint);
    });

    test("completes when API returns 200", () async {
      // Arrange
      final response = LoginResponse(statusCode: 200);
      when(
        apiClient.fetch<APIResponse>(
          target: endpoint,
          fromJson: APIResponse.fromJson,
        ),
      ).thenAnswer((_) async => response);

      // Act & Arrange
      expect(dataSource.deleteAccount(), completes);
    });

    test("throws ServerException when API response != 200", () async {

      // Arrange
      final response = LoginResponse(statusCode: 500, message: "Failed");
      when(
        apiClient.fetch<APIResponse>(
          target: endpoint,
          fromJson: APIResponse.fromJson,
        ),
      ).thenAnswer((_) async => response);

      // Act & Arrange
      expect(dataSource.deleteAccount(), throwsA(isA<ServerException>()));
    });
  });
}
