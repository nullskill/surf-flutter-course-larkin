import 'package:shared_preferences/shared_preferences.dart';

/// Класс для инициализации приложения
class AppInitialization {
  final String key = "first_run";
  SharedPreferences _prefs;
  bool _firstRun;

  bool get firstRun => _firstRun;

  void get tutorialFinished {
    _firstRun = false;
    _saveToPrefs();
  }

  static final AppInitialization _singleton = AppInitialization._internal();

  factory AppInitialization() {
    return _singleton;
  }

  AppInitialization._internal() {
    _firstRun = true;
    _loadFromPrefs();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _firstRun = _prefs.getBool(key) ?? true;
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _firstRun);
  }

  _initPrefs() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }
}
