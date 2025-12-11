import 'package:flutter_starter_kit/core/infrastructure/domain/entities/no_params.dart';
import 'package:flutter_starter_kit/features/environments_dev/data/models/base_url_config.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/api_config.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/environment.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/usecases/get_current_config_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/helper_test.mocks.dart';


void main() {
  late GetCurrentApiConfigUseCase useCase;
  late MockEnvironmentRepository mockRepository;

  setUp(() {
    mockRepository = MockEnvironmentRepository();
    useCase = GetCurrentApiConfigUseCase(mockRepository);
  });

  group('GetCurrentApiConfigUseCase', () {
    test('should return current API config from repository', () {
      // arrange
      final tApiConfig = APIConfig(
        apiKey: 'test_api_key_123',
        baseUrl: 'https://api.test.com',
        environment: Environment.dev,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.currentApiConfig).thenReturn(tApiConfig);

      // act
      final result = useCase(const NoParams());

      // assert
      expect(result, equals(tApiConfig));
      verify(mockRepository.currentApiConfig);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return development API config', () {
      // arrange
      final tApiConfig = APIConfig(
        apiKey: 'dev_api_key',
        baseUrl: 'https://api.dev.example.com',
        environment: Environment.dev,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.currentApiConfig).thenReturn(tApiConfig);

      // act
      final result = useCase(const NoParams());

      // assert
      expect(result.apiKey, equals('dev_api_key'));
      expect(result.baseUrl, equals('https://api.dev.example.com'));
      verify(mockRepository.currentApiConfig);
    });

    test('should return staging API config', () {
      // arrange
      final tApiConfig = APIConfig(
        apiKey: 'staging_api_key',
        baseUrl: 'https://api.staging.example.com',
        environment: Environment.stage,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.currentApiConfig).thenReturn(tApiConfig);

      // act
      final result = useCase(const NoParams());

      // assert
      expect(result.apiKey, equals('staging_api_key'));
      expect(result.baseUrl, equals('https://api.staging.example.com'));
      verify(mockRepository.currentApiConfig);
    });

    test('should return production API config', () {
      // arrange
      final tApiConfig = APIConfig(
        apiKey: 'prod_api_key',
        baseUrl: 'https://api.production.example.com',
        environment: Environment.prod,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.currentApiConfig).thenReturn(tApiConfig);

      // act
      final result = useCase(const NoParams());

      // assert
      expect(result.apiKey, equals('prod_api_key'));
      expect(result.baseUrl, equals('https://api.production.example.com'));
      verify(mockRepository.currentApiConfig);
    });

    test('should handle API config with custom base URL', () {
      // arrange
      final tApiConfig = APIConfig(
        apiKey: 'custom_api_key',
        baseUrl: 'http://localhost:8080',
        environment: Environment.dev,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.currentApiConfig).thenReturn(tApiConfig);

      // act
      final result = useCase(const NoParams());

      // assert
      expect(result.baseUrl, equals('http://localhost:8080'));
      verify(mockRepository.currentApiConfig);
    });

    test('should call repository exactly once', () {
      // arrange
      final tApiConfig = APIConfig(
        apiKey: 'test_key',
        baseUrl: 'https://api.test.com',
        environment: Environment.stage,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.currentApiConfig).thenReturn(tApiConfig);

      // act
      useCase(const NoParams());

      // assert
      verify(mockRepository.currentApiConfig).called(1);
    });

    test('should return config with valid HTTPS URL', () {
      // arrange
      final tApiConfig = APIConfig(
        apiKey: 'secure_key',
        baseUrl: 'https://secure.api.example.com',
        environment: Environment.prod,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.currentApiConfig).thenReturn(tApiConfig);

      // act
      final result = useCase(const NoParams());

      // assert
      expect(result.baseUrl, startsWith('https://'));
    });

    test('should handle multiple consecutive calls', () {
      // arrange
      final tApiConfig = APIConfig(
        apiKey: 'test_key',
        baseUrl: 'https://api.test.com',
        environment: Environment.prod,
        baseUrlConfig: BaseUrlConfigModel.defaultUrl(),
      );

      when(mockRepository.currentApiConfig).thenReturn(tApiConfig);

      // act
      final result1 = useCase(const NoParams());
      final result2 = useCase(const NoParams());

      // assert
      expect(result1, equals(result2));
      verify(mockRepository.currentApiConfig).called(2);
    });
  });
}