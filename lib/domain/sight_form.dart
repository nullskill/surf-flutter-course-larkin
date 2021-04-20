import 'package:places/domain/sight_type.dart';

class SightForm {
  String name, details;
  List<String> urls;
  double lat, lng;
  SightType type;

  @override
  String toString() {
    return 'SightForm{name: $name}';
  }
}
