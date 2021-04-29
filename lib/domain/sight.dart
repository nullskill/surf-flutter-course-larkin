import 'package:equatable/equatable.dart';
import 'package:places/data/model/place.dart';
import 'package:places/domain/sight_form.dart';
import 'package:places/domain/sight_type.dart';

/// Класс интересного места
// ignore: must_be_immutable
class Sight extends Equatable {
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
            (el) => el.toString().split('.').last == place.placeType),
        details = place.description;

  int id;
  final String name, details;
  final List<String> urls;
  final double lat, lng;
  final SightType type;
  double distance = 0.0;

  @override
  List<Object> get props => [id];
}
