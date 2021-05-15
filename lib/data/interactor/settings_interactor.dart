import 'package:flutter/foundation.dart';
import 'package:places/data/storage/app_storage.dart';

/// Класс интерактора настроек
class SettingsInteractor extends ChangeNotifier {
  SettingsInteractor() {
    _darkTheme = AppStorage.getBool(_themeKey) ?? true;
    notifyListeners();
  }

  static const _themeKey = 'theme';

  bool _darkTheme;

  /// Возвращает сохраненную тему
  bool get darkTheme => _darkTheme;

  /// Переключает тему приложения и сохраняет выбранное значение
  void toggleTheme() {
    _darkTheme = !_darkTheme;
    AppStorage.setBool(_themeKey, _darkTheme);
    notifyListeners();
  }
}
