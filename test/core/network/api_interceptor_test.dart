import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_starter_kit/core/infrastructure/data/network/api_interceptor.dart';
import '../../helper/helper_test.mocks.dart';



void main() {
  late APIInterceptor interceptor;
  late MockSecureStorageService mockSecureStorage;
  late MockEnvironmentConfigService mockEnvironmentConfigService;
  late MockRequestInterceptorHandler mockHandler;
  late MockAPIConfig mockApiConfig;
  const expectedApiKey = 'test-api-key';
  const defaultBaseUrl = 'https://api.example.com';

  setUp(() {
    mockSecureStorage = MockSecureStorageService();
    mockEnvironmentConfigService = MockEnvironmentConfigService();
    mockHandler = MockRequestInterceptorHandler();
    mockApiConfig = MockAPIConfig();

    interceptor = APIInterceptor(
      secureStorage: mockSecureStorage,
      environmentConfigService: mockEnvironmentConfigService,
    );

    // Default setup
    when(mockEnvironmentConfigService.currentApiConfig)
        .thenReturn(mockApiConfig);
    when(mockApiConfig.apiKey).thenReturn(expectedApiKey);
    when(mockApiConfig.baseUrl).thenReturn(defaultBaseUrl);
  });

  group('APIInterceptor Tests', () {
    group('onRequest', () {
      test('does NOT add Authorization header when token is null', () async {
        // Arrange
        final options = RequestOptions(path: '/test');
        when(mockSecureStorage.getToken())
            .thenAnswer((_) async => null);
        when(mockHandler.next(any))
            .thenAnswer((_) async {});

        // Act
        await interceptor.onRequest(options, mockHandler);

        // Assert
        expect(options.headers['Authorization'], null);
        expect(options.headers['X-Api-Key'], expectedApiKey);
        expect(options.headers.containsKey('Authorization'), false);
        verify(mockEnvironmentConfigService.currentApiConfig).called(1);
        verify(mockSecureStorage.getToken()).called(1);
        verify(mockHandler.next(any)).called(1);
      });

      test('adds API key and Authorization token to request headers', () async {
        // Arrange
        final options = RequestOptions(path: '/test');
        const testToken = 'test-bearer-token';
        when(mockSecureStorage.getToken())
            .thenAnswer((_) async => testToken);
        when(mockHandler.next(any))
            .thenAnswer((_) async {});

        // Act
        await interceptor.onRequest(options, mockHandler);

        // Assert
        expect(options.headers['Authorization'], 'Bearer $testToken');
        expect(options.headers['X-Api-Key'], expectedApiKey);
        verify(mockSecureStorage.getToken()).called(1);
        verify(mockHandler.next(any)).called(1);
      });

      test('should set baseUrl when endpoint is composite', () async {
        // Arrange
        final mockEndpoint = MockAPIEndpoint();
        when(mockEndpoint.isCompositeUrl).thenReturn(true);

        final options = RequestOptions(
          path: '/test',
          extra: {'endpoint': mockEndpoint},
        );

        when(mockSecureStorage.getToken())
            .thenAnswer((_) async => null);
        when(mockHandler.next(any))
            .thenAnswer((_) async {});

        // Act
        await interceptor.onRequest(options, mockHandler);

        // Assert
        expect(options.baseUrl, defaultBaseUrl);
        expect(options.uri.toString(), '$defaultBaseUrl/test');
        expect(options.extra.containsKey('endpoint'), false);
        verify(mockHandler.next(any)).called(1);
      });

      test('should not modify baseUrl when endpoint is not composite', () async {
        // Arrange
        final mockEndpoint = MockAPIEndpoint();
        when(mockEndpoint.isCompositeUrl).thenReturn(false);

        final originalBaseUrl = 'https://original.example.com';
        final options = RequestOptions(
          path: '/test',
          baseUrl: originalBaseUrl,
          extra: {'endpoint': mockEndpoint},
        );

        when(mockSecureStorage.getToken())
            .thenAnswer((_) async => null);
        when(mockHandler.next(any))
            .thenAnswer((_) async {});

        // Act
        await interceptor.onRequest(options, mockHandler);

        // Assert
        expect(options.baseUrl, originalBaseUrl);
        expect(options.extra.containsKey('endpoint'), false);
        expect(options.baseUrl, isNot(equals(defaultBaseUrl)));
      });

      test('should not modify baseUrl when endpoint is null', () async {
        // Arrange
        final originalBaseUrl = 'https://original.example.com';
        final options = RequestOptions(
          path: '/test',
          baseUrl: originalBaseUrl,
        );

        when(mockSecureStorage.getToken())
            .thenAnswer((_) async => null);
        when(mockHandler.next(any))
            .thenAnswer((_) async {});

        // Act
        await interceptor.onRequest(options, mockHandler);

        // Assert
        expect(options.baseUrl, originalBaseUrl);
        expect(options.extra.containsKey('endpoint'), false);
        expect(options.baseUrl, isNot(equals(defaultBaseUrl)));
      });

      test('should call super.onRequest with correct parameters', () async {
        // Arrange
        final options = RequestOptions(path: '/test');
        when(mockSecureStorage.getToken())
            .thenAnswer((_) async => null);
        when(mockHandler.next(any))
            .thenAnswer((_) async {});

        // Act
        await interceptor.onRequest(options, mockHandler);

        // Assert
        verify(mockHandler.next(options)).called(1);
      });

      test('should handle all operations together correctly', () async {
        // Arrange
        final mockEndpoint = MockAPIEndpoint();
        when(mockEndpoint.isCompositeUrl).thenReturn(true);

        final options = RequestOptions(
          path: '/test',
          extra: {'endpoint': mockEndpoint},
        );

        const testToken = 'full-test-token';
        when(mockSecureStorage.getToken())
            .thenAnswer((_) async => testToken);
        when(mockHandler.next(any))
            .thenAnswer((_) async {});

        // Act
        await interceptor.onRequest(options, mockHandler);

        // Assert
        expect(options.headers['X-Api-Key'], expectedApiKey);
        expect(options.headers['Authorization'], 'Bearer $testToken');
        expect(options.baseUrl, defaultBaseUrl);
        expect(options.extra.containsKey('endpoint'), false);
        verify(mockHandler.next(options)).called(1);
      });

      test('should handle async token retrieval correctly', () async {
        // Arrange
        final options = RequestOptions(path: '/test');
        when(mockSecureStorage.getToken())
            .thenAnswer((_) => Future.delayed(
          const Duration(milliseconds: 100),
              () => 'delayed-token',
        ));
        when(mockHandler.next(any))
            .thenAnswer((_) async {});

        // Act
        await interceptor.onRequest(options, mockHandler);

        // Assert
        expect(options.headers['Authorization'], 'Bearer delayed-token');
      });
    });
  });
}

    // test('adds API key and Authorization token to request headers', () async {
    //   // Arrange
    //   const jwtToken = 'jwtToken';
    //   final mockConfig = APIConfig(
    //     baseUrl: 'https://api.example.com',
    //     apiKey: 'testApiKey',
    //     environment: Environment.test,
    //     baseUrlConfig: BaseUrlConfig.defaultUrl(),
    //   );
    //
    //   when(configService.currentApiConfig).thenReturn(mockConfig);
    //   when(secureStorage.getToken()).thenAnswer((_) async => jwtToken);
    //   final options = RequestOptions(path: '/test');
    //
    //   // Act
    //   await interceptor.onRequest(options, handler);
    //
    //   // Assert
    //   expect(options.headers['X-Api-Key'], mockConfig.apiKey);
    //   expect(options.headers['Authorization'], 'Bearer $jwtToken}');
    //
    //   verify(handler.next(any)).called(1);
    // });
    //
    // test('does NOT add Authorization header when token is null', () async {
    //   final mockConfig = APIConfig(
    //     baseUrl: 'https://api.example.com',
    //     apiKey: 'testApiKey',
    //     environment: Environment.test,
    //     baseUrlConfig: BaseUrlConfig.defaultUrl(),
    //   );
    //
    //   when(configService.currentApiConfig).thenReturn(mockConfig);
    //   when(secureStorage.getToken()).thenAnswer((_) async => null);
    //
    //   final options = RequestOptions(path: '/test');
    //
    //   await interceptor.onRequest(options, handler);
    //
    //   expect(options.headers['X-Api-Key'], 'testApiKey');
    //   expect(options.headers.containsKey('Authorization'), false);
    //
    //   verify(handler.next(any)).called(1);
    // });
    //
    // test('sets baseUrl when endpoint is composite URL', () async {
    //   final mockConfig = APIConfig(
    //     baseUrl: 'https://new-base.com',
    //     apiKey: 'key123',
    //     environment: Environment.test,
    //     baseUrlConfig: BaseUrlConfig.defaultUrl(),
    //   );
    //
    //   when(configService.currentApiConfig).thenReturn(mockConfig);
    //   when(secureStorage.getToken()).thenAnswer((_) async => null);
    //
    //   final endpoint = APIEndpoint(endpoint: "/test", method: HttpMethod.get);
    //
    //   final options = RequestOptions(
    //     path: '/test',
    //     extra: {'endpoint': endpoint},
    //   );
    //
    //   await interceptor.onRequest(options, handler);
    //
    //   expect(options.baseUrl, equals('https://new-base.com'));
    //   expect(options.extra.containsKey('endpoint'), false);
    //
    //   verify(handler.next(any)).called(1);
    // });
//   });
// }
