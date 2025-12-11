import 'package:flutter_starter_kit/features/environments_dev/data/datasources/environment_local_data_source.dart';
import 'package:flutter_starter_kit/features/environments_dev/data/models/auth_config.dart';
import 'package:flutter_starter_kit/features/environments_dev/data/models/base_url_config.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/api_config.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/environment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/helper_test.mocks.dart';

void main() {
  late EnvironmentLocalDataSourceImpl dataSource;
  late MockEnvironmentConfigService mockEnvironmentConfigService;

  setUp(() {
    mockEnvironmentConfigService = MockEnvironmentConfigService();
    dataSource = EnvironmentLocalDataSourceImpl(
      environmentConfigService: mockEnvironmentConfigService,
    );
  });

  group('currentApiConfig', () {
    test(
      'should return current API config from environment config service',
      () {
        // arrange
        final tApiConfig = APIConfig(
          apiKey: 'test_api_key',
          baseUrl: 'https://api.test.com',
          environment:  Environment.dev,
          baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
        );

        when(
          mockEnvironmentConfigService.currentApiConfig,
        ).thenReturn(tApiConfig);

        // act
        final result = dataSource.currentApiConfig;

        // assert
        expect(result, equals(tApiConfig));
        verify(mockEnvironmentConfigService.currentApiConfig);
        verifyNoMoreInteractions(mockEnvironmentConfigService);
      },
    );
  });

  group('currentEnvironment', () {
    test(
      'should return current environment from environment config service',
      () {
        // arrange
        const tEnvironment = Environment.dev;

        when(
          mockEnvironmentConfigService.currentEnvironment,
        ).thenReturn(tEnvironment);

        // act
        final result = dataSource.currentEnvironment;

        // assert
        expect(result, equals(Environment.dev));
        verify(mockEnvironmentConfigService.currentEnvironment);
        verifyNoMoreInteractions(mockEnvironmentConfigService);
      },
    );
  });

  group('getAuthConfigForEnvironment', () {
    test('should return auth config for development environment', () {
      // arrange
      const tEnvironment = Environment.dev;
      final tAuthConfig = AuthConfig(
        username: 'dev_user',
        password: 'dev_password',
      );

      when(
        mockEnvironmentConfigService.getAuthConfigForEnvironment(tEnvironment),
      ).thenReturn(tAuthConfig);

      // act
      final result = dataSource.getAuthConfigForEnvironment(tEnvironment);

      // assert
      expect(result, equals(tAuthConfig));
      expect(result.username, equals('dev_user'));
      expect(result.password, equals('dev_password'));
      verify(
        mockEnvironmentConfigService.getAuthConfigForEnvironment(tEnvironment),
      );
      verifyNoMoreInteractions(mockEnvironmentConfigService);
    });

    test('should return auth config for staging environment', () {
      // arrange
      const tEnvironment = Environment.stage;
      final tAuthConfig = AuthConfig(
        username: 'staging_user',
        password: 'staging_password',
      );

      when(
        mockEnvironmentConfigService.getAuthConfigForEnvironment(tEnvironment),
      ).thenReturn(tAuthConfig);

      // act
      final result = dataSource.getAuthConfigForEnvironment(tEnvironment);

      // assert
      expect(result, equals(tAuthConfig));
      verify(
        mockEnvironmentConfigService.getAuthConfigForEnvironment(tEnvironment),
      );
    });
  });

  group('getConfigForEnvironment', () {
    test('should return API config for development environment', () {
      // arrange
      const tEnvironment = Environment.dev;
      final tApiConfig = APIConfig(
        apiKey: 'dev_api_key',
        baseUrl: 'https://api.dev.com',
        environment:  tEnvironment,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(
        mockEnvironmentConfigService.getConfigForEnvironment(tEnvironment),
      ).thenReturn(tApiConfig);

      // act
      final result = dataSource.getConfigForEnvironment(tEnvironment);

      // assert
      expect(result, equals(tApiConfig));
      expect(result.apiKey, equals('dev_api_key'));
      expect(result.baseUrl, equals('https://api.dev.com'));
      verify(
        mockEnvironmentConfigService.getConfigForEnvironment(tEnvironment),
      );
      verifyNoMoreInteractions(mockEnvironmentConfigService);
    });

    test('should return API config for production environment', () {
      // arrange
      const tEnvironment = Environment.prod;
      final tApiConfig = APIConfig(
        apiKey: 'prod_api_key',
        baseUrl: 'https://api.production.com',
        environment:  tEnvironment,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(
        mockEnvironmentConfigService.getConfigForEnvironment(tEnvironment),
      ).thenReturn(tApiConfig);

      // act
      final result = dataSource.getConfigForEnvironment(tEnvironment);

      // assert
      expect(result.apiKey, equals('prod_api_key'));
      expect(result.baseUrl, equals('https://api.production.com'));
    });
  });

  group('updateConfiguration', () {
    test('should update configuration with environment only', () async {
      // arrange
      const tEnvironment = Environment.stage;

      when(
        mockEnvironmentConfigService.updateConfiguration(
          tEnvironment,
          baseUrlConfig: anyNamed('baseUrlConfig'),
        ),
      ).thenAnswer((_) async => Future.value());

      // act
      await dataSource.updateConfiguration(tEnvironment);

      // assert
      verify(
        mockEnvironmentConfigService.updateConfiguration(
          tEnvironment,
          baseUrlConfig: anyNamed('baseUrlConfig'),
        ),
      );
      verifyNoMoreInteractions(mockEnvironmentConfigService);
    });

    test(
      'should update configuration with environment and base URL config',
      () async {
        // arrange
        const tEnvironment = Environment.prod;
        final tBaseUrlConfig = BaseUrlConfigModel.custom(
          'https://custom.api.com',
        );

        when(
          mockEnvironmentConfigService.updateConfiguration(
            tEnvironment,
            baseUrlConfig: tBaseUrlConfig,
          ),
        ).thenAnswer((_) async => Future.value());

        // act
        await dataSource.updateConfiguration(
          tEnvironment,
          baseUrlConfig: tBaseUrlConfig,
        );

        // assert
        verify(
          mockEnvironmentConfigService.updateConfiguration(
            tEnvironment,
            baseUrlConfig: tBaseUrlConfig,
          ),
        );
        verifyNoMoreInteractions(mockEnvironmentConfigService);
      },
    );

    test('should complete successfully when update is successful', () async {
      // arrange
      const tEnvironment = Environment.stage;

      when(
        mockEnvironmentConfigService.updateConfiguration(
          tEnvironment,
          baseUrlConfig: anyNamed('baseUrlConfig'),
        ),
      ).thenAnswer((_) async => Future.value());

      // act & assert
      expect(dataSource.updateConfiguration(tEnvironment), completes);
    });

    test('should propagate exception when update fails', () async {
      // arrange
      const tEnvironment = Environment.prod;
      final tException = Exception('Failed to update configuration');

      when(
        mockEnvironmentConfigService.updateConfiguration(
          tEnvironment,
          baseUrlConfig: anyNamed('baseUrlConfig'),
        ),
      ).thenThrow(tException);

      // act & assert
      expect(
        () => dataSource.updateConfiguration(tEnvironment),
        throwsA(equals(tException)),
      );
    });
  });
}
