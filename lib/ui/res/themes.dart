import 'package:flutter/material.dart';

import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/text_styles.dart';

/// Основные темы приложения:
/// Светлая тема
final lightTheme = ThemeData(
  brightness: Brightness.light,

  //General colors
  primaryColor: LightMode.primaryColor,
  primaryColorDark: secondaryColor,
  primaryColorLight: secondaryColor2,
  buttonColor: LightMode.greenColor,
  canvasColor: whiteColor,
  backgroundColor: backgroundColor,
  shadowColor: blackColor,
  accentColor: LightMode.greenColor,
  errorColor: LightMode.redColor,
  //Text (disabled)
  disabledColor: inactiveColor,

  //AppBar
  appBarTheme: BaseProps.appBarTheme.copyWith(
    brightness: Brightness.light,
  ),

  //TabBar
  tabBarTheme: TabBarTheme(
    indicator: BoxDecoration(
      color: secondaryColor,
      borderRadius: allBorderRadius40,
    ),
    labelColor: whiteColor,
    unselectedLabelColor: inactiveColor,
  ),

  //Slider & RangeSlider
  sliderTheme: BaseProps.sliderTheme.copyWith(
    overlayColor: LightMode.greenColor.withAlpha(32),
    activeTrackColor: LightMode.greenColor,
  ),

  //TextField InputDecorationTheme
  inputDecorationTheme: BaseProps.inputDecorationTheme.copyWith(
    enabledBorder: OutlineInputBorder(
      borderRadius: allBorderRadius8,
      borderSide: const BorderSide(color: LightMode.inputBorderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: allBorderRadius8,
      borderSide:
          const BorderSide(color: LightMode.inputBorderColor, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: allBorderRadius8,
      borderSide: const BorderSide(color: LightMode.redColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: allBorderRadius8,
      borderSide: const BorderSide(color: LightMode.redColor, width: 2.0),
    ),
    hintStyle: textRegular16.copyWith(
      color: inactiveColor,
      height: lineHeight1_25,
    ),
  ),

  //Button
  buttonTheme: ButtonThemeData(
    buttonColor: LightMode.greenColor,
    disabledColor: backgroundColor,
  ),

  //FAB
  floatingActionButtonTheme: BaseProps.floatingActionButtonTheme.copyWith(
    backgroundColor: LightMode.greenColor,
  ),

  //BottomNavigationBar
  bottomNavigationBarTheme: BaseProps.bottomNavigationBarTheme.copyWith(
    backgroundColor: whiteColor,
    selectedItemColor: LightMode.primaryColor,
    unselectedItemColor: inactiveColor,
  ),
);

/// Темная тема
final darkTheme = ThemeData(
  brightness: Brightness.dark,

  //General colors
  primaryColor: whiteColor,
  primaryColorDark: secondaryColor,
  primaryColorLight: secondaryColor2,
  buttonColor: DarkMode.greenColor,
  canvasColor: DarkMode.primaryColor,
  backgroundColor: DarkMode.darkColor,
  shadowColor: whiteColor,
  accentColor: DarkMode.greenColor,
  errorColor: DarkMode.redColor,
  //Text (disabled)
  disabledColor: inactiveColor,

  //AppBar
  appBarTheme: BaseProps.appBarTheme.copyWith(
    brightness: Brightness.dark,
  ),

  //TabBar
  tabBarTheme: TabBarTheme(
    indicator: BoxDecoration(
      color: whiteColor,
      borderRadius: allBorderRadius40,
    ),
    labelColor: secondaryColor,
    unselectedLabelColor: secondaryColor2,
  ),

  //Slider & RangeSlider
  sliderTheme: BaseProps.sliderTheme.copyWith(
    overlayColor: DarkMode.greenColor.withAlpha(32),
    activeTrackColor: DarkMode.greenColor,
  ),

  //TextField InputDecorationTheme
  inputDecorationTheme: BaseProps.inputDecorationTheme.copyWith(
    enabledBorder: OutlineInputBorder(
      borderRadius: allBorderRadius8,
      borderSide: const BorderSide(color: DarkMode.inputBorderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: allBorderRadius8,
      borderSide:
          const BorderSide(color: DarkMode.inputBorderColor, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: allBorderRadius8,
      borderSide: const BorderSide(color: DarkMode.redColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: allBorderRadius8,
      borderSide: const BorderSide(color: DarkMode.redColor, width: 2.0),
    ),
    hintStyle: textRegular16.copyWith(
      color: inactiveColor,
      height: lineHeight1_25,
    ),
  ),

  //Button
  buttonTheme: ButtonThemeData(
    buttonColor: DarkMode.greenColor,
    disabledColor: DarkMode.darkColor,
  ),

  //FAB
  floatingActionButtonTheme: BaseProps.floatingActionButtonTheme.copyWith(
    backgroundColor: DarkMode.greenColor,
  ),

  //BottomNavigationBar
  bottomNavigationBarTheme: BaseProps.bottomNavigationBarTheme.copyWith(
    backgroundColor: DarkMode.primaryColor,
    selectedItemColor: whiteColor,
    unselectedItemColor: secondaryColor2,
  ),
);

/// Класс общих настроек для тем
class BaseProps {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  // ignore: unused_element
  BaseProps._();

  //AppBar
  static const appBarTheme = AppBarTheme(
    color: transparentColor,
    elevation: 0,
  );

  //Slider & RangeSlider
  static const sliderTheme = SliderThemeData(
    trackHeight: 2.0,
    thumbColor: whiteColor,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 16.0),
    inactiveTrackColor: inactiveColor,
    activeTickMarkColor: transparentColor,
    inactiveTickMarkColor: transparentColor,
    rangeTrackShape: _SliderTrackShape(), //RangeSlider only
  );

  //TextField InputDecorationTheme
  static const inputDecorationTheme = InputDecorationTheme(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 16,
    ),
  );

  //FAB
  static const floatingActionButtonTheme = FloatingActionButtonThemeData(
    elevation: 0,
    hoverElevation: 0,
    focusElevation: 0,
  );

  //BottomNavigationBar
  static const bottomNavigationBarTheme = BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 0,
  );
}

class _SliderTrackShape extends RoundedRectRangeSliderTrackShape {
  const _SliderTrackShape();

  static const _leftPadding = 8;
  static const _rightPadding = 16;

  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx + _leftPadding;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - _rightPadding;
    return Rect.fromLTWH(
      trackLeft,
      trackTop,
      trackWidth,
      trackHeight,
    );
  }
}
