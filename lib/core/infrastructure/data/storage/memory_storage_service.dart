import 'dart:convert';
import 'dart:collection';
import 'package:injectable/injectable.dart';

import '../../../utils/log.dart';
import 'storage_service.dart';

/// A storage service implementation that keeps data in memory.
///
/// This is useful for tests or ephemeral caches where persistence across app
/// restarts is not required.

/// In-memory [StorageService] with per-entry TTL and LRU eviction.
@LazySingleton(as: MemoryCacheService)
class MemoryStorageService implements MemoryCacheService {
  MemoryStorageService({
    this.maxEntries = 256,
    this.defaultTtl = const Duration(minutes: 15),
  });

  final int maxEntries;
  final Duration defaultTtl;

  /// Insertion-ordered map — oldest entry is always [LinkedHashMap.keys.first].
  final LinkedHashMap<String, _CacheEntry> _store = LinkedHashMap();

  // ---------------------------------------------------------------------------
  // StorageService — lifecycle
  // ---------------------------------------------------------------------------

  @override
  Future<void> init() async {}

  @override
  Future<void> clear() async => _store.clear();

  // ---------------------------------------------------------------------------
  // StorageService — writes
  // ---------------------------------------------------------------------------

  @override
  Future<void> put({required dynamic key, required dynamic value}) async {
    // Always remove first: refreshes LRU order on update, frees slot on insert.
    _store.remove(key);
    _evictIfNeeded();
    _store[key] = _CacheEntry(
      value: value,
      expiry: DateTime.now().add(defaultTtl),
    );
  }

  @override
  Future<void> putJson({required dynamic key, required Object? value}) =>
      put(key: key, value: jsonEncode(value));

  @override
  Future<void> delete(dynamic key) async => _store.remove(key);

  void deleteByPrefix(String prefix) {
    if (prefix.isEmpty) return;
    _store.removeWhere((key, value) => key.startsWith(prefix));
  }

  // ---------------------------------------------------------------------------
  // StorageService — reads
  // ---------------------------------------------------------------------------

  @override
  Object? get(dynamic key, {Object? defaultValue}) =>
      _read(key) ?? defaultValue;

  @override
  T? getJson<T>({
    required dynamic key,
    required StorageCallback<T> fromJson,
    T? defaultValue,
  }) {
    final raw = _read(key);
    if (raw == null) return defaultValue;
    return _decodeJson(key: key, raw: raw, fromJson: fromJson) ?? defaultValue;
  }

  @override
  List<T> getList<T>({
    required dynamic key,
    required StorageCallback<T> fromJson,
    List<T>? defaultValue,
  }) {
    final raw = _read(key);
    if (raw == null) return defaultValue ?? const [];

    try {
      final list = jsonDecode(raw as String) as List<dynamic>;
      return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    } catch (error, stackTrace) {
      Log.fatalError(
        'Failed to decode list for key "$key"',
        error: error,
        stackTrace: stackTrace,
      );
      return defaultValue ?? const [];
    }
  }

  @override
  bool has(dynamic key) => _read(key) != null;

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Returns the value for [key], refreshing its LRU position.
  /// Returns `null` if missing or expired (expired entries are pruned).
  Object? _read(dynamic key) {
    final entry = _store[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _store.remove(key);
      return null;
    }

    // Refresh LRU order by re-inserting at the end.
    _store
      ..remove(key)
      ..[key] = entry;

    return entry.value;
  }

  /// Evicts the least-recently-used entry when the store is at capacity.
  void _evictIfNeeded() {
    while (_store.length >= maxEntries) {
      _store.remove(_store.keys.first);
    }
  }

  /// Decodes a single JSON object, returning `null` on failure.
  T? _decodeJson<T>({
    required String key,
    required Object? raw,
    required StorageCallback<T> fromJson,
  }) {
    if (raw is! String || raw.isEmpty) return null;
    try {
      return fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (error, stackTrace) {
      Log.fatalError(
        'Failed to decode JSON for key "$key"',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}

// -----------------------------------------------------------------------------
// Internal model
// -----------------------------------------------------------------------------

/// A cached value paired with its expiry timestamp.
final class _CacheEntry {
  const _CacheEntry({required this.value, required this.expiry});

  final Object? value;
  final DateTime expiry;

  bool get isExpired => expiry.isBefore(DateTime.now());
}
