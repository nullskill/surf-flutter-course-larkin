import 'package:places/domain/sight_type.dart';

/// Модель критериев поиска
class SightFilter {
  SightFilter({
    this.minRadius,
    this.maxRadius,
    this.types,
  });

  SightFilter.fromJson(Map<String, dynamic> json)
      : minRadius = json['minRadius'] as double,
        maxRadius = json['maxRadius'] as double,
        types = List<String>.from(json['types'] as List)
            .map<SightType>((e) => SightType.values
                .firstWhere((type) => type.toString().split('.').last == e))
            .toList();

  double minRadius;
  double maxRadius;
  List<SightType> types;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'minRadius': minRadius,
        'maxRadius': maxRadius,
        'types': <String>[
          for (final SightType sightType in types)
            sightType.toString().split('.').last
        ],
      };

  @override
  String toString() {
    return 'Filter{min: $minRadius, max: $maxRadius, types: $types';
  }
}
