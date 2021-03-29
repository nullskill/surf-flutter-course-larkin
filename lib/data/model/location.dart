import 'package:flutter/foundation.dart';
import 'package:places/data/model/base/geo_point.dart';

/// Модель точки координат
class Location extends GeoPoint {
  Location({
    @required this.name,
    @required double lat,
    @required double lng,
  }) : super(lat: lat, lng: lng);

  final String name;

  @override
  String toString() {
    return '$name ${super.toString()}';
  }
}
