import 'package:flutter/foundation.dart';
import 'package:places/domain/sight_type.dart';

/// Класс интересного места
class Sight {
  String _name, _url, _details;
  double _lat, _lng;
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
