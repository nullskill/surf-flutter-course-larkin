/// Перечисление возможных типов мест
enum SightType {
  hotel,
  restaurant,
  particularPlace,
  park,
  museum,
  cafe,
}

/// Класс метаданных типа места
class SightTypeMetadata {
  SightTypeMetadata({this.name, this.iconName});

  String name;
  String iconName;
}
