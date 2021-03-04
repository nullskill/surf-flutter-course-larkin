import 'package:shared_preferences/shared_preferences.dart';

/// Класс для инициализации приложения
class AppInitialization {
  final String key = "first_run";
  SharedPreferences _prefs;
  bool _isFirstRun;

  bool get isFirstRun => _isFirstRun;

  static final AppInitialization _singleton = AppInitialization._internal();

  factory AppInitialization() {
    return _singleton;
  }

  AppInitialization._internal() {
    _isFirstRun = true;
    _loadFromPrefs();
  }

  void tutorialFinished() {
    _isFirstRun = false;
    _saveToPrefs();
  }

  void _loadFromPrefs() async {
    await _initPrefs();
    _isFirstRun = _prefs.getBool(key) ?? true;
  }

  void _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _isFirstRun);
  }

  void _initPrefs() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }
}
