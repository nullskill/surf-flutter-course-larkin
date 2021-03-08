import 'package:flutter/material.dart';
import 'package:places/domain/base_visiting.dart';
import 'package:places/domain/sight.dart';

/// Класс посещенного интересного места
class VisitedSight extends Sight implements VisitingSight {
  VisitedSight.fromSight({
    @required Sight sight,
    @required this.visitedDate,
    @required this.openHour,
  }) : super(
          name: sight.name,
          lat: sight.lat,
          lng: sight.lng,
          url: sight.url,
          details: sight.details,
          type: sight.type,
        );

  DateTime visitedDate;
  @override
  DateTime openHour;
}
