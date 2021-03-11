import 'package:flutter/material.dart';
import 'package:places/domain/sight_type.dart';
import 'package:places/domain/sight_types.dart';
import 'package:places/ui/res/assets.dart';

/// Класс категории интересных мест
class Category {
  Category({
    @required this.name,
    @required this.iconName,
    @required this.type,
    this.selected,
  });

  Category.fromType(this.type)
      : name = sightTypes[type]?.name ?? 'Особое место',
        iconName = sightTypes[type]?.iconName ?? AppIcons.particularPlace;

  String name;
  String iconName;
  SightType type;
  bool selected;

  /// Меняет признак выбранности категории
  void toggle() {
    selected = !selected;
  }

  /// Сбрасывает признак выбранности категории
  void reset() {
    selected = false;
  }
}
