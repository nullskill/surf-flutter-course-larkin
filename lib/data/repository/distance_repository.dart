import 'dart:math';

import 'package:places/data/model/location.dart';
import 'package:places/domain/sight.dart';
import 'package:places/util/consts.dart';

/// Репозиторий для опеределения дистанции до мест
class DistanceRepository {
  /// Минимальный и максимальный радиус
  static const double minRadius = 100.0, maxRadius = 5000.0;

  /// Выбранные минимальный и максимальный радиус
  double selectedMinRadius = minRadius, selectedMaxRadius = maxRadius;

  // Временно
  final Location _location = Location(
    name: 'Москва, Красная площадь',
    lat: lat,
    lng: lng,
  );

  /// Минимальная дистанция
  double get minDistance => selectedMinRadius / kilometer;

  /// Максимальная дистанция
  double get maxDistance => selectedMaxRadius / kilometer;

  /// Дефолтная локация (временно)
  Location get location => _location;

  /// Сортирует модели [Sight] по удаленности и возвращает список [Sight]
  List<T> getSortedSights<T extends Sight>(List<T> sights) {
    return sights.map(_setSightDistance).where(_isSightNear).toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
  }

  /// Вычисляет дистанцию до координат места [sight]
  /// от локации [location] и устанавливает в свойство [Sight.distance]
  T _setSightDistance<T extends Sight>(T sight) {
    const double ky = 40000 / 360;
    final double kx = cos(pi * location.lat / 180.0) * ky;
    final double dx = (location.lng - sight.lng).abs() * kx;
    final double dy = (location.lat - sight.lat).abs() * ky;
    final double d = sqrt(dx * dx + dy * dy);

    sight.distance = d;

    return sight;
  }

  /// Проверяет вхождение дистанции до интересного места [sight]
  /// в интервале радиуса от [minDistance] до [maxDistance]
  bool _isSightNear(Sight sight) =>
      sight.distance >= minDistance && sight.distance <= maxDistance;
}
