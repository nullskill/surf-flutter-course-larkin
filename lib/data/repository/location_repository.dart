import 'package:places/data/model/location.dart';
import 'package:places/data/repository/common/error_handler.dart';
import 'package:places/data/repository/location/device_location.dart';

/// Репозиторий для локации
class LocationRepository {
  /// Получает текущую локацию
  Future<Location> getCurrentLocation() async {
    final Location location = await handleError<Location>(
      DeviceLocation.getCurrentLocation,
      message: 'Error getting current location',
    );

    return location;
  }

  /// Получает последнюю локацию
  Future<Location> getLastKnownLocation() async {
    final Location location = await handleError<Location>(
      DeviceLocation.getLastKnownLocation,
      message: 'Error getting last known location',
    );

    return location;
  }
}
