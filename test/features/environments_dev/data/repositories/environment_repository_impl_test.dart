import 'package:flutter_starter_kit/features/environments_dev/data/models/auth_config.dart';
import 'package:flutter_starter_kit/features/environments_dev/data/models/base_url_config.dart';
import 'package:flutter_starter_kit/features/environments_dev/data/repositories/environment_repository_impl.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/api_config.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/base_url_config.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/environment.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/usecases/developer_login_usecase.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/usecases/get_environment_config_use_case.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/usecases/update_environment_configuration_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../helper/helper_test.mocks.dart';

void main() {
  late EnvironmentRepositoryImpl repository;
  late MockEnvironmentLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockEnvironmentLocalDataSource();
    repository = EnvironmentRepositoryImpl(mockLocalDataSource);
  });

  group('currentApiConfig', () {
    test('should return current API config from local data source', () {
      // arrange
      final tApiConfig = APIConfig(
        apiKey: 'test_api_key',
        baseUrl: 'https://api.test.com',
        environment: Environment.dev,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockLocalDataSource.currentApiConfig).thenReturn(tApiConfig);

      // act
      final result = repository.currentApiConfig;

      // assert
      expect(result, equals(tApiConfig));
      expect(result.apiKey, equals('test_api_key'));
      expect(result.baseUrl, equals('https://api.test.com'));
      verify(mockLocalDataSource.currentApiConfig);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test(
      'should return production API config when environment is production',
      () {
        // arrange
        final tApiConfig = APIConfig(
          apiKey: 'prod_api_key',
          baseUrl: 'https://api.production.com',
          environment: Environment.prod,
          baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
        );

        when(mockLocalDataSource.currentApiConfig).thenReturn(tApiConfig);

        // act
        final result = repository.currentApiConfig;

        // assert
        expect(result.baseUrl, contains('production'));
        verify(mockLocalDataSource.currentApiConfig);
      },
    );
  });

  group('currentEnvironment', () {
    test('should return current environment from local data source', () {
      // arrange
      const tEnvironment = Environment.dev;

      when(mockLocalDataSource.currentEnvironment).thenReturn(tEnvironment);

      // act
      final result = repository.currentEnvironment;

      // assert
      expect(result, equals(Environment.dev));
      verify(mockLocalDataSource.currentEnvironment);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return staging environment when set to staging', () {
      // arrange
      const tEnvironment = Environment.stage;

      when(mockLocalDataSource.currentEnvironment).thenReturn(tEnvironment);

      // act
      final result = repository.currentEnvironment;

      // assert
      expect(result, equals(Environment.stage));
      verify(mockLocalDataSource.currentEnvironment);
    });

    test('should return production environment when set to production', () {
      // arrange
      const tEnvironment = Environment.prod;

      when(mockLocalDataSource.currentEnvironment).thenReturn(tEnvironment);

      // act
      final result = repository.currentEnvironment;

      // assert
      expect(result, equals(Environment.prod));
      verify(mockLocalDataSource.currentEnvironment);
    });
  });

  group('getConfigForEnvironment', () {
    test('should return API config for given environment', () {
      // arrange
      const tEnvironment = Environment.dev;
      final tParams = EnvironmentConfigGetParams(tEnvironment);
      final tApiConfig = APIConfig(
        apiKey: 'dev_api_key',
        baseUrl: 'https://api.dev.com',
        environment: Environment.dev,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(
        mockLocalDataSource.getConfigForEnvironment(tEnvironment),
      ).thenReturn(tApiConfig);

      // act
      final result = repository.getConfigForEnvironment(tParams);

      // assert
      expect(result, equals(tApiConfig));
      expect(result.apiKey, equals('dev_api_key'));
      expect(result.baseUrl, equals('https://api.dev.com'));
      verify(mockLocalDataSource.getConfigForEnvironment(tEnvironment));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return staging API config for staging environment', () {
      // arrange
      const tEnvironment = Environment.stage;
      final tParams = EnvironmentConfigGetParams(tEnvironment);
      final tApiConfig = APIConfig(
        apiKey: 'staging_api_key',
        baseUrl: 'https://api.staging.com',
        environment: Environment.stage,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(
        mockLocalDataSource.getConfigForEnvironment(tEnvironment),
      ).thenReturn(tApiConfig);

      // act
      final result = repository.getConfigForEnvironment(tParams);

      // assert
      expect(result.apiKey, equals('staging_api_key'));
      expect(result.baseUrl, equals('https://api.staging.com'));
      verify(mockLocalDataSource.getConfigForEnvironment(tEnvironment));
    });

    test('should return production API config for production environment', () {
      // arrange
      const tEnvironment = Environment.prod;
      final tParams = EnvironmentConfigGetParams(tEnvironment);
      final tApiConfig = APIConfig(
        apiKey: 'prod_api_key',
        baseUrl: 'https://api.production.com',
        environment: Environment.prod,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(
        mockLocalDataSource.getConfigForEnvironment(tEnvironment),
      ).thenReturn(tApiConfig);

      // act
      final result = repository.getConfigForEnvironment(tParams);

      // assert
      expect(result.apiKey, equals('prod_api_key'));
      verify(mockLocalDataSource.getConfigForEnvironment(tEnvironment));
    });
  });

  group('updateConfiguration', () {
    test('should update configuration with environment only', () async {
      // arrange
      const tEnvironment = Environment.stage;
      final tParams = EnvironmentConfigUpdateParams(tEnvironment);

      when(
        mockLocalDataSource.updateConfiguration(tEnvironment),
      ).thenAnswer((_) async => Future.value());

      // act
      await repository.updateConfiguration(tParams);

      // assert
      verify(mockLocalDataSource.updateConfiguration(tEnvironment));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test(
      'should update configuration with environment and base URL config',
      () async {
        // arrange
        const tEnvironment = Environment.prod;
        final tBaseUrlConfig = BaseUrlConfig.custom('https://custom.api.com');
        final tParams = EnvironmentConfigUpdateParams(
          tEnvironment,
          baseUrlConfig: tBaseUrlConfig,
        );

        when(
          mockLocalDataSource.updateConfiguration(
            tEnvironment,
            baseUrlConfig: anyNamed('baseUrlConfig'),
          ),
        ).thenAnswer((_) async => Future.value());

        // act
        await repository.updateConfiguration(tParams);

        // assert
        verify(
          mockLocalDataSource.updateConfiguration(
            tEnvironment,
            baseUrlConfig: anyNamed('baseUrlConfig'),
          ),
        );
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test('should convert BaseUrlConfig entity to model correctly', () async {
      // arrange
      const tEnvironment = Environment.dev;
      final tBaseUrlConfig = BaseUrlConfig.custom('http://localhost:8080');
      final tParams = EnvironmentConfigUpdateParams(
        tEnvironment,
        baseUrlConfig: tBaseUrlConfig,
      );

      when(
        mockLocalDataSource.updateConfiguration(
          tEnvironment,
          baseUrlConfig: anyNamed('baseUrlConfig'),
        ),
      ).thenAnswer((_) async => Future.value());

      // act
      await repository.updateConfiguration(tParams);

      // assert
      final captured = verify(
        mockLocalDataSource.updateConfiguration(
          tEnvironment,
          baseUrlConfig: captureAnyNamed('baseUrlConfig'),
        ),
      ).captured;

      expect(captured.length, 1);
      final capturedModel = captured[0] as BaseUrlConfigModel?;
      if (capturedModel != null) {
        expect(capturedModel.customUrl, equals('http://localhost:8080'));
        expect(capturedModel.isCustom, isTrue);
      }
    });

    test('should complete successfully when update is successful', () async {
      // arrange
      const tEnvironment = Environment.stage;
      final tParams = EnvironmentConfigUpdateParams(
        tEnvironment,
        baseUrlConfig: null,
      );

      when(
        mockLocalDataSource.updateConfiguration(tEnvironment),
      ).thenAnswer((_) async => Future.value());

      // act & assert
      expect(repository.updateConfiguration(tParams), completes);
    });

    test('should propagate exception when update fails', () async {
      // arrange
      const tEnvironment = Environment.prod;
      final tParams = EnvironmentConfigUpdateParams(tEnvironment);
      final tException = Exception('Failed to update configuration');

      when(
        mockLocalDataSource.updateConfiguration(
          tEnvironment,
          baseUrlConfig: null,
        ),
      ).thenThrow(tException);

      // act & assert
      expect(
        () => repository.updateConfiguration(tParams),
        throwsA(equals(tException)),
      );
    });
  });

  group('loginAsDeveloper', () {
    test('should return true when credentials are valid', () {
      // arrange
      const tEnvironment = Environment.dev;
      const tUsername = 'dev_user';
      const tPassword = 'dev_password';
      final tParams = DevLoginParams(username: tUsername, password: tPassword);
      final tAuthConfig = AuthConfig(username: tUsername, password: tPassword);

      when(mockLocalDataSource.currentEnvironment).thenReturn(tEnvironment);
      when(
        mockLocalDataSource.getAuthConfigForEnvironment(tEnvironment),
      ).thenReturn(tAuthConfig);

      // act
      final result = repository.loginAsDeveloper(tParams);

      // assert
      expect(result, isTrue);
      verify(mockLocalDataSource.currentEnvironment);
      verify(mockLocalDataSource.getAuthConfigForEnvironment(tEnvironment));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return false when username is incorrect', () {
      // arrange
      const tEnvironment = Environment.dev;
      const tCorrectUsername = 'dev_user';
      const tIncorrectUsername = 'wrong_user';
      const tPassword = 'dev_password';
      final tParams = DevLoginParams(
        username: tIncorrectUsername,
        password: tPassword,
      );
      final tAuthConfig = AuthConfig(
        username: tCorrectUsername,
        password: tPassword,
      );

      when(mockLocalDataSource.currentEnvironment).thenReturn(tEnvironment);
      when(
        mockLocalDataSource.getAuthConfigForEnvironment(tEnvironment),
      ).thenReturn(tAuthConfig);

      // act
      final result = repository.loginAsDeveloper(tParams);

      // assert
      expect(result, isFalse);
      verify(mockLocalDataSource.currentEnvironment);
      verify(mockLocalDataSource.getAuthConfigForEnvironment(tEnvironment));
    });

    test('should return false when password is incorrect', () {
      // arrange
      const tEnvironment = Environment.stage;
      const tUsername = 'staging_user';
      const tCorrectPassword = 'staging_password';
      const tIncorrectPassword = 'wrong_password';
      final tParams = DevLoginParams(
        username: tUsername,
        password: tIncorrectPassword,
      );
      final tAuthConfig = AuthConfig(
        username: tUsername,
        password: tCorrectPassword,
      );

      when(mockLocalDataSource.currentEnvironment).thenReturn(tEnvironment);
      when(
        mockLocalDataSource.getAuthConfigForEnvironment(tEnvironment),
      ).thenReturn(tAuthConfig);

      // act
      final result = repository.loginAsDeveloper(tParams);

      // assert
      expect(result, isFalse);
      verify(mockLocalDataSource.currentEnvironment);
      verify(mockLocalDataSource.getAuthConfigForEnvironment(tEnvironment));
    });

    test(
      'should return false when both username and password are incorrect',
      () {
        // arrange
        const tEnvironment = Environment.prod;
        const tCorrectUsername = 'prod_user';
        const tCorrectPassword = 'prod_password';
        const tIncorrectUsername = 'wrong_user';
        const tIncorrectPassword = 'wrong_password';
        final tParams = DevLoginParams(
          username: tIncorrectUsername,
          password: tIncorrectPassword,
        );
        final tAuthConfig = AuthConfig(
          username: tCorrectUsername,
          password: tCorrectPassword,
        );

        when(mockLocalDataSource.currentEnvironment).thenReturn(tEnvironment);
        when(
          mockLocalDataSource.getAuthConfigForEnvironment(tEnvironment),
        ).thenReturn(tAuthConfig);

        // act
        final result = repository.loginAsDeveloper(tParams);

        // assert
        expect(result, isFalse);
      },
    );

    test('should use current environment for authentication', () {
      // arrange
      const tEnvironment = Environment.stage;
      const tUsername = 'staging_user';
      const tPassword = 'staging_password';
      final tParams = DevLoginParams(username: tUsername, password: tPassword);
      final tAuthConfig = AuthConfig(username: tUsername, password: tPassword);

      when(mockLocalDataSource.currentEnvironment).thenReturn(tEnvironment);
      when(
        mockLocalDataSource.getAuthConfigForEnvironment(tEnvironment),
      ).thenReturn(tAuthConfig);

      // act
      final result = repository.loginAsDeveloper(tParams);

      // assert
      expect(result, isTrue);
      verify(mockLocalDataSource.currentEnvironment).called(1);
      verify(
        mockLocalDataSource.getAuthConfigForEnvironment(tEnvironment),
      ).called(1);
    });

    test('should handle empty credentials', () {
      // arrange
      const tEnvironment = Environment.dev;
      const tEmptyUsername = '';
      const tEmptyPassword = '';
      const tCorrectUsername = 'dev_user';
      const tCorrectPassword = 'dev_password';
      final tParams = DevLoginParams(
        username: tEmptyUsername,
        password: tEmptyPassword,
      );
      final tAuthConfig = AuthConfig(
        username: tCorrectUsername,
        password: tCorrectPassword,
      );

      when(mockLocalDataSource.currentEnvironment).thenReturn(tEnvironment);
      when(
        mockLocalDataSource.getAuthConfigForEnvironment(tEnvironment),
      ).thenReturn(tAuthConfig);

      // act
      final result = repository.loginAsDeveloper(tParams);

      // assert
      expect(result, isFalse);
    });
  });

  group('integration tests', () {
    test('should handle complete workflow of switching environments', () {
      // arrange - start with dev environment
      const tDevEnvironment = Environment.dev;
      final tDevConfig = APIConfig(
        apiKey: 'dev_key',
        baseUrl: 'https://api.dev.com',
        environment: tDevEnvironment,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockLocalDataSource.currentEnvironment).thenReturn(tDevEnvironment);
      when(mockLocalDataSource.currentApiConfig).thenReturn(tDevConfig);

      // act & assert - verify dev environment
      expect(repository.currentEnvironment, equals(Environment.dev));
      expect(
        repository.currentApiConfig.baseUrl,
        equals('https://api.dev.com'),
      );

      // arrange - switch to production
      const tProdEnvironment = Environment.prod;
      final tProdConfig = APIConfig(
        apiKey: 'prod_key',
        baseUrl: 'https://api.production.com',
        environment: tDevEnvironment,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockLocalDataSource.currentEnvironment).thenReturn(tProdEnvironment);
      when(mockLocalDataSource.currentApiConfig).thenReturn(tProdConfig);

      // act & assert - verify production environment
      expect(repository.currentEnvironment, equals(Environment.prod));
      expect(
        repository.currentApiConfig.baseUrl,
        equals('https://api.production.com'),
      );
    });

    test(
      'should authenticate developer and access correct environment config',
      () {
        // arrange
        const tEnvironment = Environment.dev;
        const tUsername = 'dev_user';
        const tPassword = 'dev_password';
        final tParams = DevLoginParams(
          username: tUsername,
          password: tPassword,
        );
        final tAuthConfig = AuthConfig(
          username: tUsername,
          password: tPassword,
        );
        final tApiConfig = APIConfig(
          apiKey: 'dev_key',
          baseUrl: 'https://api.dev.com',
          environment: Environment.dev,
          baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
        );

        when(mockLocalDataSource.currentEnvironment).thenReturn(tEnvironment);
        when(
          mockLocalDataSource.getAuthConfigForEnvironment(tEnvironment),
        ).thenReturn(tAuthConfig);
        when(mockLocalDataSource.currentApiConfig).thenReturn(tApiConfig);

        // act
        final isAuthenticated = repository.loginAsDeveloper(tParams);
        final apiConfig = repository.currentApiConfig;

        // assert
        expect(isAuthenticated, isTrue);
        expect(apiConfig.baseUrl, equals('https://api.dev.com'));
      },
    );
  });
}
