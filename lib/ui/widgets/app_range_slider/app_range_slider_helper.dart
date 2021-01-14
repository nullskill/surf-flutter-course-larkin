import 'package:flutter/material.dart';

import 'package:places/utils/consts.dart';

/// Вспомогательный класс для виджета AppRangeSlider
class AppRangeSliderHelper {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  // ignore: unused_element
  AppRangeSliderHelper._();

  static const divisions = 100,
      minValue = 100.0,
      maxValue = 10000.0,
      initialMinValue = 100.0,
      initialMaxValue = 5000.0,
      _m = "м",
      _km = "км";

  /// Возвращает текстовое представление выбранного диапазона
  static String getRangeDescription(RangeValues values) {
    double start = values.start;
    double end = values.end;

    return "от ${_getStringValue(start)} ${_getUnits(start)} до "
        "${_getStringValue(end)} ${_getUnits(end)}";
  }

  static String _getStringValue(double a) => _lessThanKilometer(a)
      ? _getStringAsFixed(a, 0)
      : _getStringAsFixed(a / kilometer, 3);

  static String _getStringAsFixed(double a, int f) => a.toStringAsFixed(f);

  static String _getUnits(double a) => _lessThanKilometer(a) ? _m : _km;

  static bool _lessThanKilometer(num a) => a < kilometer;
}
