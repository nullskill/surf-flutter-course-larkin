import 'package:flutter/material.dart';
import 'package:places/domain/base_visiting.dart';
import 'package:places/domain/sight.dart';

/// Класс для желаемого к посещению интересного места
class FavoriteSight extends Sight implements VisitingSight {
  FavoriteSight.fromSight({
    @required Sight sight,
    @required this.plannedDate,
    @required this.openHour,
  }) : super(
          name: sight.name,
          lat: sight.lat,
          lng: sight.lng,
          url: sight.url,
          details: sight.details,
          type: sight.type,
        );

  DateTime plannedDate;
  @override
  DateTime openHour;
}
