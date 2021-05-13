import 'package:shared_preferences/shared_preferences.dart';

/// Менеджер хранилища приложения
class AppStorage {
  static Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();
  static SharedPreferences _prefs;

  static Future<SharedPreferences> init() async {
    _prefs = await _instance;
    return _prefs;
  }

  static bool getBool(String key, {bool defValue = true}) {
    return _prefs.getBool(key) ?? defValue;
  }

  // ignore: avoid_positional_boolean_parameters
  static Future<bool> setBool(String key, bool value) async {
    final prefs = await _instance;
    return prefs?.setBool(key, value ?? false) ?? Future.value(false);
  }

  static String getString(String key, [String defValue = '']) {
    return _prefs.getString(key) ?? defValue;
  }

  static Future<bool> setString(String key, String value) async {
    final prefs = await _instance;
    return prefs?.setString(key, value) ?? Future.value(false);
  }
}
