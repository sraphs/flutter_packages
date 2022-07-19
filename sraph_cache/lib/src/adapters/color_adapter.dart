import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import '../adapter.dart';

/// A [PreferenceAdapter] implementation for storing and retrieving a
/// [Color].
///
/// Stores values as timezone independent milliseconds from the standard Unix
/// epoch.
class ColorAdapter extends PreferenceAdapter<Color> {
  static const instance = ColorAdapter._();
  const ColorAdapter._();

  @override
  Color? getValue(SharedPreferences preferences, String key) {
    final value = preferences.getInt(key);
    if (value == null) return null;

    return Color(value);
  }

  @override
  Future<bool> setValue(
    SharedPreferences preferences,
    String key,
    Color value,
  ) {
    return preferences.setInt(key, value.value);
  }
}
