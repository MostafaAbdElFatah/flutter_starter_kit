/// Provides extension methods for [Map].
extension MapExtension<K, V> on Map<K, V> {
  /// Removes all entries from the map where the key or value is `null`.
  ///
  /// **Note**: This is a getter that modifies the map in place and returns it.
  ///
  /// ```dart
  /// final map = {'a': 1, 'b': null, null: 4};
  /// final cleanedMap = map.removeNulls;
  /// // map and cleanedMap are both now {'a': 1}
  /// ```
  Map<K, V> get removeNulls =>
      this..removeWhere((key, value) => key == null || value == null);
}

/// Provides extension methods for [List].
extension ListExtension<T> on List<T> {
  /// Removes all `null` elements from the list.
  ///
  /// **Note**: This is a getter that modifies the list in place and returns it.
  ///
  /// ```dart
  /// final list = [1, null, 3, null];
  /// final cleanedList = list.removeNulls;
  /// // list and cleanedList are both now [1, 3]
  /// ```
  List<T> get removeNulls => this..removeWhere((element) => element == null);
}
