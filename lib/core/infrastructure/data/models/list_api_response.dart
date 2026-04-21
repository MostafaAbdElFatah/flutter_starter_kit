import '../../../extensions/iterable/json_parsing_extensions.dart';
import 'api_response.dart';
import 'typed_api_response.dart';

class ListAPIResponse<T> extends TypedAPIResponse<List<T>> {
  const ListAPIResponse({
    required super.data,
    required super.statusCode,
    super.message,
    super.errors,
    super.pagination,
  });

  /// Private constructor using base APIResponse
  ListAPIResponse.fromBase({
    required super.base,
    required super.data,
  }) : super.fromBase();


  factory ListAPIResponse.fromJson({
    required int? statusCode,
    required String? message,
    required Map<String, dynamic> json,
    required T Function(Map<String, dynamic>) itemFromJson,
  }) {
    return ListAPIResponse.fromBase(
      data: json.getTypedList("data", itemFromJson),
      base: APIResponse.fromJson(statusCode, message, json),
    );
  }
}
