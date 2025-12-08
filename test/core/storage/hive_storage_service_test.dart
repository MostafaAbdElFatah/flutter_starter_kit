import 'dart:convert';
import 'package:flutter_starter_kit/core/utils/log.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hive_test/hive_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/storage/hive_storage_service.dart';
import 'package:flutter_starter_kit/core/infrastructure/data/storage/secure_storage_service.dart';

import 'hive_storage_service_test.mocks.dart';
// Test model for JSON serialization tests
class TestUser {
  final String name;
  final int age;

  TestUser({required this.name, required this.age});

  factory TestUser.fromJson(Map<String, dynamic> json) {
    return TestUser(
      name: json['name'] as String,
      age: json['age'] as int,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'age': age};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TestUser &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              age == other.age;

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}

@GenerateMocks([SecureStorageService])
void main() {
  late HiveStorageService hiveStorageService;
  late MockSecureStorageService mockSecureStorage;

  const boxName = 'app_data';
  const hiveKey = 'hive_encryption_key';

  setUp(() async {
    mockSecureStorage = MockSecureStorageService();

    // Initialize in-memory Hive
    await setUpTestHive();

    hiveStorageService = HiveStorageService(mockSecureStorage);
    Log.overrideShouldDebugForTests = true;
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  group('HiveStorageService.init', () {
    test('generates a new key when none exists', () async {
      // Arrange
      // Secure storage returns null → force new key generation
      when(mockSecureStorage.read(key: hiveKey)).thenAnswer((_) async => null);

      // Act
      await hiveStorageService.init();

      // Assert
      verify(mockSecureStorage.read(key: hiveKey)).called(1);
      verify(
        mockSecureStorage.write(key: hiveKey, value: anyNamed('value')),
      ).called(1);

      // Box should be opened
      final box = Hive.box(boxName);
      expect(box.isOpen, true);
    });

    test('uses existing key from secure storage', () async {
      // Arrange
      final key = Hive.generateSecureKey();
      final encodedKey = base64UrlEncode(key);

      when(
        mockSecureStorage.read(key: hiveKey),
      ).thenAnswer((_) async => encodedKey);


      // Act
      await hiveStorageService.init();

      // Assert
      verifyNever(mockSecureStorage.write(key: hiveKey, value: encodedKey));
      expect(Hive.box(boxName).isOpen, true);
    });

    test('throws when Hive.openBox fails', () async {
      // Arrange
      when(
        mockSecureStorage.read(key: hiveKey),
      ).thenThrow(Exception("Secure storage error"));

      // Assert
      expect(() async => await hiveStorageService.init(), throwsException);
    });
  });

  group('Basic operations', () {
    setUp(() async {
      final key = Hive.generateSecureKey();
      final encodedKey = base64UrlEncode(key);

      when(
        mockSecureStorage.read(key: hiveKey),
      ).thenAnswer((_) async => encodedKey);

      await hiveStorageService.init();
    });

    test('put and get', () async {
      await hiveStorageService.put(key: 'name', value: 'Mostafa');

      // Act
      final result = hiveStorageService.get('name');

      // Assert
      expect(result, 'Mostafa');
    });

    test('delete', () async {

      // Arrange
      await hiveStorageService.put(key: 'age', value: 30);

      // Act
      await hiveStorageService.delete('age');

      // Assert
      expect(hiveStorageService.get('age'), null);
    });

    test('get with default', () {

      // Act
      final result = hiveStorageService.get('unknown', defaultValue: 'default');

      // Assert
      expect(result, 'default');
    });
  });

  group('JSON operations', () {
    setUp(() async {
      final key = Hive.generateSecureKey();
      final encodedKey = base64UrlEncode(key);

      when(
        mockSecureStorage.read(key: hiveKey),
      ).thenAnswer((_) async => encodedKey);

      await hiveStorageService.init();
    });

    test('putJson and getJson', () async {

      // Arrange
      final data = {"id": 1, "name": "Mostafa"};
      await hiveStorageService.putJson(key: 'user', value: data);

      // Act
      final result = hiveStorageService.getJson<Map<String, dynamic>>(
        key: 'user',
        fromJson: (json) => json,
      );

      // Assert
      expect(result, data);
    });

    test('getJson returns default on invalid json', () async {

      // Arrange
      await Hive.box('app_data').put('invalid', 'not_json');

      // Act
      final result = hiveStorageService.getJson<Map<String, dynamic>>(
        key: 'invalid',
        fromJson: (json) => json,
        defaultValue: <String, dynamic>{},
      );

      // Assert
      expect(result, {});
    });
  });

  group('List JSON operations', () {
    setUp(() async {
      final key = Hive.generateSecureKey();
      final encodedKey = base64UrlEncode(key);

      when(
        mockSecureStorage.read(key: hiveKey),
      ).thenAnswer((_) async => encodedKey);

      await hiveStorageService.init();
    });

    test('stores and retrieves a list using getList', () async {

      // Arrange
      final list = [
        {"id": 1, "text": "hello"},
        {"id": 2, "text": "world"},
      ];

      await hiveStorageService.putJson(key: 'messages', value: list);

      // Act
      final result = hiveStorageService.getList<Map<String, dynamic>>(
        key: 'messages',
        fromJson: (json) => json,
      );

      // Assert
      expect(result.length, 2);
      expect(result[0]["id"], 1);
      expect(result[1]["text"], "world");
    });

    test('returns default list on invalid json', () async {

      // Arrange
      await Hive.box('app_data').put('invalid_list', 'not_json');

      // Act
      final result = hiveStorageService.getList<Map<String, dynamic>>(
        key: 'invalid_list',
        fromJson: (json) => json,
      );

      // Assert
      expect(result, []);
    });
  });

  group('Object operations', () {
    setUp(() async {
      final key = Hive.generateSecureKey();
      final encodedKey = base64UrlEncode(key);

      when(
        mockSecureStorage.read(key: hiveKey),
      ).thenAnswer((_) async => encodedKey);

      await hiveStorageService.init();
    });

    test('putJson and getJson', () async {

      // Arrange
      final user = TestUser(name: 'John', age: 30);
      await hiveStorageService.putJson(key: 'user', value: user);

      // Act
      final result = hiveStorageService.getJson<TestUser>(
        key: 'user',
        fromJson: TestUser.fromJson,
      );

      // Assert
      expect(result, user);
    });

    test('getJson returns default on invalid json', () async {

      // Arrange
      final user = TestUser(name: 'John', age: 30);
      await Hive.box('app_data').put('invalid', 'not_json');

      // Act
      final result = hiveStorageService.getJson(
        key: 'invalid',
        fromJson: TestUser.fromJson,
        defaultValue: user,
      );

      // Assert
      expect(result, user);
    });
  });

  group('List Object operations', () {
    setUp(() async {
      final key = Hive.generateSecureKey();
      final encodedKey = base64UrlEncode(key);

      when(
        mockSecureStorage.read(key: hiveKey),
      ).thenAnswer((_) async => encodedKey);

      await hiveStorageService.init();
    });

    test('stores and retrieves a list using getList', () async {

      // Arrange
      final list = [
        TestUser(name: 'Ahmed', age: 20),
        TestUser(name: 'Mohamed', age: 30),
        TestUser(name: 'Ali', age: 50),
      ];

      await hiveStorageService.putJson(key: 'messages', value: list);

      // Act
      final result = hiveStorageService.getList(
        key: 'messages',
        fromJson: TestUser.fromJson,
      );

      // Assert
      expect(result.length, 3);
      expect(result[0].name, 'Ahmed');
      expect(result[0].age, 20);
      expect(result[2].name, 'Ali');
      expect(result[2].age, 50);
    });

    test('returns default list on invalid json', () async {

      // Arrange
      await Hive.box('app_data').put('invalid_list', 'not_json');

      // Act
      final result = hiveStorageService.getList(
        key: 'invalid_list',
        fromJson: TestUser.fromJson,
      );

      // Assert
      expect(result, []);
      expect(result.length, 0);
    });
  });
}
