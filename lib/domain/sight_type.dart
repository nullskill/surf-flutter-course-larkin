/// Перечисление возможных типов мест
enum SightType {
  temple,
  monument,
  park,
  theatre,
  museum,
  hotel,
  restaurant,
  cafe,
  other,
}

/// Класс метаданных типа места
class SightTypeMetadata {
  SightTypeMetadata({this.name, this.iconName});

  String name;
  String iconName;
}
