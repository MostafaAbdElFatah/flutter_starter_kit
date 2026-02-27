import 'api_response.dart';
import 'typed_api_response.dart';

class ListAPIResponse<T> extends TypedAPIResponse<List<T>> {
  const ListAPIResponse({
    required super.data,
    required super.statusCode,
    super.message,
    super.errors,
    super.links,
    super.meta,
  });

  /// Private constructor using base APIResponse
  ListAPIResponse.fromBase({required super.base, required super.data})
    : super.fromBase();

  factory ListAPIResponse.fromJson({
    required int? statusCode,
    required String? message,
    required Map<String, dynamic> json,
    required T Function(Map<String, dynamic>) itemFromJson,
  }) {
    final rawData = json['data'];
    final items = rawData is List
        ? rawData
              .whereType<Map<String, dynamic>>()
              .map(itemFromJson)
              .toList(growable: false)
        : <T>[];

    return ListAPIResponse.fromBase(
      data: items,
      base: APIResponse.fromJson(statusCode, message, json),
    );
  }
}
