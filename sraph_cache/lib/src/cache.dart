import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adapter.dart';
import 'adapter_registry.dart';
import 'adapters/adapters.dart';

class Cache {
  /// Private constructor to prevent multiple instances. Creating multiple
  /// instances of the class breaks change detection.
  Cache._(this._preferences);

  static Cache get instance {
    assert(_instance != null, 'Cache instance not initialized yet, call ensureInitialized() first.');
    return _instance!;
  }

  static Cache? _instance;

  final SharedPreferences _preferences;

  final StreamController<CacheEvent> _streamController = StreamController<CacheEvent>.broadcast();

  final PreferenceAdapterRegistry _adapterRegistry = PreferenceAdapterRegistry();

  /// ensureInitialized must be called before using the cache.
  static Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (Cache._instance != null) {
      return;
    }

    final preferences = await debugObtainSharedPreferencesInstance;

    _instance = Cache._(preferences);
    _registerInternalAdapters();
  }

  static void _registerInternalAdapters() {
    registerAdapter(BoolAdapter.instance);
    registerAdapter(IntAdapter.instance);
    registerAdapter(DoubleAdapter.instance);
    registerAdapter(StringAdapter.instance);
    registerAdapter(StringListAdapter.instance);
    registerAdapter(BigIntAdapter.instance);
    registerAdapter(ColorAdapter.instance);
    registerAdapter(DateTimeAdapter.instance);
    registerAdapter(const JsonAdapter());
    registerAdapter(LocaleAdapter.instance);
    registerAdapter(ThemeModeAdapter.instance);
    registerAdapter(TimeOfDayAdapter.instance);
  }

  static void registerAdapter<T>(PreferenceAdapter<T> adapter) {
    instance._adapterRegistry.registerAdapter(adapter);
  }

  /// Returns a stream that emits whenever a key is changed.
  static Stream<CacheEvent> watch([dynamic key]) {
    return instance._streamController.stream.where((change) {
      switch (key.runtimeType) {
        case String:
          return change.key == key;
        case List<String>:
          return key.contains(change.key);
      }

      return true;
    });
  }

  /// Returns a [ValueListenable] which notifies its listeners when a key
  /// in the cache changes.
  ///
  /// If [keys] filter is provided, only changes to entries with the
  /// specified keys notify the listeners.
  static ValueListenable<Cache> listenable({
    List<dynamic>? keys,
  }) =>
      _CacheListenable(
        instance,
        keys: keys?.toSet(),
      );

  /// Returns true if persistent storage the contains the given [key].
  static bool containsKey(String key) => instance._preferences.containsKey(key);

  /// Returns all keys in the persistent storage.
  static Set getKeys() => instance._preferences.getKeys();

  /// Reads a value from persistent storage, returning null if the value is not
  /// present.
  static T? get<T>(String key, {T? defaultValue}) {
    final adapter = instance._adapterRegistry.findAdapterForType(T);
    return adapter.getValue(instance._preferences, key) ?? defaultValue;
  }

  /// Saves a T [value] to persistent storage in the background.
  static Future<bool> set<T>(String key, T? value) async {
    if (value == null) {
      remove(key);
      return true;
    }

    final adapter = instance._adapterRegistry.findAdapterForType(T);
    final isSuccessful = await adapter.setValue(instance._preferences, key, value);
    if (isSuccessful) {
      instance._streamController.add(CacheEvent(key, value, false));
    }
    return isSuccessful;
  }

  /// Removes an entry from persistent storage.
  static Future<void> remove(String key) async {
    instance._preferences.remove(key);
    instance._streamController.add(CacheEvent(key, null, true));
  }

  /// Completes with true once the user preferences for the app has been cleared.
  static Future<bool> clear() async {
    final keys = instance._preferences.getKeys();
    final isSuccessful = await instance._preferences.clear();
    for (var key in keys) {
      instance._streamController.add(CacheEvent(key, null, true));
    }
    return isSuccessful;
  }
}

/// A event representing a change in the cache.
class CacheEvent {
  /// The key of the changed entry
  final dynamic key;

  /// The value of a new entry of `null` if the entry has been deleted
  final dynamic value;

  /// Whether the entry has been deleted
  final bool deleted;

  /// Create a new CacheEvent (Hive internal)
  CacheEvent(this.key, this.value, this.deleted);

  @override
  bool operator ==(dynamic other) {
    if (other is CacheEvent) {
      return other.key == key && other.value == value;
    }
    return false;
  }

  @override
  int get hashCode => runtimeType.hashCode ^ key.hashCode ^ value.hashCode;
}

class _CacheListenable extends ValueListenable<Cache> {
  _CacheListenable(
    this.cache, {
    this.keys,
  });

  final Cache cache;

  final Set<dynamic>? keys;

  final List<VoidCallback> _listeners = [];

  StreamSubscription? _subscription;

  @override
  void addListener(VoidCallback listener) {
    if (_listeners.isEmpty) {
      _subscription = Cache.watch().listen((event) {
        if (keys != null && !keys!.contains(event.key)) {
          return;
        }

        for (var listener in _listeners) {
          listener();
        }
      });
    }

    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _subscription?.cancel();
      _subscription = null;
    }
  }

  @override
  Cache get value => cache;
}

// Used for obtaining an instance of [SharedPreferences] by [Cache].
//
// Should not be used outside of tests.
@visibleForTesting
Future<SharedPreferences> debugObtainSharedPreferencesInstance = SharedPreferences.getInstance();

/// Resets the singleton instance of [Cache] so that it can
/// be always tested from a clean slate. Only for testing purposes.
///
/// Should not be used outside of tests.
@visibleForTesting
void debugResetCacheInstance() {
  Cache._instance = null;
}
