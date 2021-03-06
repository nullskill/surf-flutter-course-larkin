import 'package:flutter/foundation.dart';
import 'package:places/utils/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Класс провайдера выбранной темы
class ThemeNotifier extends ChangeNotifier {
  SharedPreferences _prefs;
  bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  void _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(themeKey) ?? true;
    notifyListeners();
  }

  void _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(themeKey, _darkTheme);
  }

  void _initPrefs() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }
}
