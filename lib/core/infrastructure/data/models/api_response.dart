import 'package:equatable/equatable.dart';

import '../../../assets/localization_keys.dart';


/// Represents a generic API response.
///
/// This class is used to standardize the structure of responses from the API,
/// including status codes, messages, and any associated data or errors.
class APIResponse extends Equatable {
  const APIResponse({
    required this.statusCode,
    this.message,
    this.errors,
    this.pagination,
  });

  /// 👇 allows children to reuse parsed base response
  APIResponse.fromBase(APIResponse base)
      : statusCode = base.statusCode,
        message = base.message,
        errors = base.errors,
        pagination = base.pagination;

  /// The HTTP status code of the response.
  final int statusCode;

  /// A message from the server, which can be for success or error scenarios.
  final String? message;

  final Pagination? pagination;

  /// A map of validation errors or other detailed error messages.
  final Map<String, dynamic>? errors;

  /// Validates if the response is a standard HTTP success.
  ///
  /// * **200-299**: Success (OK, Created, No Content, etc.)
  /// * **400-499**: Client Error (Bad Request, Unauthorized)
  /// * **500-599**: Server Error (Internal Server Error)
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  /// Creates a copy of this [APIResponse] but with the given fields replaced with the new values.
  APIResponse copyWith({
    int? statusCode,
    String? message,
    Map<String, dynamic>? errors,
    Pagination? pagination,
  }) =>
      APIResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        pagination: pagination ?? this.pagination,
        errors: errors ?? this.errors,
      );

  /// Creates an [APIResponse] from a JSON object.
  factory APIResponse.fromJson(
    int? statusCode,
    String? message,
    Map<String, dynamic> json,
  ) =>
      APIResponse(
        statusCode: statusCode ?? 0,
        message: json["message"] ?? message,
        errors: json["errors"],
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
      );

  /// Converts this [APIResponse] into a JSON object.
  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "pagination": pagination?.toJson(),
        "errors": errors,
      };

  /// A computed property that returns a consolidated error message.
  ///
  /// It combines the main `message` with any detailed messages from the `errors` map.
  String get errorMessage {
    final trimmedMessage = message?.trim() ?? LocalizationKeys.error;

    final List<String> parts = [
      if (trimmedMessage.isNotEmpty) trimmedMessage,
      if (errors?.values != null && errors!.values.isNotEmpty)
        ...errors!.values.map((value) {
          if (value is List) {
            return value.join('\n');
          } else if (value is String) {
            return value;
          }
          return 'N/A';
        })
    ];
    final Iterable<String> nonEmptyParts =
        parts.where((part) => part.isNotEmpty);
    final String combinedContent = nonEmptyParts.join('\n');
    return combinedContent;
  }

  @override
  List<Object?> get props => [statusCode, message, errors];
}

class Pagination extends Equatable {
  const Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
    required this.path,
    required this.firstPageUrl,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.prevPageUrl,
  });

  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;
  final String? path;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? prevPageUrl;

  Pagination copyWith({
    int? currentPage,
    int? lastPage,
    int? perPage,
    int? total,
    int? from,
    int? to,
    String? path,
    String? firstPageUrl,
    String? lastPageUrl,
    String? nextPageUrl,
    String? prevPageUrl,
  }) {
    return Pagination(
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
      from: from ?? this.from,
      to: to ?? this.to,
      path: path ?? this.path,
      firstPageUrl: firstPageUrl ?? this.firstPageUrl,
      lastPageUrl: lastPageUrl ?? this.lastPageUrl,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
    );
  }

  factory Pagination.fromJson(Map<String, dynamic> json){
    return Pagination(
      currentPage: json["current_page"],
      lastPage: json["last_page"],
      perPage: json["per_page"],
      total: json["total"],
      from: json["from"],
      to: json["to"],
      path: json["path"],
      firstPageUrl: json["first_page_url"],
      lastPageUrl: json["last_page_url"],
      nextPageUrl: json["next_page_url"],
      prevPageUrl: json["prev_page_url"],
    );
  }

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
    "from": from,
    "to": to,
    "path": path,
    "first_page_url": firstPageUrl,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
    "prev_page_url": prevPageUrl,
  };

  @override
  String toString(){
    return "$currentPage, $lastPage, $perPage, $total, $from, $to, $path, $firstPageUrl, $lastPageUrl, $nextPageUrl, $prevPageUrl, ";
  }

  @override
  List<Object?> get props => [
    currentPage, lastPage, perPage, total, from, to, path, firstPageUrl, lastPageUrl, nextPageUrl, prevPageUrl, ];
}
