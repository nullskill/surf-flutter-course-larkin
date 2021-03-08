import 'package:places/utils/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Класс для инициализации приложения
class AppInitialization {
  factory AppInitialization() {
    return _singleton;
  }

  AppInitialization._internal() {
    _isFirstRun = true;
    _loadFromPrefs();
  }

  SharedPreferences _prefs;
  bool _isFirstRun;

  bool get isFirstRun => _isFirstRun;

  static final AppInitialization _singleton = AppInitialization._internal();

  void tutorialFinished() {
    _isFirstRun = false;
    _saveToPrefs();
  }

  Future<void> _loadFromPrefs() async {
    await _initPrefs();
    _isFirstRun = _prefs.getBool(firstRunKey) ?? true;
  }

  Future<void> _saveToPrefs() async {
    await _initPrefs();
    await _prefs.setBool(firstRunKey, _isFirstRun);
  }

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
}
