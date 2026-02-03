import 'dart:convert';
import 'dart:io';
import 'package:hive_ce/hive_ce.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../utils/log.dart';
import 'secure_storage_service.dart';
import 'storage_service.dart';

/// A storage service implementation that uses Hive as the backend.
///
/// This service encrypts the Hive box to protect sensitive data. It depends on a
/// [SecureStorageService] to persist the encryption key securely.
@Injectable(as: StorageService)
class HiveStorageService implements StorageService {
  late Box _box;
  final SecureStorageService _secureStorage;
  static const String _boxName = 'app_data';
  static const String _hiveKey = 'hive_encryption_key';

  /// Creates a new [HiveStorageService] instance.
  ///
  /// Requires a [SecureStorageService] instance to securely store the encryption key.
  /// By depending on the abstraction, this service is decoupled from the concrete
  /// implementation of secure storage, making it more testable and maintainable.
  HiveStorageService(this._secureStorage);

  @override
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    try {
      final path = Directory.current.path;
      Hive.init(path);
      // Retrieve the encryption key from secure storage.
      String? encryptionKeyString = await _secureStorage.read(key: _hiveKey);

      if (encryptionKeyString == null) {
        // If no key exists, generate a new one and save it securely.
        final key = Hive.generateSecureKey();
        encryptionKeyString = base64UrlEncode(key);
        await _secureStorage.write(key: _hiveKey, value: encryptionKeyString);
      }

      final encryptionKeyUint8List = base64Url.decode(encryptionKeyString);

      // Open the Hive box with the encryption key.
      _box = await Hive.openBox(
        _boxName,
        encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
      );
    } catch (e, s) {
      Log.fatalError(
        'Failed to initialize HiveStorageService',
        error: e,
        stackTrace: s,
      );
      // Depending on the app's requirements, we might want to rethrow the exception
      // or handle it in a way that doesn't crash the app.
      rethrow;
    }
  }

  @override
  Future<void> delete(dynamic key) => _box.delete(key);

  @override
  bool has(dynamic key) => _box.containsKey(key);

  @override
  Future<void> put({required dynamic key, required dynamic value}) =>
      _box.put(key, value);

  @override
  Future<void> putJson({required dynamic key, required dynamic value}) =>
      _box.put(key, jsonEncode(value));

  @override
  dynamic get(dynamic key, {dynamic defaultValue}) =>
      _box.get(key, defaultValue: defaultValue);

  @override
  T? getJson<T>({
    required dynamic key,
    required StorageCallback<T> fromJson,
    dynamic defaultValue,
  }) {
    final String? jsonString = _box.get(key);
    if (jsonString == null || jsonString.isEmpty) return defaultValue;
    try {
      return fromJson(jsonDecode(jsonString));
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  List<T> getList<T>({
    required dynamic key,
    required StorageCallback<T> fromJson,
    dynamic defaultValue,
  }) {
    final String? jsonString = _box.get(key);
    if (jsonString == null || jsonString.isEmpty) return defaultValue ?? [];

    try {
      // Decode the JSON string into a List<dynamic>.
      final List<dynamic> decodedJson = jsonDecode(jsonString) as List<dynamic>;
      // Convert each item using the provided fromJson callback.
      final List<T> decodedList = decodedJson
          .map<T>((item) => fromJson(item as Map<String, dynamic>))
          .toList();
      return decodedList;
    } catch (e) {
      return defaultValue ?? [];
    }
  }
}
