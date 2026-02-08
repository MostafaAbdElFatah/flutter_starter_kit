/// Helpers for working with [Map] collections.
extension MapX<K, V> on Map<K, V> {
  /// Removes entries with a `null` key or value and returns the same map.
  ///
  /// This mutates the original map in place.
  Map<K, V> get removeNulls => this
    ..removeWhere((K key, V value) => key == null || value == null);

  /// Builds a new map by pairing this map's *values* with [list] items.
  ///
  /// This expects the current map to be keyed by contiguous `int` indices
  /// starting at 0, where each value becomes a key in the returned map.
  ///
  /// Example:
  /// `{0: 'a', 1: 'b'}.merge([10, 20])` produces `{ 'a': 10, 'b': 20 }`.
  ///
  /// If [list] is shorter than this map, missing values are set to `null`.
  Map<K2, V2?> merge<K2, V2>(List<V2> list) {
    final Map<K2, V2?> results = {
      for (int i = 0; i < length; i++)
        this[i] as K2: list.length <= i ? null : list[i],
    };
    return results;
  }
}

/// Helpers for working with [List] collections.
extension ListX<T> on List<T> {
  /// Removes `null` elements and returns the same list.
  ///
  /// This mutates the original list in place.
  List<T> get removeNulls => this..removeWhere((element) => element == null);
}
