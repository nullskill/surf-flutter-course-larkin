import 'package:places/data/model/location.dart';
import 'package:places/data/repository/location_repository.dart';

/// Класс интерактора локации
class LocationInteractor {
  LocationInteractor(this._locationRepo);

  final LocationRepository _locationRepo;

  Location _location;
  bool _didShowLocationError = false;

  /// Локация
  Location get location => _location;

  /// Флаг показа экрана ошибки доступа к геолокации
  bool get didShowLocationError => _didShowLocationError;

  /// Устанавливает флаг показа экрана ошибки доступа к геолокации
  void setShowLocationError() => _didShowLocationError = true;

  /// Инициализация геолокации
  Future<void> initLocation() async {
    _location = await _getCurrentLocation();
    _location ??= await _getLastKnownLocation();
  }

  /// Получает текущую геолокацию
  Future<Location> _getCurrentLocation() => _locationRepo.getCurrentLocation();

  /// Получает последнюю геолокацию
  Future<Location> _getLastKnownLocation() =>
      _locationRepo.getLastKnownLocation();
}
