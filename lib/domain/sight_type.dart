/// Перечисление возможных типов мест
enum SightType {
  hotel,
  restaurant,
  particular_place,
  park,
  museum,
  cafe,
}

/// Класс метаданных типа места
class SightTypeMetadata {
  String name;
  String iconName;

  SightTypeMetadata({this.name, this.iconName});
}
