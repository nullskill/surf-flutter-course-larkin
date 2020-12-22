import 'package:flutter/material.dart';

import 'package:places/ui/res/colors.dart';

/// Виджет AppBottomNavigationBar предназначен для всего приложения
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    Key key,
    @required this.currentIndex,
  }) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: primaryColor,
      unselectedItemColor: inactiveColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "",
        ),
      ],
    );
  }
}
