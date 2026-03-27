import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists app UI language (`en` | `hi`). Default: English.
class LocaleController extends ChangeNotifier {
  static const String _prefsKey = 'app_locale';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  /// Loads saved locale from [SharedPreferences]. Falls back to English.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey) ?? 'en';
    if (code == 'hi') {
      _locale = const Locale('hi');
    } else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }

  /// Sets UI locale and persists it.
  Future<void> setLocale(Locale locale) async {
    final code = locale.languageCode;
    if (code != 'en' && code != 'hi') return;
    final next = Locale(code);
    if (_locale == next) return;
    _locale = next;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, code);
  }
}
