import '../errors/failure.dart';
import 'api_response.dart';

class TypedAPIResponse<T> extends APIResponse {
  const TypedAPIResponse({
    this.data,
    required super.statusCode,
    super.message,
    super.errors,
    super.links,
    super.meta,
  });

  TypedAPIResponse.fromBase({
    required APIResponse base,
    this.data,
  }) : super.fromBase(base);

  final T? data;

  T get requireData {
    if (data != null) return data as T;
    throw FailureType.invalidData;
  }

  factory TypedAPIResponse.fromJson({
    required int? statusCode,
    required String? message,
    required Map<String, dynamic> json,
    required T Function(Map<String, dynamic>) itemFromJson,
  }) {
    final rawData = json['data'];
    return TypedAPIResponse.fromBase(
      data: itemFromJson(rawData as Map<String, dynamic>),
      base: APIResponse.fromJson(statusCode, message, json),
    );
  }
}
