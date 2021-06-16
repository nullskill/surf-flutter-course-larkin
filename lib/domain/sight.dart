import 'package:equatable/equatable.dart';
import 'package:places/data/model/place.dart';
import 'package:places/domain/base/visiting_sight.dart';
import 'package:places/domain/sight_form.dart';
import 'package:places/domain/sight_type.dart';

/// Класс интересного места
// ignore: must_be_immutable, prefer_mixin
class Sight extends Equatable with VisitingSight {
  Sight({
    this.id,
    this.name,
    this.urls,
    this.details,
    this.lat,
    this.lng,
    this.type,
    this.distance,
  });

  Sight.fromForm(SightForm sightForm)
      : lat = sightForm.lat,
        lng = sightForm.lng,
        name = sightForm.name,
        urls = sightForm.urls,
        type = sightForm.type,
        details = sightForm.details;

  Sight.fromPlace(Place place)
      : id = place.id,
        lat = place.lat,
        lng = place.lng,
        name = place.name,
        urls = place.urls,
        type = SightType.values.firstWhere(
          (el) => el.toString().split('.').last == place.placeType,
        ),
        details = place.description;

  Sight.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        lat = json['lat'] as double,
        lng = json['lng'] as double,
        name = json['name'] as String,
        urls = List<String>.from(json['urls'] as List<dynamic>),
        type = SightType.values.firstWhere(
          (t) => t.toString().split('.').last == (json['type'] as String),
        ),
        details = json['description'] as String;

  int id;
  final String name, details;
  final List<String> urls;
  final double lat, lng;
  final SightType type;
  double distance = 0.0;

  @override
  List<Object> get props => [id];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'lat': lat,
      'lng': lng,
      'name': name,
      'urls': urls,
      'type': type.toString().split('.').last,
      'details': details,
    };

    return map;
  }
}
