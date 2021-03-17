import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
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
  splashColor: LightMode.greenColor.withAlpha(50),
  //Text (disabled)
  disabledColor: inactiveColor,

  //AppBar
  appBarTheme: _BaseProps.appBarTheme.copyWith(
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
  sliderTheme: _BaseProps.sliderTheme.copyWith(
    overlayColor: LightMode.greenColor.withAlpha(32),
    activeTrackColor: LightMode.greenColor,
  ),

  //TextField InputDecorationTheme
  inputDecorationTheme: _BaseProps.inputDecorationTheme.copyWith(
    border: OutlineInputBorder(
      borderRadius: allBorderRadius8,
      borderSide: const BorderSide(color: inactiveColor),
    ),
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
  buttonTheme: const ButtonThemeData(
    buttonColor: LightMode.greenColor,
    disabledColor: backgroundColor,
  ),

  //ElevatedButton
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(0.0),
      shadowColor: MaterialStateProperty.all(transparentColor),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return backgroundColor;
          }
          return LightMode.greenColor;
        },
      ),
    ),
  ),

  //TextButton
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) => LightMode.greenColor,
      ),
      overlayColor: MaterialStateProperty.resolveWith<Color>(
        (states) => LightMode.greenColor.withAlpha(50),
      ),
    ),
  ),

  //FAB
  floatingActionButtonTheme: _BaseProps.floatingActionButtonTheme.copyWith(
    backgroundColor: LightMode.greenColor,
  ),

  //BottomNavigationBar
  bottomNavigationBarTheme: _BaseProps.bottomNavigationBarTheme.copyWith(
    backgroundColor: whiteColor,
    selectedItemColor: LightMode.primaryColor,
    unselectedItemColor: inactiveColor,
  ),

  //TimePicker
  timePickerTheme: _timePickerTheme(LightMode.greenColor),
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
  shadowColor: DarkMode.greenColor.withOpacity(.25),
  accentColor: DarkMode.greenColor,
  errorColor: DarkMode.redColor,
  splashColor: DarkMode.greenColor.withOpacity(.35),
  //Text (disabled)
  disabledColor: inactiveColor,

  //AppBar
  appBarTheme: _BaseProps.appBarTheme.copyWith(
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
  sliderTheme: _BaseProps.sliderTheme.copyWith(
    overlayColor: DarkMode.greenColor.withAlpha(32),
    activeTrackColor: DarkMode.greenColor,
  ),

  //TextField InputDecorationTheme
  inputDecorationTheme: _BaseProps.inputDecorationTheme.copyWith(
    border: OutlineInputBorder(
      borderRadius: allBorderRadius8,
      borderSide: const BorderSide(color: inactiveColor),
    ),
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
  buttonTheme: const ButtonThemeData(
    buttonColor: DarkMode.greenColor,
    disabledColor: DarkMode.darkColor,
  ),

  //ElevatedButton
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(0.0),
      shadowColor: MaterialStateProperty.all(transparentColor),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return DarkMode.darkColor;
          }
          return DarkMode.greenColor;
        },
      ),
    ),
  ),

  //TextButton
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) => LightMode.greenColor,
      ),
      overlayColor: MaterialStateProperty.resolveWith<Color>(
        (states) => DarkMode.greenColor.withAlpha(50),
      ),
    ),
  ),

  //FAB
  floatingActionButtonTheme: _BaseProps.floatingActionButtonTheme.copyWith(
    backgroundColor: DarkMode.greenColor,
  ),

  //BottomNavigationBar
  bottomNavigationBarTheme: _BaseProps.bottomNavigationBarTheme.copyWith(
    backgroundColor: DarkMode.primaryColor,
    selectedItemColor: whiteColor,
    unselectedItemColor: secondaryColor2,
  ),

  //TimePicker
  timePickerTheme: _timePickerTheme(DarkMode.greenColor),

  cupertinoOverrideTheme: const CupertinoThemeData(
    textTheme: CupertinoTextThemeData(
      dateTimePickerTextStyle: TextStyle(color: whiteColor),
      pickerTextStyle: TextStyle(
        color: whiteColor,
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
);

/// Класс общих настроек для тем
class _BaseProps {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  // ignore: unused_element
  _BaseProps._();

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
    contentPadding: EdgeInsets.symmetric(
      vertical: 12,
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

  @override
  Rect getPreferredRect({
    @required RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
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

TimePickerThemeData _timePickerTheme(Color mainColor) {
  final TimePickerThemeData base = ThemeData().timePickerTheme;
  Color myTimePickerMaterialStateColorFunc(Set<MaterialState> states,
      {bool withBackgroundColor = false}) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.selected, //This is the one actually used
    };
    if (states.any(interactiveStates.contains)) {
      // the color to return when button is in pressed, hovered, focused, or selected state
      return mainColor.withOpacity(0.12);
    }
    // the color to return when button is in it's normal/unfocused state
    return withBackgroundColor ? Colors.grey[200] : Colors.transparent;
  }

  return base.copyWith(
    hourMinuteTextColor: mainColor,
    hourMinuteColor: MaterialStateColor.resolveWith((states) =>
        myTimePickerMaterialStateColorFunc(states, withBackgroundColor: true)),
    //Background of Hours/Minute input
    dayPeriodTextColor: mainColor,
    dayPeriodColor:
        MaterialStateColor.resolveWith(myTimePickerMaterialStateColorFunc),
    //Background of AM/PM.
    dialHandColor: mainColor,
  );
}
