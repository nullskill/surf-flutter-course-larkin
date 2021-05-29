import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart';
import 'package:places/data/location/exceptions.dart';
import 'package:places/data/model/base/geo_point.dart';
import 'package:places/data/model/location.dart';

/// Менеджер геопозиции устройства
class DeviceLocation {
  /// Текущая локация
  static Future<Location> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw ServiceException();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw NoPermissionException();
      }
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return _getLocationFromGeoPoint(
        GeoPoint(lat: position.latitude, lng: position.longitude));
  }

  /// Последняя локация
  static Future<Location> getLastKnownLocation() async {
    final position = await Geolocator.getLastKnownPosition();

    return _getLocationFromGeoPoint(
        GeoPoint(lat: position.latitude, lng: position.longitude));
  }

  /// Возвращает объект локации
  static Future<Location> _getLocationFromGeoPoint(GeoPoint geoPoint) async {
    String name = '';
    try {
      final placemarks =
          await placemarkFromCoordinates(geoPoint.lat, geoPoint.lng);
      final place = placemarks.first;
      name = '${place.locality}, ${place.postalCode}, ${place.country}';
    } on Object catch (e) {
      debugPrint('e: $e');
    }
    return Location(name: name, lat: geoPoint.lat, lng: geoPoint.lng);
  }
}
