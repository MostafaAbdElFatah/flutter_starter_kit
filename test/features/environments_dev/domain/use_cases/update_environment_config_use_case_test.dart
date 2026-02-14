import 'package:flutter_starter_kit/core/infrastructure/errors/failure.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/base_url_config.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/entities/environment.dart';
import 'package:flutter_starter_kit/features/environments_dev/domain/use_cases/update_environment_configuration_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helper/helper_test.mocks.dart';

void main() {
  late UpdateEnvironmentConfigUseCase useCase;
  late MockEnvironmentRepository mockRepository;

  setUp(() {
    mockRepository = MockEnvironmentRepository();
    useCase = UpdateEnvironmentConfigUseCase(mockRepository);
  });

  group('UpdateEnvironmentConfigUseCase', () {
    test(
      'should successfully update configuration with environment only',
      () async {
        // arrange
        const tEnvironment = Environment.stage;
        final tParams = EnvironmentConfigUpdateParams(
          tEnvironment,
          baseUrlConfig: null,
        );

        when(
          mockRepository.updateConfiguration(tParams),
        ).thenAnswer((_) async => Future.value());

        // act
        await useCase(tParams);

        // assert
        verify(mockRepository.updateConfiguration(tParams));
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should successfully update configuration with environment and base URL',
      () async {
        // arrange
        const tEnvironment = Environment.prod;
        final tBaseUrlConfig = BaseUrlConfig.custom(
          'https://custom.api.example.com',
        );
        final tParams = EnvironmentConfigUpdateParams(
          tEnvironment,
          baseUrlConfig: tBaseUrlConfig,
        );

        when(
          mockRepository.updateConfiguration(tParams),
        ).thenAnswer((_) async => Future.value());

        // act
        await useCase(tParams);

        // assert
        verify(mockRepository.updateConfiguration(tParams));
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should update to development environment', () async {
      // arrange
      const tEnvironment = Environment.dev;
      final tParams = EnvironmentConfigUpdateParams(tEnvironment);

      when(
        mockRepository.updateConfiguration(tParams),
      ).thenAnswer((_) async => Future.value());

      // act
      await useCase(tParams);

      // assert
      verify(mockRepository.updateConfiguration(tParams)).called(1);
    });

    test('should update to staging environment', () async {
      // arrange
      const tEnvironment = Environment.stage;
      final tParams = EnvironmentConfigUpdateParams(tEnvironment);

      when(
        mockRepository.updateConfiguration(tParams),
      ).thenAnswer((_) async => Future.value());

      // act
      await useCase(tParams);

      // assert
      verify(mockRepository.updateConfiguration(tParams)).called(1);
    });

    test('should update to production environment', () async {
      // arrange
      const tEnvironment = Environment.prod;
      final tParams = EnvironmentConfigUpdateParams(tEnvironment);

      when(
        mockRepository.updateConfiguration(tParams),
      ).thenAnswer((_) async => Future.value());

      // act
      await useCase(tParams);

      // assert
      verify(mockRepository.updateConfiguration(tParams)).called(1);
    });

    test('should update with custom localhost URL', () async {
      // arrange
      const tEnvironment = Environment.dev;
      final tBaseUrlConfig = BaseUrlConfig.custom('http://localhost:8080');
      final tParams = EnvironmentConfigUpdateParams(
        tEnvironment,
        baseUrlConfig: tBaseUrlConfig,
      );

      when(
        mockRepository.updateConfiguration(tParams),
      ).thenAnswer((_) async => Future.value());

      // act
      await useCase(tParams);

      // assert
      verify(mockRepository.updateConfiguration(tParams)).called(1);
    });

    test('should update with custom IP address URL', () async {
      // arrange
      const tEnvironment = Environment.dev;
      final tBaseUrlConfig = BaseUrlConfig.custom('http://192.168.1.100:3000');
      final tParams = EnvironmentConfigUpdateParams(
        tEnvironment,
        baseUrlConfig: tBaseUrlConfig,
      );

      when(
        mockRepository.updateConfiguration(tParams),
      ).thenAnswer((_) async => Future.value());

      // act
      await useCase(tParams);

      // assert
      verify(mockRepository.updateConfiguration(tParams)).called(1);
    });

    test(
      'should complete successfully when repository update succeeds',
      () async {
        // arrange
        const tEnvironment = Environment.stage;
        final tParams = EnvironmentConfigUpdateParams(tEnvironment);

        when(
          mockRepository.updateConfiguration(tParams),
        ).thenAnswer((_) async => Future.value());

        // act & assert
        expect(useCase(tParams), completes);
      },
    );

    test('should throw exception when repository update fails', () async {
      // arrange
      const tEnvironment = Environment.prod;
      final tParams = EnvironmentConfigUpdateParams(tEnvironment);
      final tException = Exception('Failed to update configuration');

      when(mockRepository.updateConfiguration(tParams)).thenThrow(tException);

      // act & assert
      expect(() => useCase(tParams), throwsA(equals(tException)));
      verify(mockRepository.updateConfiguration(tParams));
    });

    test('should propagate ServerException from repository', () async {
      // arrange
      const tEnvironment = Environment.stage;
      final tParams = EnvironmentConfigUpdateParams(tEnvironment);
      final tException = ServerException('Server error occurred');

      when(mockRepository.updateConfiguration(tParams)).thenThrow(tException);

      // act & assert
      expect(() => useCase(tParams), throwsA(isA<ServerException>()));
    });

    test('should propagate CacheException from repository', () async {
      // arrange
      const tEnvironment = Environment.dev;
      final tParams = EnvironmentConfigUpdateParams(tEnvironment);
      final tException = CacheException('Cache error occurred');

      when(mockRepository.updateConfiguration(tParams)).thenThrow(tException);

      // act & assert
      expect(() => useCase(tParams), throwsA(isA<CacheException>()));
    });

    test('should handle TimeoutException from repository', () async {
      // arrange
      const tEnvironment = Environment.prod;
      final tParams = EnvironmentConfigUpdateParams(tEnvironment);
      final tException = Failure('Operation timed out');

      when(mockRepository.updateConfiguration(tParams)).thenThrow(tException);

      // act & assert
      expect(() => useCase(tParams), throwsA(isA<Failure>()));
    });

    test('should handle multiple sequential updates', () async {
      // arrange
      final tParams1 = EnvironmentConfigUpdateParams(Environment.dev);
      final tParams2 = EnvironmentConfigUpdateParams(Environment.stage);
      final tParams3 = EnvironmentConfigUpdateParams(Environment.prod);

      when(
        mockRepository.updateConfiguration(any),
      ).thenAnswer((_) async => Future.value());

      // act
      await useCase(tParams1);
      await useCase(tParams2);
      await useCase(tParams3);

      // assert
      verify(mockRepository.updateConfiguration(tParams1)).called(1);
      verify(mockRepository.updateConfiguration(tParams2)).called(1);
      verify(mockRepository.updateConfiguration(tParams3)).called(1);
    });

    test('should handle update with non-custom base URL config', () async {
      // arrange
      const tEnvironment = Environment.prod;
      final tBaseUrlConfig = BaseUrlConfig.defaultUrl();
      final tParams = EnvironmentConfigUpdateParams(
        tEnvironment,
        baseUrlConfig: tBaseUrlConfig,
      );

      when(
        mockRepository.updateConfiguration(tParams),
      ).thenAnswer((_) async {});
      // act
      await useCase(tParams);

      // assert
      verify(mockRepository.updateConfiguration(tParams));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
