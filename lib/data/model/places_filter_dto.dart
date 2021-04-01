import 'package:places/data/model/radius_filter_dto.dart';
import 'package:places/domain/sight_type.dart';

/// Модель данных с параметрами фильтра мест
class PlacesFilterDto {
  // radiusFilter + typeFilter gives distance
  // nameFilter can be used without conditions
  PlacesFilterDto({
    this.radiusFilter,
    this.typeFilter,
    this.nameFilter,
  }) : assert(
            (radiusFilter != null && typeFilter != null) || nameFilter != null);

  final RadiusFilterDto radiusFilter;
  final List<SightType> typeFilter;
  final String nameFilter;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (radiusFilter != null) {
      map['lat'] = radiusFilter.lat;
      map['lng'] = radiusFilter.lng;
      map['radius'] = radiusFilter.radius;
      map['typeFilter'] = <String>[
        for (final SightType sightType in typeFilter)
          sightType.toString().split('.').last
      ];
    }
    if (nameFilter != null) {
      map['nameFilter'] = nameFilter;
    }

    return map;
  }
}
