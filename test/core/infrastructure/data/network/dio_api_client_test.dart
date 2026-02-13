import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_starter_kit/core/extensions/iterable/iterable_extension.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_starter_kit/core/utils/log.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/network/api_client.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/network/api_endpoint.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/network/api_response_parser.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/network/dio_api_client.dart';
import 'package:flutter_starter_kit/core/errors/failure.dart';
import '../../../../helper/helper_test.mocks.dart';

void main() {
  EasyLocalization.logger.enableLevels = [];

  late MockDio mockDio;
  late DioAPIClient client;

  setUp(() {
    mockDio = MockDio();
    client = DioAPIClient(mockDio, _TestAPIResponseParser());
    Log.overrideShouldDebugForTests = true;

    // Default dio headers
    when(mockDio.options).thenReturn(BaseOptions(headers: {'global': 'true'}));
  });

  group('request()', () {
    test('returns parsed model on success', () async {
      // Arrange
      final expectedResult = APIResponse(
        statusCode: 200,
        data: true,
        message: "SUCCESS",
      );

      final expectedResponse = Response(
        requestOptions: RequestOptions(path: "/test"),
        data: {'data': true},
        statusCode: 200,
        statusMessage: "SUCCESS",
      );

      when(mockDio.fetch(any)).thenAnswer((_) async => expectedResponse);

      // Act
      final result = await client.request(
        RequestOptions(path: "/test"),
        mapper: APIResponse.fromJson,
      );

      // Assert
      expect(result, expectedResult);
    });

    test('throws Failure.invalidData when response is not Map', () async {
      // Arrange
      final invalidResponse = Response(
        requestOptions: RequestOptions(path: "/test"),
        data: "invalid",
        statusCode: 200,
      );

      when(mockDio.fetch(any)).thenAnswer((_) async => invalidResponse);

      // Assert
      expect(
        client.request(
          RequestOptions(path: "/test"),
          mapper: APIResponse.fromJson,
        ),
        throwsA(FailureType.invalidData),
      );
    });

    test(
      'handles DioException with valid error body and returns parsed model',
      () async {
        // Arrange
        final expectedResult = APIResponse(
          statusCode: 400,
          error: true,
          message: "BAD REQUEST",
        );
        final dioError = DioException(
          requestOptions: RequestOptions(path: "/test"),
          response: Response(
            requestOptions: RequestOptions(path: "/test"),
            statusCode: 400,
            statusMessage: "BAD REQUEST",
            data: {'error': true},
          ),
          type: DioExceptionType.badResponse,
        );

        when(mockDio.fetch(any)).thenThrow(dioError);

        // Act
        final result = await client.request(
          RequestOptions(path: "/test"),
          mapper: APIResponse.fromJson,
        );

        // Assert
        expect(result, expectedResult);
      },
    );

    test(
      'throws Failure.handle() on DioException without valid error',
      () async {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: "/test"),
          error: "No data",
          type: DioExceptionType.connectionError,
        );

        when(mockDio.fetch(any)).thenThrow(dioError);

        // Assert
        expect(
          client.request(
            RequestOptions(path: "/test"),
            mapper: APIResponse.fromJson,
          ),
          throwsA(isA<FailureType>()),
        );
      },
    );

    test('wraps any unknown exception using Failure.handle()', () async {
      // Arrange
      when(mockDio.fetch(any)).thenThrow(FailureType.errorOccurred);

      // Assert
      expect(
        client.request(
          RequestOptions(path: "/test"),
          mapper: APIResponse.fromJson,
        ),
        throwsA(isA<FailureType>()),
      );
    });
  });

  group('fetch()', () {
    test('APIEndpoint', () async {
      // Arrange
      APIEndpoint endpoint = APIEndpoint(
        endpoint: "/fetch",
        //apiVersion: 'v2',
        method: HttpMethod.get,
        headers: {"h1": "v1", "nullHeader": null}.removeNulls,
        body: {"b1": "v1", "nullField": null}.removeNulls,
        queryParameters: {"q1": "v1", "nullQuery": null}.removeNulls,
      );

      final response = Response(
        requestOptions: RequestOptions(path: endpoint.path),
        data: {"data": true},
        statusCode: 200,
      );

      // final expectedResult = APIResponse(statusCode: 200, data: true);
      when(mockDio.fetch(any)).thenAnswer((_) async => response);

      // Act
      final _ = await client.fetch(
        target: endpoint,
        mapper: APIResponse.fromJson,
      );

      // Assert
      final captured =
          verify(mockDio.fetch(captureAny)).captured.single as RequestOptions;

      expect(captured.path, "/api/v1/fetch");
      //expect(captured.path, "/api/v2/fetch");
    });

    test('APIEndpoint.custom', () async {
      // Arrange
      APIEndpoint endpoint = APIEndpoint.custom(
        endpoint: "/fetch",
        method: HttpMethod.get,
        headers: {"h1": "v1", "nullHeader": null}.removeNulls,
        body: {"b1": "v1", "nullField": null}.removeNulls,
        queryParameters: {"q1": "v1", "nullQuery": null}.removeNulls,
      );

      final response = Response(
        requestOptions: RequestOptions(path: endpoint.path),
        data: {"data": true},
        statusCode: 200,
      );

      // final expectedResult = APIResponse(statusCode: 200, data: true);
      when(mockDio.fetch(any)).thenAnswer((_) async => response);

      // Act
      final _ = await client.fetch(
        target: endpoint,
        mapper: APIResponse.fromJson,
      );

      // Assert
      final captured =
          verify(mockDio.fetch(captureAny)).captured.single as RequestOptions;

      expect(captured.path, "/fetch");
    });

    test('APIEndpoint.fullUrl', () async {
      // Arrange
      const defaultBaseUrl = 'https://api.example.com';
      APIEndpoint endpoint = APIEndpoint.fullUrl(
        fullUrl: "$defaultBaseUrl/fetch",
        method: HttpMethod.get,
        headers: {"h1": "v1", "nullHeader": null}.removeNulls,
        body: {"b1": "v1", "nullField": null}.removeNulls,
        queryParameters: {"q1": "v1", "nullQuery": null}.removeNulls,
      );

      final response = Response(
        requestOptions: RequestOptions(path: endpoint.path),
        data: {"data": true},
        statusCode: 200,
      );

      // final expectedResult = APIResponse(statusCode: 200, data: true);
      when(mockDio.fetch(any)).thenAnswer((_) async => response);

      // Act
      final _ = await client.fetch(
        target: endpoint,
        mapper: APIResponse.fromJson,
      );

      // Assert
      final captured =
          verify(mockDio.fetch(captureAny)).captured.single as RequestOptions;

      expect(captured.path, "$defaultBaseUrl/fetch");
    });

    test('merges dio headers + removes nulls + calls request()', () async {
      // Arrange
      APIEndpoint endpoint = APIEndpoint.custom(
        endpoint: "/fetch",
        method: HttpMethod.get,
        headers: {"h1": "v1", "nullHeader": null}.removeNulls,
        body: {"b1": "v1", "nullField": null}.removeNulls,
        queryParameters: {"q1": "v1", "nullQuery": null}.removeNulls,
      );

      final response = Response(
        requestOptions: RequestOptions(path: endpoint.path),
        data: {"data": true},
        statusCode: 200,
      );

      final expectedResult = APIResponse(statusCode: 200, data: true);
      when(mockDio.fetch(any)).thenAnswer((_) async => response);

      // Act
      final result = await client.fetch(
        target: endpoint,
        mapper: APIResponse.fromJson,
      );

      // Assert
      expect(result, expectedResult);

      // Capture request options
      final captured =
          verify(mockDio.fetch(captureAny)).captured.single as RequestOptions;

      expect(captured.path, "/fetch");
      expect(captured.data.containsKey("nullField"), false);
      expect(captured.headers.containsKey("h1"), true);
      expect(captured.headers.containsKey("global"), true);
      expect(captured.queryParameters.containsKey("nullQuery"), false);
      expect(captured.headers.containsKey("nullHeader"), false);
      expect(captured.queryParameters.containsKey("nullQuery"), false);
    });
  });

  group('GET / POST / PUT / DELETE / PATCH wrappers', () {
    test('GET delegates to request()', () async {
      // Arrange
      final expectedResult = APIResponse(statusCode: 200);
      when(mockDio.fetch(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: "/g"),
          data: {},
          statusCode: 200,
        ),
      );

      // Act
      final result = await client.get("/g", mapper: APIResponse.fromJson);

      // Assert
      expect(result, expectedResult);
    });

    test('POST works', () async {
      // Arrange
      final expectedResult = APIResponse(statusCode: 201);
      when(mockDio.fetch(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: "/p"),
          data: {},
          statusCode: 201,
        ),
      );

      // Act
      final result = await client.post("/p", mapper: APIResponse.fromJson);

      // Assert
      expect(result, expectedResult);
    });

    test('PUT works', () async {
      // Arrange
      final expectedResult = APIResponse(statusCode: 200);
      when(mockDio.fetch(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: "/u"),
          data: {},
          statusCode: 200,
        ),
      );

      // Act
      final result = await client.put("/u", mapper: APIResponse.fromJson);

      // Assert
      expect(result, expectedResult);
    });

    test('DELETE works', () async {
      // Arrange
      final expectedResult = APIResponse(statusCode: 204);
      when(mockDio.fetch(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: "/d"),
          data: {},
          statusCode: 204,
        ),
      );

      // Act
      final result = await client.delete("/d", mapper: APIResponse.fromJson);

      // Assert
      expect(result, expectedResult);
    });

    test('PATCH works', () async {
      // Arrange
      final expectedResult = APIResponse(statusCode: 200);
      when(mockDio.fetch(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: "/pa"),
          data: {},
          statusCode: 200,
        ),
      );

      // Act
      final result = await client.patch("/pa", mapper: APIResponse.fromJson);

      // Assert
      expect(result, expectedResult);
    });
  });
}

class _TestAPIResponseParser implements APIResponseParser {
  @override
  Future<T> parse<T>({
    required int? statusCode,
    required String? message,
    required Map<String, dynamic> data,
    required APICallback parser,
  }) async => parser(statusCode, message, data) as T;
}

class APIResponse extends Equatable {
  const APIResponse({
    required this.statusCode,
    this.data,
    this.message,
    this.error,
  });

  final bool? data;
  final bool? error;
  final String? message;
  final int statusCode;

  /// Creates an [APIResponse] from a JSON object.
  factory APIResponse.fromJson(
    int? statusCode,
    String? message,
    Map<String, dynamic> json,
  ) => APIResponse(
    statusCode: statusCode ?? 0,
    message: json["message"] ?? message,
    error: json["error"],
    data: json["data"],
  );

  /// Converts this [APIResponse] into a JSON object.
  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "error": error,
    "data": data,
  };

  @override
  List<Object?> get props => [statusCode, message, data, error];
}
