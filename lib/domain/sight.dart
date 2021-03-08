import 'package:places/domain/sight_type.dart';

/// Класс интересного места
class Sight {
  Sight({
    this.name,
    this.url,
    this.details,
    this.lat,
    this.lng,
    this.type,
  });

  String name, url, details;
  double lat, lng;
  SightType type;
}
