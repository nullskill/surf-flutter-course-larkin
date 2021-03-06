import 'package:places/domain/base/visiting_sight.dart';
import 'package:places/domain/sight.dart';

/// Класс для желаемого к посещению интересного места
// ignore: must_be_immutable
class FavoriteSight extends Sight implements VisitingSight {
  FavoriteSight.fromSight(Sight sight)
      : plannedDate = DateTime.now(),
        openHour = DateTime(1970, 1, 1, 9),
        // 09:00
        super(
          id: sight.id,
          name: sight.name,
          lat: sight.lat,
          lng: sight.lng,
          urls: sight.urls,
          details: sight.details,
          type: sight.type,
        );

  FavoriteSight.fromJson(Map<String, dynamic> json)
      : plannedDate = DateTime.tryParse(json['plannedDate'].toString()),
        openHour = DateTime.tryParse(json['openHour'].toString()),
        super.fromJson(json);

  DateTime plannedDate;
  @override
  DateTime openHour;

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['plannedDate'] = plannedDate.toString();
    map['openHour'] = openHour.toString();

    return map;
  }
}
