import 'dart:collection';

import 'adapter.dart';
import 'adapters/json_adapter.dart';

/// PreferenceAdapterRegistry contain the [PreferenceAdapter]s associated
class PreferenceAdapterRegistry {
  final Set<PreferenceAdapter> _adapters = HashSet();

  /// Register a [PreferenceAdapter] to announce it to Cache.
  void registerAdapter<T>(PreferenceAdapter<T> adapter) {
    if (!_adapters.contains(adapter)) {
      _adapters.add(adapter);
    }
  }

  /// find the [PreferenceAdapter] for the [type].
  PreferenceAdapter findAdapterForType(Type type) {
    for (var adapter in _adapters) {
      if (type == adapter.valueType) {
        return adapter;
      }

      if (type.toString() == '_${adapter.valueType.toString()}Impl') {
        return adapter;
      }
    }

    return const JsonAdapter();
  }
}
