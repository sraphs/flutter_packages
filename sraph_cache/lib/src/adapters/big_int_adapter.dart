import 'package:shared_preferences/shared_preferences.dart';

import '../adapter.dart';

/// A [PreferenceAdapter] implementation for storing and retrieving a
/// [BigInt].
///
/// Stores values as timezone independent milliseconds from the standard Unix
/// epoch.
class BigIntAdapter extends PreferenceAdapter<BigInt> {
  static const instance = BigIntAdapter._();
  const BigIntAdapter._();

  @override
  BigInt? getValue(SharedPreferences preferences, String key) {
    final value = preferences.getString(key);
    if (value == null) return null;
    return BigInt.parse(value);
  }

  @override
  Future<bool> setValue(
    SharedPreferences preferences,
    String key,
    BigInt value,
  ) {
    return preferences.setString(key, value.toString());
  }
}
