import 'package:flutter/material.dart';
import 'package:places/domain/sight_type.dart';
import 'package:places/ui/res/assets.dart';

/// Класс категории интересных мест
class Category {
  String _name;
  String _iconName;
  SightType _type;
  bool _selected;

  get name => _name;

  get iconName => _iconName;

  get type => _type;

  // ignore: unnecessary_getters_setters
  get selected => _selected;

  // ignore: unnecessary_getters_setters
  set selected(bool b) => _selected = b;

  Category({
    @required String name,
    @required String iconName,
    @required SightType type,
    bool selected = false,
  }) {
    this._name = name;
    this._iconName = iconName;
    this._type = type;
    this._selected = selected;
  }

  Category.fromType({
    @required type,
  }) {
    this._type = type;
    this._selected = false;
    this._name = _typesMapping[type]?.first ?? "Особое место";
    this._iconName = _typesMapping[type]?.last ?? AppIcons.particular_place;
  }

  /// Меняет признак выбранности категории
  void toggle() {
    _selected = !_selected;
  }

  /// Сбрасывает признак выбранности категории
  void reset() {
    _selected = false;
  }
}

/// Маппинг типа места и его названия
const _typesMapping = <SightType, List<String>>{
  SightType.hotel: ["Отель", AppIcons.hotel],
  SightType.restaurant: ["Ресторан", AppIcons.restaurant],
  SightType.particular_place: ["Особое место", AppIcons.particular_place],
  SightType.park: ["Парк", AppIcons.park],
  SightType.museum: ["Музей", AppIcons.museum],
  SightType.cafe: ["Кафе", AppIcons.cafe],
};
