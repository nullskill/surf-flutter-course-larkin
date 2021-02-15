import 'package:places/domain/sight_type.dart';
import 'package:places/ui/res/assets.dart';

/// Маппинг типа места и его названия
const sightTypes = <SightType, List<String>>{
  SightType.hotel: ["Отель", AppIcons.hotel],
  SightType.restaurant: ["Ресторан", AppIcons.restaurant],
  SightType.particular_place: ["Особое место", AppIcons.particular_place],
  SightType.park: ["Парк", AppIcons.park],
  SightType.museum: ["Музей", AppIcons.museum],
  SightType.cafe: ["Кафе", AppIcons.cafe],
};
