import 'package:flutter/cupertino.dart';

/// Класс интересного места
class Sight {
  String _name;
  double _lan, _lon;
  String _url;
  String _details;
  String _type;

  get name => _name;
  get lan => _lan;
  get lon => _lon;
  get url => _url;
  get details => _details;
  get type => _type;

  Sight({
    @required String name,
    @required double lan,
    @required double lon,
    @required String url,
    @required String details,
    @required String type,
  }) {
    this._name = name;
    this._lan = lan;
    this._lon = lon;
    this._url = url;
    this._details = details;
    this._type = type;
  }
}

/// Класс для желаемого к посещению интересного места
class FavoriteSight extends Sight {
  DateTime _plannedDate;
  DateTime _openHour;

  get plannedDate => _plannedDate;
  get openHour => _openHour;

  FavoriteSight({
    @required String name,
    @required double lan,
    @required double lon,
    @required String url,
    @required String details,
    @required String type,
    @required DateTime plannedDate,
    @required DateTime openHour,
  }) : super(
          name: name,
          lan: lan,
          lon: lon,
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
  }) {
    this._name = sight.name;
    this._lan = sight.lan;
    this._lon = sight.lon;
    this._url = sight.url;
    this._details = sight.details;
    this._type = sight.type;
    this._plannedDate = plannedDate;
    this._openHour = openHour;
  }
}

/// Класс посещенного интересного места
class VisitedSight extends Sight {
  DateTime _visitedDate;
  DateTime _openHour;

  get visitedDate => _visitedDate;
  get openHour => _openHour;

  VisitedSight({
    @required String name,
    @required double lan,
    @required double lon,
    @required String url,
    @required String details,
    @required String type,
    @required DateTime visitedDate,
    @required DateTime openHour,
  }) : super(
          name: name,
          lan: lan,
          lon: lon,
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
  }) {
    this._name = sight.name;
    this._lan = sight.lan;
    this._lon = sight.lon;
    this._url = sight.url;
    this._details = sight.details;
    this._type = sight.type;
    this._visitedDate = visitedDate;
    this._openHour = openHour;
  }
}
