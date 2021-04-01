import 'package:places/domain/category.dart';
import 'package:places/domain/sight_type.dart';

/// Список категорий интересных мест
final categories = <Category>[
  for (var type in SightType.values) Category.fromType(type),
];
