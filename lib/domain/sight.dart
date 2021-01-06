import 'package:flutter/foundation.dart';

import 'package:places/ui/res/assets.dart';

/// Перечисление возможных типов мест
enum SightType {
  hotel,
  restaurant,
  particular_place,
  park,
  museum,
  cafe,
}

/// Класс интересного места
class Sight {
  String _name;
  double _lat, _lng;
  String _url;
  String _details;
  SightType _type;

  get name => _name;
  get lat => _lat;
  get lng => _lng;
  get url => _url;
  get details => _details;
  get type => _type;

  Sight({
    @required String name,
    @required double lat,
    @required double lng,
    @required String url,
    @required String details,
    @required SightType type,
  }) {
    this._name = name;
    this._lat = lat;
    this._lng = lng;
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
  }) {
    this._name = sight.name;
    this._lat = sight.lat;
    this._lng = sight.lng;
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
  }) {
    this._name = sight.name;
    this._lat = sight.lat;
    this._lng = sight.lng;
    this._url = sight.url;
    this._details = sight.details;
    this._type = sight.type;
    this._visitedDate = visitedDate;
    this._openHour = openHour;
  }
}

/// Класс категории интересных мест
class Category {
  String _name;
  String _iconName;
  SightType _type;
  bool _selected;

  get name => _name;
  get iconName => _iconName;
  get type => _type;
  get selected => _selected;

  set selected(bool b) => _selected = b;

  Category({
    @required String name,
    @required String iconName,
    @required SightType type,
    bool selected = false,
  }) {
    this._name = name;
    this._iconName = iconName;
    this._type = type;
    this._selected = selected;
  }

  Category.fromType({
    @required type,
  }) {
    this._type = type;
    this._selected = false;
    this._name = _typesMapping[type]?.first ?? "Особое место";
    this._iconName = _typesMapping[type]?.last ?? AppIcons.particular_place;
  }

  /// Меняет признак выбранности категории
  void toggle() {
    _selected = !_selected;
  }
}

/// Маппинг типа места и его названия
const _typesMapping = <SightType, List<String>>{
  SightType.hotel: ["Отель", AppIcons.hotel],
  SightType.restaurant: ["Ресторан", AppIcons.restaurant],
  SightType.particular_place: ["Особое место", AppIcons.particular_place],
  SightType.park: ["Парк", AppIcons.park],
  SightType.museum: ["Музей", AppIcons.museum],
  SightType.cafe: ["Кафе", AppIcons.cafe],
};
