import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../adapter.dart';

/// A [PreferenceAdapter] implementation for storing and retrieving a
/// [ThemeMode].
///
/// Stores values as timezone independent milliseconds from the standard Unix
/// epoch.
class ThemeModeAdapter extends PreferenceAdapter<ThemeMode> {
  static const instance = ThemeModeAdapter._();
  const ThemeModeAdapter._();

  @override
  ThemeMode? getValue(SharedPreferences preferences, String key) {
    final value = preferences.getInt(key);
    if (value == null) return null;

    return ThemeMode.values[value];
  }

  @override
  Future<bool> setValue(
    SharedPreferences preferences,
    String key,
    ThemeMode value,
  ) {
    return preferences.setInt(key, value.index);
  }
}
