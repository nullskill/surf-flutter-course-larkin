import 'package:flutter/material.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/sight_type.dart';

/// Класс для желаемого к посещению интересного места
class FavoriteSight extends Sight {
  DateTime _plannedDate;
  DateTime _openHour;

  get plannedDate => _plannedDate;

  get openHour => _openHour;

  FavoriteSight({
    @required String name,
    @required double lat,
    @required double lng,
    @required String url,
    @required String details,
    @required SightType type,
    @required DateTime plannedDate,
    @required DateTime openHour,
  }) : super(
          name: name,
          lat: lat,
          lng: lng,
          url: url,
          details: details,
          type: type,
        ) {
    this._plannedDate = plannedDate;
    this._openHour = openHour;
  }

  FavoriteSight.fromSight({
    @required Sight sight,
    @required DateTime plannedDate,
    @required DateTime openHour,
  }) : super(
          name: sight.name,
          lat: sight.lat,
          lng: sight.lng,
          url: sight.url,
          details: sight.details,
          type: sight.type,
        ) {
    this._plannedDate = plannedDate;
    this._openHour = openHour;
  }
}
