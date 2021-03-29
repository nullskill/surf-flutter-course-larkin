import 'package:places/domain/sight_type.dart';
import 'package:places/ui/res/assets.dart';

/// Маппинг типа места и его метаданных
final sightTypes = <SightType, SightTypeMetadata>{
  SightType.hotel: SightTypeMetadata(
    name: 'Отель',
    iconName: AppIcons.hotel,
  ),
  SightType.restaurant: SightTypeMetadata(
    name: 'Ресторан',
    iconName: AppIcons.restaurant,
  ),
  SightType.other: SightTypeMetadata(
    name: 'Особое место',
    iconName: AppIcons.particularPlace,
  ),
  SightType.park: SightTypeMetadata(
    name: 'Парк',
    iconName: AppIcons.park,
  ),
  SightType.museum: SightTypeMetadata(
    name: 'Музей',
    iconName: AppIcons.museum,
  ),
  SightType.cafe: SightTypeMetadata(
    name: 'Кафе',
    iconName: AppIcons.cafe,
  ),
  SightType.temple: SightTypeMetadata(
    name: 'Храм',
    iconName: AppIcons.particularPlace,
  ),
  SightType.monument: SightTypeMetadata(
    name: 'Монумент',
    iconName: AppIcons.particularPlace,
  ),
  SightType.theatre: SightTypeMetadata(
    name: 'Театр',
    iconName: AppIcons.particularPlace,
  ),
};
