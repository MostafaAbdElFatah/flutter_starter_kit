import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

abstract class StorageService {
  Future<void> init();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> setOnboardingComplete();
  Future<bool> isOnboardingComplete();
}

class StorageServiceImpl implements StorageService {
  final FlutterSecureStorage _secureStorage;
  late Box _box;
  static const String _hiveKey = 'hive_encryption_key';
  static const String _boxName = 'app_data';

  StorageServiceImpl(this._secureStorage);

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    
    // 1. Check if we have an encryption key
    String? encryptionKeyString = await _secureStorage.read(key: _hiveKey);
    
    if (encryptionKeyString == null) {
      // 2. Generate a new key if none exists
      final key = Hive.generateSecureKey();
      encryptionKeyString = base64UrlEncode(key);
      await _secureStorage.write(key: _hiveKey, value: encryptionKeyString);
    }
    
    final encryptionKeyUint8List = base64Url.decode(encryptionKeyString);

    // 3. Open the encrypted box
    _box = await Hive.openBox(
      _boxName,
      encryptionCipher: HiveAesCipher(encryptionKeyUint8List),
    );
  }

  @override
  Future<void> saveToken(String token) async {
    await _box.put(AppConstants.tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return _box.get(AppConstants.tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await _box.delete(AppConstants.tokenKey);
  }

  @override
  Future<void> setOnboardingComplete() async {
    await _box.put(AppConstants.onboardingCompleteKey, true);
  }

  @override
  Future<bool> isOnboardingComplete() async {
    return _box.get(AppConstants.onboardingCompleteKey, defaultValue: false);
  }
}
