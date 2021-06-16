import 'package:flutter/material.dart';
import 'package:places/ui/res/colors.dart';

/// Расширение для ColorScheme, добавляет кастомные цвета
extension AppColorScheme on ColorScheme {
  Color get appTitleColor => getColorByBrightness(secondaryColor, whiteColor);

  Color get appSubtitleColor =>
      getColorByBrightness(secondaryColor, secondaryColor2);

  Color get appSecondarySubtitleColor =>
      getColorByBrightness(secondaryColor2, inactiveColor);

  Color get appDialogLabelColor =>
      getColorByBrightness(secondaryColor2, whiteColor);

  Color get appPrimaryGradientColor =>
      getColorByBrightness(LightMode.yellowColor, DarkMode.yellowColor);

  Color get appMapButtonColor =>
      getColorByBrightness(whiteColor, secondaryColor);

  /// Метод возвращает либо lightThemeColor, либо darkThemeColor,
  /// в зависимости от свойства brightness
  Color getColorByBrightness(Color lightThemeColor, Color darkThemeColor) {
    return brightness == Brightness.light ? lightThemeColor : darkThemeColor;
  }
}
