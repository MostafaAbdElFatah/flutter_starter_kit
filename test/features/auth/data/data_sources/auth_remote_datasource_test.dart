import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_starter_kit/core/infrastructure/data/errors/failure.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/models/api_response.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/models/typed_api_response.dart';
import 'package:flutter_starter_kit/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:flutter_starter_kit/features/auth/data/models/login_user_model.dart';
import 'package:flutter_starter_kit/features/auth/data/models/user_model.dart';
import 'package:flutter_starter_kit/features/auth/domain/entities/login_credentials.dart';
import 'package:flutter_starter_kit/features/auth/domain/entities/register_credentials.dart';

import '../../../../helper/helper_test.mocks.dart';

void main() {
  late MockAPIClient apiClient;
  late MockNetworkConnectivity connectivity;
  late MockAuthEndpoints authEndpoints;
  late MockAPIEndpoint endpoint;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    apiClient = MockAPIClient();
    connectivity = MockNetworkConnectivity();
    authEndpoints = MockAuthEndpoints();
    endpoint = MockAPIEndpoint();

    when(connectivity.isConnected).thenAnswer((_) async => true);

    dataSource = AuthRemoteDataSourceImpl(
      apiClient: apiClient,
      connectivity: connectivity,
      authEndpoints: authEndpoints,
    );
  });

  group('Connectivity', () {
    final request = LoginCredentials(email: '', password: '', deviceName: '');

    test('throws noInternetConnection when offline', () async {
      when(connectivity.isConnected).thenAnswer((_) async => false);
      when(authEndpoints.login(request)).thenReturn(endpoint);

      await expectLater(
        dataSource.login(request),
        throwsA(FailureType.noInternetConnection),
      );

      verify(authEndpoints.login(request)).called(1);
      verify(connectivity.isConnected).called(1);
      verifyNever(
        apiClient.fetch<TypedAPIResponse<LoginUserModel>>(
          target: endpoint,
          mapper: anyNamed('mapper'),
          isFormData: anyNamed('isFormData'),
        ),
      );
    });
  });

  group('Login', () {
    final request = LoginCredentials(
      email: 'a@mail.com',
      password: '123',
      deviceName: 'iPhone13,2',
    );
    final userModel = UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
      isVerified: true,
    );
    final loginUserModel = LoginUserModel(token: 'auth_token', user: userModel);

    setUp(() {
      when(authEndpoints.login(request)).thenReturn(endpoint);
    });

    test('returns LoginUserModel when API succeeds', () async {
      final response = TypedAPIResponse<LoginUserModel>(
        statusCode: 200,
        data: loginUserModel,
      );
      when(
        apiClient.fetch<TypedAPIResponse<LoginUserModel>>(
          target: endpoint,
          mapper: anyNamed('mapper'),
          isFormData: anyNamed('isFormData'),
        ),
      ).thenAnswer((_) async => response);

      final result = await dataSource.login(request);

      expect(result, loginUserModel);
      verify(authEndpoints.login(request)).called(1);
      verify(connectivity.isConnected).called(1);
      verify(
        apiClient.fetch<TypedAPIResponse<LoginUserModel>>(
          target: endpoint,
          mapper: anyNamed('mapper'),
          isFormData: false,
        ),
      ).called(1);
    });

    test('throws ServerException when API returns error', () async {
      final response = TypedAPIResponse<LoginUserModel>(
        statusCode: 500,
        message: 'Invalid credentials',
      );
      when(
        apiClient.fetch<TypedAPIResponse<LoginUserModel>>(
          target: endpoint,
          mapper: anyNamed('mapper'),
          isFormData: anyNamed('isFormData'),
        ),
      ).thenAnswer((_) async => response);

      await expectLater(
        dataSource.login(request),
        throwsA(
          isA<ServerException>().having(
            (exception) => exception.message,
            'message',
            'Invalid credentials',
          ),
        ),
      );
    });
  });

  group('Register', () {
    const request = RegisterCredentials(
      email: 'b@mail.com',
      password: '111',
      name: 'B',
    );
    final userModel = UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
      isVerified: true,
    );
    final loginUserModel = LoginUserModel(token: 'auth_token', user: userModel);

    setUp(() {
      when(authEndpoints.register(request)).thenReturn(endpoint);
    });

    test('returns LoginUserModel when API response is successful', () async {
      final response = TypedAPIResponse<LoginUserModel>(
        statusCode: 200,
        data: loginUserModel,
      );
      when(
        apiClient.fetch<TypedAPIResponse<LoginUserModel>>(
          target: endpoint,
          mapper: anyNamed('mapper'),
          isFormData: anyNamed('isFormData'),
        ),
      ).thenAnswer((_) async => response);

      final result = await dataSource.register(request);

      expect(result, loginUserModel);
      verify(authEndpoints.register(request)).called(1);
      verify(connectivity.isConnected).called(1);
    });

    test('throws ServerException on API failure', () async {
      final response = TypedAPIResponse<LoginUserModel>(
        statusCode: 400,
        message: 'Email exists',
      );
      when(
        apiClient.fetch<TypedAPIResponse<LoginUserModel>>(
          target: endpoint,
          mapper: anyNamed('mapper'),
          isFormData: anyNamed('isFormData'),
        ),
      ).thenAnswer((_) async => response);

      await expectLater(
        dataSource.register(request),
        throwsA(
          isA<ServerException>().having(
            (exception) => exception.message,
            'message',
            'Email exists',
          ),
        ),
      );
    });
  });

  group('Logout', () {
    setUp(() {
      when(authEndpoints.logout()).thenReturn(endpoint);
    });

    test('completes when API is successful', () async {
      final response = APIResponse(statusCode: 200);
      when(
        apiClient.fetch<APIResponse>(
          target: endpoint,
          mapper: APIResponse.fromJson,
          isFormData: anyNamed('isFormData'),
        ),
      ).thenAnswer((_) async => response);

      await expectLater(dataSource.logout(), completes);

      verify(authEndpoints.logout()).called(1);
      verify(connectivity.isConnected).called(1);
    });

    test('throws ServerException when API is not successful', () async {
      final response = APIResponse(statusCode: 500, message: 'Error');
      when(
        apiClient.fetch<APIResponse>(
          target: endpoint,
          mapper: APIResponse.fromJson,
          isFormData: anyNamed('isFormData'),
        ),
      ).thenAnswer((_) async => response);

      await expectLater(
        dataSource.logout(),
        throwsA(
          isA<ServerException>().having(
            (exception) => exception.message,
            'message',
            'Error',
          ),
        ),
      );
    });
  });

  group('DeleteAccount', () {
    setUp(() {
      when(authEndpoints.deleteAccount()).thenReturn(endpoint);
    });

    test('completes when API returns success', () async {
      final response = APIResponse(statusCode: 200);
      when(
        apiClient.fetch<APIResponse>(
          target: endpoint,
          mapper: APIResponse.fromJson,
          isFormData: anyNamed('isFormData'),
        ),
      ).thenAnswer((_) async => response);

      await expectLater(dataSource.deleteAccount(), completes);

      verify(authEndpoints.deleteAccount()).called(1);
      verify(connectivity.isConnected).called(1);
    });

    test(
      'throws ServerException when API response is not successful',
      () async {
        final response = APIResponse(statusCode: 500, message: 'Failed');
        when(
          apiClient.fetch<APIResponse>(
            target: endpoint,
            mapper: APIResponse.fromJson,
            isFormData: anyNamed('isFormData'),
          ),
        ).thenAnswer((_) async => response);

        await expectLater(
          dataSource.deleteAccount(),
          throwsA(
            isA<ServerException>().having(
              (exception) => exception.message,
              'message',
              'Failed',
            ),
          ),
        );
      },
    );
  });
}
