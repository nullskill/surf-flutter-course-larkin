import 'package:flutter/material.dart';

import 'package:places/ui/res/colors.dart';

/// Основные темы приложения
final lightTheme = ThemeData(
  primaryColor: LightMode.primaryColor,
  canvasColor: whiteColor,
);

final darkTheme = ThemeData(
  primaryColor: DarkMode.primaryColor,
  canvasColor: DarkMode.darkColor,
);
