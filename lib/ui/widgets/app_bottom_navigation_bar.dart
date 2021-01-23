import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/screens/settings_screen.dart';

/// Виджет AppBottomNavigationBar предназначен для всего приложения
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    Key key,
    @required this.currentIndex,
  }) : super(key: key);

  final int currentIndex;

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: inactiveColor,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          switch (index) {
            case 3:
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
                break;
              }
            case 2:
            case 1:
            case 0:
            default:
              print("BottomNavigationBarItem $index tapped");
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              currentIndex == 0 ? AppIcons.listFull : AppIcons.list,
              color:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              currentIndex == 1 ? AppIcons.mapFull : AppIcons.map,
              color:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              currentIndex == 2 ? AppIcons.heartFull : AppIcons.heart,
              color:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              currentIndex == 3 ? AppIcons.settingsFull : AppIcons.settings,
              color:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
