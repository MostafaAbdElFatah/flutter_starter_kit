import 'package:flutter_starter_kit/core/infrastructure/data/storage/memory_storage_service.dart';
import 'package:flutter_starter_kit/core/utils/log.dart';
import 'package:flutter_test/flutter_test.dart';




void main() {
  late MemoryStorageService storageService;

  setUp(() async {
    storageService = MemoryStorageService();
    Log.overrideShouldDebugForTests = true;
    await storageService.init();
  });

  tearDown(() {
    storageService.clear();
  });

  group('Basic operations', () {
    test('put and get', () async {
      const key = 'name';
      const value = 'Ahmed';

      await storageService.put(key: key, value: value);

      final result = storageService.get(key);

      expect(result, value);
    });

    test('delete', () async {
      const key = 'age';
      const value = 30;

      await storageService.put(key: key, value: value);
      await storageService.delete(key);

      expect(storageService.get(key), null);
      expect(storageService.has(key), false);
    });

    test('has returns true when key exists', () async {
      const key = 'flag';
      const value = true;

      await storageService.put(key: key, value: value);

      expect(storageService.has(key), true);
    });

    test('get with default', () {
      const defaultValue = 'default';

      final result = storageService.get('unknown', defaultValue: defaultValue);

      expect(result, defaultValue);
    });
  });

  group('JSON operations', () {
    test('putJson and getJson', () async {
      final data = {'id': 1, 'name': 'Mostafa'};

      await storageService.putJson(key: 'user', value: data);

      final result = storageService.getJson<Map<String, dynamic>>(
        key: 'user',
        fromJson: (json) => json,
      );

      expect(result, data);
    });

    test('getJson returns default on invalid json', () async {
      await storageService.put(key: 'invalid', value: 'not_json');

      final result = storageService.getJson<Map<String, dynamic>>(
        key: 'invalid',
        fromJson: (json) => json,
        defaultValue: <String, dynamic>{},
      );

      expect(result, {});
    });
  });

  group('List JSON operations', () {
    test('stores and retrieves a list using getList', () async {
      final list = [
        {'id': 1, 'text': 'hello'},
        {'id': 2, 'text': 'world'},
      ];

      await storageService.putJson(key: 'messages', value: list);

      final result = storageService.getList<Map<String, dynamic>>(
        key: 'messages',
        fromJson: (json) => json,
      );

      expect(result.length, 2);
      expect(result[0]['id'], 1);
      expect(result[1]['text'], 'world');
    });

    test('returns default list on invalid json', () async {
      await storageService.put(key: 'invalid_list', value: 'not_json');

      final result = storageService.getList<Map<String, dynamic>>(
        key: 'invalid_list',
        fromJson: (json) => json,
      );

      expect(result, []);
    });
  });

  group('Object operations', () {
    test('putJson and getJson', () async {
      final user = TestUser(name: 'John', age: 30);

      await storageService.putJson(key: 'user', value: user);

      final result = storageService.getJson<TestUser>(
        key: 'user',
        fromJson: TestUser.fromJson,
      );

      expect(result, user);
    });

    test('getJson returns default on invalid json', () async {
      final user = TestUser(name: 'John', age: 30);

      await storageService.put(key: 'invalid', value: 'not_json');

      final result = storageService.getJson(
        key: 'invalid',
        fromJson: TestUser.fromJson,
        defaultValue: user,
      );

      expect(result, user);
    });
  });

  group('List Object operations', () {
    test('stores and retrieves a list using getList', () async {
      final list = [
        TestUser(name: 'Ahmed', age: 20),
        TestUser(name: 'Mohamed', age: 30),
        TestUser(name: 'Ali', age: 50),
      ];

      await storageService.putJson(key: 'messages', value: list);

      final result = storageService.getList(
        key: 'messages',
        fromJson: TestUser.fromJson,
      );

      expect(result.length, 3);
      expect(result.first.name, list.first.name);
      expect(result.first.age, list.first.age);
      expect(result.last.name, list.last.name);
      expect(result.last.age, list.last.age);
    });

    test('returns default list on invalid json', () async {
      await storageService.put(key: 'invalid_list', value: 'not_json');

      final result = storageService.getList(
        key: 'invalid_list',
        fromJson: TestUser.fromJson,
      );

      expect(result, []);
      expect(result.length, 0);
    });
  });

  group('Utilities', () {
    test('clear removes all stored values', () async {
      await storageService.put(key: 'a', value: 1);
      await storageService.put(key: 'b', value: 2);

      storageService.clear();

      expect(storageService.has('a'), false);
      expect(storageService.has('b'), false);
    });
  });
}

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
