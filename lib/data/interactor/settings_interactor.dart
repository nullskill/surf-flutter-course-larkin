import 'package:flutter/foundation.dart';
import 'package:places/data/storage/app_storage.dart';

/// Класс интерактора настроек
class SettingsInteractor extends ChangeNotifier {
  SettingsInteractor() {
    _isDarkTheme = AppStorage.getBool(_themeKey) ?? true;
    notifyListeners();
  }

  static const _themeKey = 'theme';

  bool _isDarkTheme;

  /// Возвращает true, если текущая тема темная
  bool get isDarkTheme => _isDarkTheme;

  /// Переключает тему приложения и сохраняет выбранное значение
  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    AppStorage.setBool(_themeKey, _isDarkTheme);
    notifyListeners();
  }
}
