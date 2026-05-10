/// Extension on [Map<String, dynamic>] to simplify safe JSON field parsing
/// with type coercion and fallback default values.
extension JsonParsing on Map<String, dynamic> {
  /// Returns true if [key] exists and its value is not null.
  bool hasValue(String key) => containsKey(key) && this[key] != null;

  /// Returns the value at [key] as a [double].
  /// Falls back to [defaultValue] if the key is missing, null, or unparseable.
  double getDouble(String key, {double defaultValue = 0.0}) =>
      getDoubleOrNull(key) ?? defaultValue;

  /// Returns the value at [key] as a nullable [double].
  /// Returns null if the key is missing, null, or unparseable.
  double? getDoubleOrNull(String key) =>
      hasValue(key) ? double.tryParse(this[key].toString()) : null;

  /// Returns the value at [key] as an [int].
  /// Falls back to [defaultValue] if the key is missing, null, or unparseable.
  int getInt(String key, {int defaultValue = 0}) =>
      getIntOrNull(key) ?? defaultValue;

  /// Returns the value at [key] as a nullable [int].
  /// Returns null if the key is missing, null, or unparseable.
  int? getIntOrNull(String key) =>
      hasValue(key) ? int.tryParse(this[key].toString()) : null;

  /// Returns the value at [key] as a [String].
  /// Falls back to [defaultValue] if the key is missing or null.
  String getString(String key, {String defaultValue = 'N/A'}) =>
      getStringOrNull(key) ?? defaultValue;

  /// Returns the value at [key] as a nullable [String].
  /// Returns null if the key is missing or null.
  String? getStringOrNull(String key) {
    if (!hasValue(key)) return null;
    final value = this[key].toString().trim();
    return value.isEmpty ? null : value;
  }

  /// Returns the value at [key] as a [DateTime].
  /// Falls back to [defaultValue] if the key is missing, null, or unparseable.
  DateTime getDateTime(String key, {DateTime? defaultValue}) =>
      getDateTimeOrNull(key) ?? defaultValue ?? DateTime(2000);

  /// Returns the value at [key] as a nullable [DateTime].
  /// Returns null if the key is missing, null, or unparseable.
  DateTime? getDateTimeOrNull(String key) {
    if (!hasValue(key)) return null;
    // final value = this[key].toString().trim();
    // return value.isEmpty ? null : DateTime.tryParse(value);

    final raw = this[key];

    // Handle int (millisecondsSinceEpoch)
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);

    // Handle string
    final value = raw.toString().trim();
    if (value.isEmpty) return null;

    // Try parse as int (string timestamp)
    // Handle string (try int first, then ISO parse)
    final millis = int.tryParse(value);
    if (millis != null) {
      return DateTime.fromMillisecondsSinceEpoch(millis);
    }

    // Fallback to ISO string parsing
    return DateTime.tryParse(value);
  }

  /// Returns the value at [key] as a [bool].
  /// Handles native [bool] values directly, and parses `"true"`/`"false"` strings.
  /// Falls back to [defaultValue] if the key is missing, null, or unparseable.
  bool getBool(String key, {bool defaultValue = false}) =>
      getBoolOrNull(key) ?? defaultValue;

  /// Returns the value at [key] as a nullable [bool].
  /// Returns null if the key is missing or null.
  bool? getBoolOrNull(String key) {
    if (!hasValue(key)) return null;
    final value = this[key];
    if (value is bool) return value;
    return value.toString().toLowerCase() == 'true';
  }

  /// Returns the nested map at [key].
  /// Returns null if the key is missing, null, or not a JSON map.
  Map<String, dynamic>? getMap(String key) {
    if (!hasValue(key)) return null;
    final value = this[key];
    if (value is! Map<String, dynamic>) return null;
    return value;
  }

  /// Returns the nested list at [key].
  /// Returns an empty list if the key is missing, null, or not a JSON list.
  List<T> getList<T>(String key) {
    if (!hasValue(key)) return <T>[];
    final value = this[key];
    if (value is! List) return <T>[];
    return value.whereType<T>().map((e) => e).toList(growable: false);
  }

  /// Returns the nested object at [key] parsed via a provided [fromValue] factory.
  /// Throws an [Exception] if the key is missing, null.
  T getEnum<T, V>(String key, T Function(V) fromValue) =>
      getEnumOrNull<T, V>(key, fromValue) ??
          (throw Exception('Key "$key" not found or not a valid JSON object.'));

  /// Returns the nested En at [key] parsed via a provided [fromValue] factory.
  /// Returns null if the key is missing, null.
  T? getEnumOrNull<T, V>(String key, T Function(V) fromValue) {
    if (!hasValue(key)) return null;
    return fromValue(this[key]);
  }

  /// Returns the nested object at [key] parsed via a provided [fromJson] factory.
  /// Throws an [Exception] if the key is missing, null, or not a JSON object.
  T getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) =>
      getObjectOrNull(key, fromJson) ??
          (throw Exception('Key "$key" not found or not a valid JSON object.'));

  /// Returns the nested object at [key] parsed via a provided [fromJson] factory.
  /// Returns null if the key is missing, null, or not a JSON object.
  T? getObjectOrNull<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    if (!hasValue(key)) return null;
    final value = this[key];
    if (value is! Map<String, dynamic>) return null;
    return fromJson(value);
  }

  /// Returns the nested list at [key] parsed via a provided [fromJson] factory.
  /// Returns an empty list if the key is missing, null, or not a JSON list.
  List<T> getTypedList<T>(
      String key,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    if (!hasValue(key)) return <T>[];
    final value = this[key];
    if (value is! List) return <T>[];
    return value
        .whereType<Map<String, dynamic>>()
        .map((e) => fromJson(e))
        .toList(growable: false);
  }
}
