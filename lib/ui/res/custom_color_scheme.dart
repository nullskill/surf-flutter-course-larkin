import 'package:flutter/material.dart';

import 'package:places/ui/res/colors.dart';

/// Расширение для ColorScheme, добавляет кастомные цвета
extension CustomColorScheme on ColorScheme {
  Color get appBackButtonColor =>
      getColorByBrightness(whiteColor, DarkMode.primaryColor);
  Color get sightDetailsTitleColor =>
      getColorByBrightness(secondaryColor, whiteColor);
  Color get sightDetailsTypeColor =>
      getColorByBrightness(secondaryColor, secondaryColor2);
  Color get sightDetailsOpenHoursColor =>
      getColorByBrightness(secondaryColor2, inactiveColor);

  /// Метод возвращает либо lightThemeColor, либо darkThemeColor,
  /// в зависимости от свойства brightness
  Color getColorByBrightness(Color lightThemeColor, Color darkThemeColor) {
    return brightness == Brightness.light ? lightThemeColor : darkThemeColor;
  }
}
