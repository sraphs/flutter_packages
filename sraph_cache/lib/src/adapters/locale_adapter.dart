import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import '../adapter.dart';

/// A [PreferenceAdapter] implementation for storing and retrieving a
/// [Locale].
///
/// Stores values as timezone independent milliseconds from the standard Unix
/// epoch.
class LocaleAdapter extends PreferenceAdapter<Locale> {
  static const instance = LocaleAdapter._();
  const LocaleAdapter._();

  @override
  Locale? getValue(SharedPreferences preferences, String key) {
    final value = preferences.getString(key);
    if (value == null) return null;

    final localeList = value.split('-');
    switch (localeList.length) {
      case 2:
        return Locale(localeList.first, localeList.last);
      case 3:
        return Locale.fromSubtags(
          languageCode: localeList.first,
          scriptCode: localeList[1],
          countryCode: localeList.last,
        );
      default:
        return Locale(localeList.first);
    }
  }

  @override
  Future<bool> setValue(
    SharedPreferences preferences,
    String key,
    Locale value,
  ) {
    return preferences.setString(key, value.toString());
  }
}
