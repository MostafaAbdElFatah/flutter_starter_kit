import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helper/helper_test.mocks.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/environment.dart';
import 'package:flutter_starter_kit/features/environments_dev/data/storage/environment_config_service.dart';
import 'package:flutter_starter_kit/features/environments_dev/data/models/base_url_config.dart';
import 'package:flutter_starter_kit/features/environments_dev/data/models/env_data.dart';

void main() {
  late MockStorageService mockStorage;
  late EnvironmentConfigStorageService service;

  setUp(() {
    mockStorage = MockStorageService();
    service = EnvironmentConfigStorageService(storageService: mockStorage);
  });

  group("currentEnvironment", () {
    test("returns saved environment when present", () {
      // Arrange
      when(
        mockStorage.get(any, defaultValue: anyNamed('defaultValue')),
      ).thenReturn(Environment.prod.index);

      // Act
      final env = service.currentEnvironment;

      // Assert
      expect(env, Environment.prod);
      verify(mockStorage.get('app_env', defaultValue: 0)).called(1);
    });

    test("returns default (dev) when nothing saved", () {
      // Arrange
      when(
        mockStorage.get(any, defaultValue: anyNamed('defaultValue')),
      ).thenReturn(0);

      // Act
      final env = service.currentEnvironment;

      // Assert
      expect(env, Environment.dev);
    });
  });

  group("getAuthConfigForEnvironment", () {
    test("returns correct dev credentials from EnvData", () {
      // Arrange
      final env = Environment.stage;
      final data = EnvData.get(env);

      // Act
      final auth = service.getAuthConfigForEnvironment(env);

      // Assert
      expect(auth.username, data.devUser);
      expect(auth.password, data.devPass);
    });
  });

  group("getConfigForEnvironment", () {
    test(
      "loads defaultUrl BaseUrlConfigModel from storage and static EnvData",
      () {
        // Arrange
        final env = Environment.prod;
        const savedConfig = BaseUrlConfigModel.defaultUrl();

        when(
          mockStorage.getJson<BaseUrlConfigModel>(
            key: "${env.name}_env_base_url_config",
            fromJson: anyNamed('fromJson'),
            defaultValue: anyNamed('defaultValue'),
          ),
        ).thenAnswer((_) => savedConfig);

        final data = EnvData.get(env);

        // Act
        final config = service.getConfigForEnvironment(env);

        // Assert
        expect(config.environment, env);
        expect(config.apiKey, data.apiKey);
        expect(config.baseUrl, data.defaultBaseUrl);
        expect(config.baseUrlConfig.customUrl, savedConfig.customUrl);
        expect(
          config.baseUrlConfig.customUrl,
          isNot(equals(data.defaultBaseUrl)),
        );
        expect(
          config.baseUrlConfig.customUrl,
          BaseUrlConfigModel.defaultUrl().customUrl,
        );
      },
    );

    test("loads custom BaseUrlConfigModel from storage and static EnvData", () {
      // Arrange
      final env = Environment.stage;

      const customUrl = "https://override.example.com";
      const savedConfig = BaseUrlConfigModel.custom(customUrl);

      when(
        mockStorage.getJson<BaseUrlConfigModel>(
          key: "${env.name}_env_base_url_config",
          fromJson: anyNamed('fromJson'),
          defaultValue: anyNamed('defaultValue'),
        ),
      ).thenAnswer((_) => savedConfig);

      final data = EnvData.get(env);

      // Act
      final config = service.getConfigForEnvironment(env);

      // Assert
      expect(config.environment, env);
      expect(config.apiKey, data.apiKey);
      expect(config.baseUrl, isNot(equals(data.defaultBaseUrl)));
      expect(config.baseUrlConfig.customUrl, savedConfig.customUrl);
      expect(
        config.baseUrlConfig.customUrl,
        isNot(equals(data.defaultBaseUrl)),
      );
    });
  });

  group("currentApiConfig", () {
    test("returns config for current environment", () {
      // Arrange
      const environment = Environment.stage;
      when(
        mockStorage.get('app_env', defaultValue: 0),
      ).thenReturn(environment.index);

      when(
        mockStorage.getJson<BaseUrlConfigModel>(
          key: "${environment.name}_env_base_url_config",
          fromJson: anyNamed('fromJson'),
          defaultValue: anyNamed('defaultValue'),
        ),
      ).thenReturn(const BaseUrlConfigModel.defaultUrl());

      final data = EnvData.get(environment);

      // Act
      final config = service.currentApiConfig;

      // Assert
      expect(config.environment, environment);
      expect(config.apiKey, data.apiKey);
    });
  });

  group("updateConfiguration", () {
    test("writes env index only when baseUrlConfig is null", () async {
      // Arrange
      when(
        mockStorage.put(key: anyNamed('key'), value: anyNamed('value')),
      ).thenAnswer((_) async {});

      // Act
      await service.updateConfiguration(Environment.prod);

      // Assert
      verify(
        mockStorage.put(key: 'app_env', value: Environment.prod.index),
      ).called(1);
      verifyNever(
        mockStorage.putJson(key: anyNamed('key'), value: anyNamed('value')),
      );
    });

    test("writes env index and baseUrlConfig when provided", () async {
      // Arrange
      const newConfig = BaseUrlConfigModel.custom("https://custom.com");

      when(
        mockStorage.put(key: anyNamed('key'), value: anyNamed('value')),
      ).thenAnswer((_) async {});
      when(
        mockStorage.putJson(key: anyNamed('key'), value: anyNamed('value')),
      ).thenAnswer((_) async => {});

      // Act
      await service.updateConfiguration(
        Environment.dev,
        baseUrlConfig: newConfig,
      );

      // Assert
      verify(
        mockStorage.put(key: 'app_env', value: Environment.dev.index),
      ).called(1);

      verify(
        mockStorage.putJson(key: "dev_env_base_url_config", value: newConfig),
      ).called(1);
    });
  });
}
