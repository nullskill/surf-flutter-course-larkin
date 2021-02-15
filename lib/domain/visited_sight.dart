import 'package:flutter/material.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/sight_type.dart';

/// Класс посещенного интересного места
class VisitedSight extends Sight {
  DateTime _visitedDate;
  DateTime _openHour;

  get visitedDate => _visitedDate;

  get openHour => _openHour;

  VisitedSight({
    @required String name,
    @required double lat,
    @required double lng,
    @required String url,
    @required String details,
    @required SightType type,
    @required DateTime visitedDate,
    @required DateTime openHour,
  }) : super(
          name: name,
          lat: lat,
          lng: lng,
          url: url,
          details: details,
          type: type,
        ) {
    this._visitedDate = visitedDate;
    this._openHour = openHour;
  }

  VisitedSight.fromSight({
    @required Sight sight,
    @required DateTime visitedDate,
    @required DateTime openHour,
  }) : super(
          name: sight.name,
          lat: sight.lat,
          lng: sight.lng,
          url: sight.url,
          details: sight.details,
          type: sight.type,
        ) {
    this._visitedDate = _visitedDate;
    this._openHour = openHour;
  }
}
