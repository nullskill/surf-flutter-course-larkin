import 'package:flutter/material.dart';

import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/border_radiuses.dart';

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

  //AppBar
  appBarTheme: AppBarTheme(
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

  //FAB
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 0,
    hoverElevation: 0,
    focusElevation: 0,
    backgroundColor: LightMode.greenColor,
  ),

  //BottomNavigationBar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
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

  //AppBar
  appBarTheme: AppBarTheme(
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

  //FAB
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 0,
    hoverElevation: 0,
    focusElevation: 0,
    backgroundColor: DarkMode.greenColor,
  ),

  //BottomNavigationBar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: DarkMode.primaryColor,
    selectedItemColor: whiteColor,
    unselectedItemColor: secondaryColor2,
  ),
);
