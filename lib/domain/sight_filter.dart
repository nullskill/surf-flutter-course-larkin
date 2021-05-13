import 'package:places/domain/sight_type.dart';

/// Модель критериев поиска
class SightFilter {
  SightFilter({
    this.minDistance,
    this.maxDistance,
    this.types,
  });

  SightFilter.fromJson(Map<String, dynamic> json)
      : minDistance = json['minDistance'] as double,
        maxDistance = json['maxDistance'] as double,
        types = List<String>.from(json['types'] as List)
            .map<SightType>((e) => SightType.values
                .firstWhere((type) => type.toString().split('.').last == e))
            .toList();

  double minDistance;
  double maxDistance;
  List<SightType> types;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'minDistance': minDistance,
        'maxDistance': maxDistance,
        'types': <String>[
          for (final SightType sightType in types)
            sightType.toString().split('.').last
        ],
      };

  @override
  String toString() {
    return 'Filter{min: $minDistance, max: $maxDistance, types: $types';
  }
}
