import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../adapter.dart';

/// A [PreferenceAdapter] implementation for storing and retrieving a
/// [TimeOfDay].
///
/// Stores values as timezone independent milliseconds from the standard Unix
/// epoch.
class TimeOfDayAdapter extends PreferenceAdapter<TimeOfDay> {
  static const instance = TimeOfDayAdapter._();
  const TimeOfDayAdapter._();

  @override
  TimeOfDay? getValue(SharedPreferences preferences, String key) {
    final totalMinutes = preferences.getInt(key);
    if (totalMinutes == null) return null;
    return TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
  }

  @override
  Future<bool> setValue(
    SharedPreferences preferences,
    String key,
    TimeOfDay value,
  ) {
    return preferences.setInt(key, value.hour * 60 + value.minute);
  }
}
