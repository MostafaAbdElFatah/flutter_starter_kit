import 'package:flutter_starter_kit/features/environments_dev/data/models/base_url_config.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/api_config.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/environment.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/use_cases/get_environment_config_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/helper_test.mocks.dart';

void main() {
  late GetEnvironmentConfigUseCase useCase;
  late MockEnvironmentRepository mockRepository;

  setUp(() {
    mockRepository = MockEnvironmentRepository();
    useCase = GetEnvironmentConfigUseCase(mockRepository);
  });

  group('GetEnvironmentConfigUseCase', () {
    test('should return API config for development environment', () {
      // arrange
      const tEnvironment = Environment.dev;
      final tParams = EnvironmentConfigGetParams(tEnvironment);
      final tApiConfig = APIConfig(
        apiKey: 'dev_api_key_123',
        baseUrl: 'https://api.dev.example.com',
        environment: tEnvironment,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.getConfigForEnvironment(tParams))
          .thenReturn(tApiConfig);

      // act
      final result = useCase(tParams);

      // assert
      expect(result, equals(tApiConfig));
      expect(result.apiKey, equals('dev_api_key_123'));
      expect(result.baseUrl, equals('https://api.dev.example.com'));
      verify(mockRepository.getConfigForEnvironment(tParams));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return API config for staging environment', () {
      // arrange
      const tEnvironment = Environment.stage;
      final tParams = EnvironmentConfigGetParams(tEnvironment);
      final tApiConfig = APIConfig(
        apiKey: 'staging_api_key_456',
        baseUrl: 'https://api.staging.example.com',
        environment: tEnvironment,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.getConfigForEnvironment(tParams))
          .thenReturn(tApiConfig);

      // act
      final result = useCase(tParams);

      // assert
      expect(result.apiKey, equals('staging_api_key_456'));
      expect(result.baseUrl, equals('https://api.staging.example.com'));
      verify(mockRepository.getConfigForEnvironment(tParams));
    });

    test('should return API config for production environment', () {
      // arrange
      const tEnvironment = Environment.prod;
      final tParams = EnvironmentConfigGetParams(tEnvironment);
      final tApiConfig = APIConfig(
        apiKey: 'prod_api_key_789',
        baseUrl: 'https://api.production.example.com',
        environment: tEnvironment,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.getConfigForEnvironment(tParams))
          .thenReturn(tApiConfig);

      // act
      final result = useCase(tParams);

      // assert
      expect(result.apiKey, equals('prod_api_key_789'));
      expect(result.baseUrl, equals('https://api.production.example.com'));
      verify(mockRepository.getConfigForEnvironment(tParams));
    });

    test('should call repository exactly once with correct params', () {
      // arrange
      const tEnvironment = Environment.dev;
      final tParams = EnvironmentConfigGetParams(tEnvironment);
      final tApiConfig = APIConfig(
        apiKey: 'test_key',
        baseUrl: 'https://api.test.com',
        environment: tEnvironment,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.getConfigForEnvironment(tParams))
          .thenReturn(tApiConfig);

      // act
      useCase(tParams);

      // assert
      verify(mockRepository.getConfigForEnvironment(tParams)).called(1);
    });

    test('should handle multiple requests for different environments', () {
      // arrange
      final tDevParams = EnvironmentConfigGetParams(Environment.dev);
      final tStagingParams = EnvironmentConfigGetParams(Environment.stage);
      final tProdParams = EnvironmentConfigGetParams(Environment.prod);

      final tDevConfig = APIConfig(
        apiKey: 'dev_key',
        baseUrl: 'https://api.dev.com',
        environment: tDevParams.env,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );
      final tStagingConfig = APIConfig(
        apiKey: 'staging_key',
        baseUrl: 'https://api.staging.com',
        environment: tStagingParams.env,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );
      final tProdConfig = APIConfig(
        apiKey: 'prod_key',
        baseUrl: 'https://api.production.com',
        environment: tProdParams.env,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.getConfigForEnvironment(tDevParams))
          .thenReturn(tDevConfig);
      when(mockRepository.getConfigForEnvironment(tStagingParams))
          .thenReturn(tStagingConfig);
      when(mockRepository.getConfigForEnvironment(tProdParams))
          .thenReturn(tProdConfig);

      // act
      final devResult = useCase(tDevParams);
      final stagingResult = useCase(tStagingParams);
      final prodResult = useCase(tProdParams);

      // assert
      expect(devResult.baseUrl, equals('https://api.dev.com'));
      expect(stagingResult.baseUrl, equals('https://api.staging.com'));
      expect(prodResult.baseUrl, equals('https://api.production.com'));
    });

    test('should return consistent config for same environment', () {
      // arrange
      const tEnvironment = Environment.dev;
      final tParams = EnvironmentConfigGetParams(tEnvironment);
      final tApiConfig = APIConfig(
        apiKey: 'dev_key',
        baseUrl: 'https://api.dev.com',
        environment: tEnvironment,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.getConfigForEnvironment(tParams))
          .thenReturn(tApiConfig);

      // act
      final result1 = useCase(tParams);
      final result2 = useCase(tParams);

      // assert
      expect(result1, equals(result2));
      verify(mockRepository.getConfigForEnvironment(tParams)).called(2);
    });

    test('should handle config with localhost URL for development', () {
      // arrange
      const tEnvironment = Environment.dev;
      final tParams = EnvironmentConfigGetParams(tEnvironment);
      final tApiConfig = APIConfig(
        apiKey: 'local_key',
        baseUrl: 'http://localhost:8080',
        environment: tEnvironment,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.getConfigForEnvironment(tParams))
          .thenReturn(tApiConfig);

      // act
      final result = useCase(tParams);

      // assert
      expect(result.baseUrl, equals('http://localhost:8080'));
    });

    test('should handle config with IP address for development', () {
      // arrange
      const tEnvironment = Environment.dev;
      final tParams = EnvironmentConfigGetParams(tEnvironment);
      final tApiConfig = APIConfig(
        apiKey: 'ip_key',
        baseUrl: 'http://192.168.1.100:3000',
        environment: tEnvironment,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.getConfigForEnvironment(tParams))
          .thenReturn(tApiConfig);

      // act
      final result = useCase(tParams);

      // assert
      expect(result.baseUrl, equals('http://192.168.1.100:3000'));
    });
  });
}