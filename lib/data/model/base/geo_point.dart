import 'package:flutter/foundation.dart';

/// Базовая модель локации
class GeoPoint {
  GeoPoint({
    @required this.lat,
    @required this.lng,
  });

  final double lat, lng;

  @override
  String toString() {
    return '(шир.: $lat, долг.: $lng)';
  }
}
