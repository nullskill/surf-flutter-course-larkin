import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:places/domain/sight.dart';
import 'package:places/util/consts.dart';

/// Вспомогательный класс для экрана фильтров
class FiltersScreenHelper {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  // ignore: unused_element
  FiltersScreenHelper._();

  static Point centerPoint = Point(
    name: 'Москва, Красная площадь',
    lat: 55.754093,
    lng: 37.620407,
  );

  /// Определеяет вхождение координат карточки интересного места [checkPoint]
  /// в радиусе от [minValue] до [maxValue], начиная с точки [centerPoint]
  static bool arePointsNear({
    @required Sight checkPoint,
    @required Point centerPoint,
    @required double minValue,
    @required double maxValue,
  }) {
    const ky = 40000 / 360;
    final kx = cos(pi * centerPoint.lat / 180.0) * ky;
    final dx = (centerPoint.lng - checkPoint.lng).abs() * kx;
    final dy = (centerPoint.lat - checkPoint.lat).abs() * ky;
    final d = sqrt(dx * dx + dy * dy);
    return d >= minValue / kilometer && d <= maxValue / kilometer;
  }
}

/// Класс точки координат
class Point {
  Point({
    @required this.name,
    @required this.lat,
    @required this.lng,
  });

  final String name;
  final double lat, lng;
}
