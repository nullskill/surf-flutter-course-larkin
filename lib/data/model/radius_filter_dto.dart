import 'package:flutter/foundation.dart';
import 'package:places/data/model/base/geo_point.dart';

/// Модель данных фильтра мест по радиусу
class RadiusFilterDto extends GeoPoint {
  RadiusFilterDto({
    @required this.radius,
    @required double lat,
    @required double lng,
  }) : super(lat: lat, lng: lng);

  // Max radius from RangeSlider
  final double radius;
}
