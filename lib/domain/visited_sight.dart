import 'package:places/domain/base/visiting_sight.dart';
import 'package:places/domain/sight.dart';

/// Класс посещенного интересного места
// ignore: must_be_immutable
class VisitedSight extends Sight implements VisitingSight {
  VisitedSight.fromSight(Sight sight)
      : visitedDate = DateTime.now(),
        openHour = DateTime(1970, 1, 1, 9),
        super(
          id: sight.id,
          name: sight.name,
          lat: sight.lat,
          lng: sight.lng,
          urls: sight.urls,
          details: sight.details,
          type: sight.type,
        );

  VisitedSight.fromJson(Map<String, dynamic> json)
      : visitedDate = DateTime.tryParse(json['visitedDate'].toString()),
        openHour = DateTime.tryParse(json['openHour'].toString()),
        super.fromJson(json);

  DateTime visitedDate;
  @override
  DateTime openHour;

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['visitedDate'] = visitedDate.toString();
    map['openHour'] = openHour.toString();

    return map;
  }
}
