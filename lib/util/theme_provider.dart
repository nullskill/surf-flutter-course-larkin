import 'package:flutter/foundation.dart';
import 'package:places/util/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Класс провайдера выбранной темы
class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  SharedPreferences _prefs;
  bool _darkTheme;

  bool get darkTheme => _darkTheme;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(themeKey) ?? true;
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    await _initPrefs();
    await _prefs.setBool(themeKey, _darkTheme);
  }

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
}
