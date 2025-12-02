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
    this.links,
    this.meta,
    this.errors,
  });

  /// The HTTP status code of the response.
  final int statusCode;

  /// A message from the server, which can be for success or error scenarios.
  final String? message;

  /// Pagination links, if available.
  final Links? links;

  /// Metadata about the response, including pagination details.
  final Meta? meta;

  /// A map of validation errors or other detailed error messages.
  final Map<String, dynamic>? errors;

  /// Creates a copy of this [APIResponse] but with the given fields replaced with the new values.
  APIResponse copyWith({
    int? statusCode,
    String? message,
    Map<String, dynamic>? errors,
    Links? links,
    Meta? meta,
  }) =>
      APIResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        errors: errors ?? this.errors,
        links: links ?? this.links,
        meta: meta ?? this.meta,
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
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  /// Converts this [APIResponse] into a JSON object.
  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "links": links?.toJson(),
        "meta": meta?.toJson(),
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
  List<Object?> get props => [statusCode, message, links, meta, errors];
}

/// Represents pagination links in an API response.
class Links extends Equatable {
  const Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  /// The URL for the first page of results.
  final String? first;

  /// The URL for the last page of results.
  final String? last;

  /// The URL for the previous page of results.
  final String? prev;

  /// The URL for the next page of results.
  final String? next;

  /// Creates a copy of this [Links] but with the given fields replaced with the new values.
  Links copyWith({
    String? first,
    String? last,
    String? prev,
    String? next,
  }) =>
      Links(
        first: first ?? this.first,
        last: last ?? this.last,
        prev: prev ?? this.prev,
        next: next ?? this.next,
      );

  /// Creates a [Links] object from a JSON map.
  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  /// Converts this [Links] object into a JSON map.
  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };

  @override
  List<Object?> get props => [first, last, prev, next];
}

/// Represents metadata for a paginated API response.
class Meta extends Equatable {
  const Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links = const [],
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  /// The current page number.
  final int? currentPage;

  /// The index of the first item on the current page.
  final int? from;

  /// The last page number.
  final int? lastPage;

  /// A list of links for pagination.
  final List<Link> links;

  /// The base path for the API endpoint.
  final String? path;

  /// The number of items per page.
  final int? perPage;

  /// The index of the last item on the current page.
  final int? to;

  /// The total number of items across all pages.
  final int? total;

  /// Creates a copy of this [Meta] but with the given fields replaced with the new values.
  Meta copyWith({
    int? currentPage,
    int? from,
    int? lastPage,
    List<Link>? links,
    String? path,
    int? perPage,
    int? to,
    int? total,
  }) =>
      Meta(
        currentPage: currentPage ?? this.currentPage,
        from: from ?? this.from,
        lastPage: lastPage ?? this.lastPage,
        links: links ?? this.links,
        path: path ?? this.path,
        perPage: perPage ?? this.perPage,
        to: to ?? this.to,
        total: total ?? this.total,
      );

  /// Creates a [Meta] object from a JSON map.
  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  /// Converts this [Meta] object into a JSON map.
  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": links.map((x) => x.toJson()).toList(),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };

  @override
  List<Object?> get props =>
      [currentPage, from, lastPage, links, path, perPage, to, total];
}

/// Represents a single link within the pagination metadata.
class Link extends Equatable {
  const Link({
    this.url,
    required this.label,
    required this.active,
  });

  /// The URL for the link, which can be null (e.g., for "..." separators).
  final String? url;

  /// The label for the link (e.g., "1", "Next &raquo;").
  final String label;

  /// Whether this link represents the active/current page.
  final bool active;

  /// Creates a copy of this [Link] but with the given fields replaced with the new values.
  Link copyWith({
    String? url,
    String? label,
    bool? active,
  }) =>
      Link(
        url: url ?? this.url,
        label: label ?? this.label,
        active: active ?? this.active,
      );

  /// Creates a [Link] object from a JSON map.
  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  /// Converts this [Link] object into a JSON map.
  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };

  @override
  List<Object?> get props => [url, label, active];
}
