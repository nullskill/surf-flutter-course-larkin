import 'package:places/domain/sight.dart';

/// Модель данных места из API
class Place {
  Place({
    this.id,
    this.lat,
    this.lng,
    this.name,
    this.urls,
    this.placeType,
    this.description,
    this.distance,
  });

  Place.fromSight(Sight sight)
      : id = null, // auto inc key field
        lat = sight.lat,
        lng = sight.lng,
        name = sight.name,
        urls = sight.urls,
        placeType = sight.type.toString().split('.').last,
        description = sight.details,
        distance = sight.distance;

  Place.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        lat = json['lat'] as double,
        lng = json['lng'] as double,
        name = json['name'] as String,
        urls = List<String>.from(json['urls'] as List<dynamic>),
        placeType = json['placeType'] as String,
        description = json['description'] as String,
        distance =
            json.containsKey('distance') ? json['distance'] as double : 0.0;

  final int id;
  final double lat;
  final double lng;
  final String name;
  final List<String> urls;
  final String placeType;
  final String description;
  double distance = 0.0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'lat': lat,
      'lng': lng,
      'name': name,
      'urls': urls,
      'placeType': placeType,
      'description': description,
    };

    return map;
  }
}
