import 'package:flutter/material.dart';

/// Цветовые константы общие
const whiteColor = Colors.white,
    secondaryColor = Color(0xFF3B3E5B),
    secondaryColor2 = Color(0xFF7C7E92),
    backgroundColor = Color(0xFFF5F5F5),
    inactiveColor = Color.fromRGBO(124, 126, 146, 0.56),
    placeholderColor = Colors.purple;

/// Класс цветовых констант для светлой темы
class LightMode {
  static const greenColor = Color(0xFF4CAF50),
      yellowColor = Color(0xFFFCDD3D),
      redColor = Color(0xFFEF4343),
      primaryColor = Color(0xFF252849);
}

/// Класс цветовых констант для темной темы
class DarkMode {
  static const greenColor = Color(0xFF6ADA6F),
      yellowColor = Color(0xFFFFE769),
      redColor = Color(0xFFCF2A2A),
      darkColor = Color(0xFF1A1A20),
      primaryColor = Color(0xFF21222C);
}
