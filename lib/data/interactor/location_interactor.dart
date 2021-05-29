import 'package:places/data/location/device_location.dart';
import 'package:places/data/model/location.dart';

/// Класс интерактора локации
class LocationInteractor {
  /// Текущая локация
  Future<Location> getCurrentLocation() => DeviceLocation.getCurrentLocation();

  /// Последняя локация
  Future<Location> getLastKnownLocation() =>
      DeviceLocation.getLastKnownLocation();
}
