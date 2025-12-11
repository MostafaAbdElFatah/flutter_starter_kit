
/// A typedef for a callback function that converts JSON data into a specified type [T].
///
/// Example:
/// ```dart
/// final user = getJson<User>(
///   key: 'user',
///   fromJson: (json) => User.fromJson(json),
/// );
/// ```
typedef StorageCallback<T> = T Function(Map<String, dynamic> json);

/// A typedef for a callback function that converts iterable elements into a specified type [T].
typedef StorageIterableCallback<T> = T Function(
    Iterable elements, {
    bool growable,
    });

/// Abstract class for general local storage functionality.
///
/// This class defines the contract for a storage service that can be implemented
/// by different storage backends, such as Hive, SharedPreferences, or SecureStorage.
/// It provides a common interface for storing and retrieving data in various formats.
abstract class StorageService {
  /// Initializes the storage system.
  ///
  /// This method should be called before any other storage operations are performed.
  /// It can be used to set up Hive boxes, initialize SharedPreferences, or
  /// configure SecureStorage.
  Future<void> init();

  /// Deletes a value associated with the given [key] from storage.
  ///
  /// [key] can be any object supported by the storage backend.
  Future<void> delete(dynamic key);

  /// Retrieves a boolean value associated with the given [key] from storage.
  ///
  /// If the key is not found, it returns false else return true.
  bool has(dynamic key);

  /// Stores a [value] associated with the given [key] in storage.
  ///
  /// Use this for plain data types such as [int], [String], [bool], [List], or [Map].
  Future<void> put({
    required dynamic key,
    required dynamic value,
  });

  /// Stores a JSON-encoded [value] associated with the given [key] in storage.
  ///
  /// This is useful for saving custom objects (e.g., domain models) after they
  /// have been converted to a JSON map.
  Future<void> putJson({
    required dynamic key,
    required dynamic value,
  });

  /// Retrieves a value associated with the given [key] from storage.
  ///
  /// If the key is not found, it returns the [defaultValue].
  dynamic get(dynamic key, {dynamic defaultValue});

  /// Retrieves a JSON-encoded value associated with the given [key] and decodes it to type [T].
  ///
  /// The [fromJson] callback is used to convert the decoded JSON map into an object of type [T].
  /// If the key is not found or if the JSON decoding fails, it returns the [defaultValue].
  T? getJson<T>({
    required dynamic key,
    required StorageCallback<T> fromJson,
    dynamic defaultValue,
  });

  /// Retrieves a list of JSON objects associated with [key] and converts each to type [T].
  ///
  /// The [fromJson] callback is used to convert each element in the list.
  /// If the key is not found, it returns an empty list or the provided [defaultValue].
  List<T> getList<T>({
    required dynamic key,
    required StorageCallback<T> fromJson,
    dynamic defaultValue,
  });
}
