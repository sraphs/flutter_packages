import '../adapter.dart';

/// A [PreferenceAdapter] implementation for storing and retrieving a [bool].
class BoolAdapter extends PreferenceAdapter<bool> {
  static const instance = BoolAdapter._();
  const BoolAdapter._();

  @override
  bool? getValue(preferences, key) {
    return preferences.getBool(key);
  }

  @override
  Future<bool> setValue(preferences, key, value) => preferences.setBool(key, value);
}

/// A [PreferenceAdapter] implementation for storing and retrieving an [int].
class IntAdapter extends PreferenceAdapter<int> {
  static const instance = IntAdapter._();
  const IntAdapter._();

  @override
  int? getValue(preferences, key) => preferences.getInt(key);

  @override
  Future<bool> setValue(preferences, key, value) => preferences.setInt(key, value);
}

/// A [PreferenceAdapter] implementation for storing and retrieving a [double].
class DoubleAdapter extends PreferenceAdapter<double> {
  static const instance = DoubleAdapter._();
  const DoubleAdapter._();

  @override
  double? getValue(preferences, key) => preferences.getDouble(key);

  @override
  Future<bool> setValue(preferences, key, value) => preferences.setDouble(key, value);
}

/// A [PreferenceAdapter] implementation for storing and retrieving a [String].
class StringAdapter extends PreferenceAdapter<String> {
  static const instance = StringAdapter._();
  const StringAdapter._();

  @override
  String? getValue(preferences, key) => preferences.getString(key);

  @override
  Future<bool> setValue(preferences, key, value) => preferences.setString(key, value);
}

/// A [PreferenceAdapter] implementation for storing and retrieving a [List] of
/// [String] objects.
class StringListAdapter extends PreferenceAdapter<List<String>> {
  static const instance = StringListAdapter._();
  const StringListAdapter._();

  @override
  List<String>? getValue(preferences, key) => preferences.getStringList(key);

  @override
  Future<bool> setValue(preferences, key, value) => preferences.setStringList(key, value);
}
