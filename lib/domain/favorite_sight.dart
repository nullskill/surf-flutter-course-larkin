import 'package:places/domain/base/visiting_sight.dart';
import 'package:places/domain/sight.dart';

/// Класс для желаемого к посещению интересного места
class FavoriteSight extends Sight implements VisitingSight {
  FavoriteSight.fromSight(
    Sight sight,
  )   : plannedDate = DateTime.now(),
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

  DateTime plannedDate;
  @override
  DateTime openHour;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteSight &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => name.hashCode;
}
