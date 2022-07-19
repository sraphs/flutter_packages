import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sraph_cache/sraph_cache.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {
  @override
  Set<String> getKeys() {
    return super.noSuchMethod(
      Invocation.method(#getKeys, []),
      returnValue: <String>{},
      returnValueForMissingStub: <String>{},
    );
  }

  @override
  String? getString(String? key) => super.noSuchMethod(Invocation.method(#getString, [key]));

  @override
  Future<bool> setBool(String? key, bool? value) {
    return super.noSuchMethod(
      Invocation.method(#setBool, [key, value]),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }

  @override
  Future<bool> setInt(String? key, int? value) {
    return super.noSuchMethod(
      Invocation.method(#setInt, [key, value]),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }

  @override
  Future<bool> setDouble(String? key, double? value) {
    return super.noSuchMethod(
      Invocation.method(#setDouble, [key, value]),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }

  @override
  Future<bool> setString(String? key, String? value) {
    return super.noSuchMethod(
      Invocation.method(#setString, [key, value]),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }

  @override
  Future<bool> setStringList(String? key, List<String>? value) {
    return super.noSuchMethod(
      Invocation.method(#setStringList, [key, value]),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }

  @override
  Future<bool> remove(String? key) {
    return super.noSuchMethod(
      Invocation.method(#remove, [key]),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }

  @override
  Future<bool> clear() {
    return super.noSuchMethod(
      Invocation.method(#clear, []),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StreamingKeyValueStore', () {
    late MockSharedPreferences delegate;

    setUpAll(() async {
      // SharedPreferences calls "getAll" through a method channel initially when
      // creating an instance of it.
      //
      // This will crash in tests by default, so this is a minimal glue code to
      // make sure that we can run the test below without crashes.
      const channel = MethodChannel('plugins.flutter.io/shared_preferences');
      channel.setMockMethodCallHandler((call) async {
        return call.method == 'getAll' ? {} : null;
      });

      // [debugObtainSharedPreferencesInstance] should be non-null and return
      // a [Future] that completes with an instance of SharedPreferences.
      //
      // Otherwise tests might run just fine, but we can't be sure that the
      // instance obtainer is not broken in production.
      final instance = await debugObtainSharedPreferencesInstance;
      expect(debugObtainSharedPreferencesInstance, isNotNull);
      expect(instance, const TypeMatcher<SharedPreferences>());
    });

    setUp(() async {
      delegate = MockSharedPreferences();

      // Swap the instance obtainer with one that always returns a mocked version
      // of shared Cache.
      debugObtainSharedPreferencesInstance = Future.value(delegate);
      await Cache.ensureInitialized();
    });

    tearDown(() {
      debugResetCacheInstance();
    });

    test('obtaining instance calls delegate only once', () async {
      var obtainCount = 0;

      // Need to reset the instance as the singleton was already obtained in
      // the [setUp] method in tests.
      debugResetCacheInstance();

      // Swap the instance obtainer to a spying one that increases the counter
      // whenever it's called.
      debugObtainSharedPreferencesInstance = Future(() {
        obtainCount++;
        return MockSharedPreferences();
      });

      await Cache.ensureInitialized();
      await Cache.ensureInitialized();
      await Cache.ensureInitialized();

      expect(obtainCount, 1);
    });

    test('forwards all method invocations and parameters to the delegate', () async {
      Cache.getKeys();
      Cache.get<bool>('boolKey', defaultValue: false);
      Cache.get<int>('intKey', defaultValue: 0);
      Cache.get<double>('doubleKey', defaultValue: 0);
      Cache.get<String>('stringKey', defaultValue: '');
      Cache.get<List<String>>('stringListKey', defaultValue: []);

      Cache.set<bool>('boolKey', true);
      Cache.set<int>('intKey', 1337);
      Cache.set<double>('doubleKey', 13.37);
      Cache.set<String>('stringKey', 'stringValue');
      Cache.set<List<String>>('stringListKey', ['stringListValue']);

      Cache.remove('removeKey');

      Cache.clear();

      verifyInOrder([
        // Getters
        delegate.getKeys(),
        delegate.getBool('boolKey'),
        delegate.getInt('intKey'),
        delegate.getDouble('doubleKey'),
        delegate.getString('stringKey'),
        delegate.getStringList('stringListKey'),

        // Setters
        delegate.setBool('boolKey', true),
        delegate.setInt('intKey', 1337),
        delegate.setDouble('doubleKey', 13.37),
        delegate.setString('stringKey', 'stringValue'),
        delegate.setStringList('stringListKey', ['stringListValue']),

        // Other
        delegate.remove('removeKey'),

        // Calling clear() should first get the keys and then call clear() on
        // the delegate. calling getKeys() after clear() returns an empty set
        // of keys, so it would not notify about the deleted keys properly.
        delegate.getKeys(),
        delegate.clear(),
      ]);

      verifyNoMoreInteractions(delegate);
    });

    group('getKeys() tests', () {
      test('when keys are empty, return an empty set', () async {
        when(delegate.getKeys()).thenReturn({});
        await expectLater(Cache.getKeys(), <dynamic>{});

        when(delegate.getKeys()).thenReturn({});
        expect(Cache.getKeys(), <dynamic>{});
      });

      test('initial values', () {
        when(delegate.getKeys()).thenReturn({'first', 'second'});
        expect(Cache.getKeys(), {'first', 'second'});
      });

      test('getKeys() - initial values', () {
        when(delegate.getKeys()).thenReturn({'first', 'second'});
        expect(Cache.getKeys(), {'first', 'second'});
      });
    });

    group('boolean tests', () {
      setUp(() {
        when(delegate.getBool('myTrueBool')).thenReturn(true);
        when(delegate.getBool('myFalseBool')).thenReturn(false);
        when(delegate.getBool('myNullBool')).thenReturn(null);
      });

      test('get<bool>() - initial values', () {
        expect(Cache.get<bool>('myTrueBool', defaultValue: false), true);
        expect(Cache.get<bool>('myFalseBool', defaultValue: true), false);
        expect(Cache.get<bool>('myNullBool', defaultValue: true), true);
        expect(Cache.get<bool>('myNullBool', defaultValue: false), false);
      });

      test('get<bool>()', () async {
        final storedBool = Cache.get<bool>('key1', defaultValue: false);
        expect(storedBool, isFalse);

        when(delegate.getBool('key1')).thenReturn(false);
        expect(Cache.get<bool>('key1', defaultValue: true), isFalse);

        when(delegate.getBool('key1')).thenReturn(null);
        expect(Cache.get<bool>('key1', defaultValue: true), isTrue);

        expect(Cache.get<bool>('key1', defaultValue: false), isFalse);
      });
    });

    group('int tests', () {
      setUp(() {
        when(delegate.getInt('myInt')).thenReturn(1337);
        when(delegate.getInt('myNullInt')).thenReturn(null);
      });

      test('get<int>() - initial values', () {
        expect(Cache.get<int>('myInt', defaultValue: 0), 1337);
        expect(Cache.get<int>('myNullInt', defaultValue: 0), 0);
        expect(Cache.get<int>('myNullInt', defaultValue: 1337), 1337);
      });

      test('set<int> event', () async {
        scheduleMicrotask(() {
          Cache.set<int>('key1', 0);
          Cache.set<int>('key1', 1);
        });

        await expectLater(Cache.watch('key1').map((event) => event.value), emitsInOrder([0, 1]));
      });
    });

    group('double tests', () {
      setUp(() {
        when(delegate.getDouble('myDouble')).thenReturn(13.37);
        when(delegate.getDouble('myNullDouble')).thenReturn(null);
      });

      test('get<double>() - initial values', () {
        expect(Cache.get<double>('myDouble', defaultValue: 0), 13.37);

        expect(Cache.get<double>('myNullDouble', defaultValue: 13.37), 13.37);
      });

      test('get<double>()', () async {
        final storedDouble = Cache.get<double>('key1', defaultValue: 0);
        expect(storedDouble, 0);

        when(delegate.getDouble('key1')).thenReturn(1.1);
        expect(Cache.get<double>('key1', defaultValue: 0), 1.1);

        when(delegate.getDouble('key1')).thenReturn(2.2);
        expect(Cache.get<double>('key1', defaultValue: 0), 2.2);

        when(delegate.getDouble('key1')).thenReturn(null);
        expect(Cache.get<double>('key1', defaultValue: 1.1), 1.1);
      });

      test('set<double> event', () async {
        scheduleMicrotask(() {
          Cache.set<double>('key1', 1.1);
          Cache.set<double>('key1', 2.2);
        });

        await expectLater(Cache.watch('key1').map((event) => event.value), emitsInOrder([1.1, 2.2]));
      });
    });

    group('String tests', () {
      setUp(() {
        when(delegate.getString('myString')).thenReturn('myValue');
        when(delegate.getString('myNullString')).thenReturn(null);
      });

      test('get<String>() - initial values', () {
        expect(Cache.get<String>('myString', defaultValue: ''), 'myValue');
        expect(Cache.get<String>('null-defValue', defaultValue: 'defaultValue'), 'defaultValue');
      });

      test('get<String>()', () async {
        expect(Cache.get<String>('key1', defaultValue: ''), isEmpty);

        when(delegate.getString('key1')).thenReturn('value 1');
        expect(Cache.get<String>('key1', defaultValue: ''), 'value 1');

        when(delegate.getString('key1')).thenReturn('value 2');
        expect(Cache.get<String>('key1', defaultValue: ''), 'value 2');

        when(delegate.getString('key1')).thenReturn(null);
        expect(Cache.get<String>('key1', defaultValue: 'defaultValue'), 'defaultValue');
      });

      test('set<String> event', () async {
        scheduleMicrotask(() {
          Cache.set<String>('key1', '');
          Cache.set<String>('key1', 'updated string');
        });

        await expectLater(Cache.watch('key1').map((event) => event.value), emitsInOrder(['', 'updated string']));
      });
    });

    group('String list tests', () {
      setUp(() {
        when(delegate.getStringList('myStringList')).thenReturn(['a', 'b']);
        when(delegate.getStringList('myNullStringList')).thenReturn(null);
        when(delegate.getStringList('myEmptyStringList')).thenReturn([]);
      });

      test('get<List<String>>() - initial values', () {
        expect(Cache.get<List<String>>('myStringList', defaultValue: []), ['a', 'b']);
        expect(Cache.get<List<String>>('myEmptyStringList', defaultValue: ['nonempty']), []);
        expect(Cache.get<List<String>>('myNullStringList', defaultValue: ['default', 'value']), ['default', 'value']);
      });

      test('get<List<String>>()', () async {
        final storedStringList = Cache.get<List<String>>('key1', defaultValue: []);
        expect(storedStringList, isEmpty);

        when(delegate.getStringList('key1')).thenReturn(['a', 'a']);
        expect(Cache.get<List<String>>('key1', defaultValue: []), ['a', 'a']);

        when(delegate.getStringList('key1')).thenReturn(['b', 'b']);
        expect(Cache.get<List<String>>('key1', defaultValue: []), ['b', 'b']);

        when(delegate.getStringList('key1')).thenReturn(null);
        expect(Cache.get<List<String>>('key1', defaultValue: ['default', 'value']), ['default', 'value']);
      });

      test('set<List<String>> event', () async {
        scheduleMicrotask(() {
          Cache.set<List<String>>('key1', []);
          Cache.set<List<String>>('key1', ['updated', 'value']);
        });

        await expectLater(
          Cache.watch('key1').map((event) => event.value),
          emitsInOrder([
            [],
            ['updated', 'value']
          ]),
        );
      });
    });

    test('removing a key event', () {
      scheduleMicrotask(() {
        Cache.remove('key1');
        Cache.remove('key2');
      });

      expect(
        Cache.watch(),
        emitsInOrder([
          CacheEvent('key1', null, true),
          CacheEvent('key2', null, true),
        ]),
      );
    });

    test('clear() event', () {
      when(delegate.getKeys()).thenReturn({'key1', 'key2', 'key3'});

      scheduleMicrotask(() {
        Cache.clear();
      });

      expect(
        Cache.watch(),
        emitsInOrder([
          CacheEvent('key1', null, true),
          CacheEvent('key2', null, true),
          CacheEvent('key3', null, true),
        ]),
      );
    });
  });
}
