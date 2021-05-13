import 'package:places/data/storage/app_storage.dart';

/// Класс интерактора онбординга
class OnboardingInteractor {
  OnboardingInteractor()
      : _isFirstRun = AppStorage.getBool(_firstRunKey) ?? true;

  static const _firstRunKey = 'first_run';

  bool _isFirstRun;

  /// Возвращает флаг завершения обучения
  bool get isFirstRun => _isFirstRun;

  /// Сохраняет флаг завершения обучения
  void tutorialFinished() {
    _isFirstRun = false;
    AppStorage.setBool(_firstRunKey, _isFirstRun);
  }
}
