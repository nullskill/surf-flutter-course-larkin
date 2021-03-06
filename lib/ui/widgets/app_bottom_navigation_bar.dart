import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/colors.dart';

/// Виджет AppBottomNavigationBar предназначен для всего приложения
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    @required this.currentIndex,
    Key key,
  }) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
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
        onTap: (index) => _switchBottomTab(context, index),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              currentIndex == 0 ? AppIcons.listFull : AppIcons.list,
              color:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              currentIndex == 1 ? AppIcons.mapFull : AppIcons.map,
              color:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              currentIndex == 2 ? AppIcons.heartFull : AppIcons.heart,
              color:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              currentIndex == 3 ? AppIcons.settingsFull : AppIcons.settings,
              color:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            ),
            label: '',
          ),
        ],
      ),
    );
  }

  void _switchBottomTab(BuildContext context, int index) {
    final currentRoute = ModalRoute.of(context).settings.name;

    switch (index) {
      case 3:
        if (currentRoute == AppRoutes.settings) return;
        Navigator.pushNamed(context, AppRoutes.settings);
        break;
      case 2:
        if (currentRoute == AppRoutes.visiting) return;
        Navigator.pushNamed(context, AppRoutes.visiting);
        break;
      case 1:
        if (currentRoute == AppRoutes.map) return;
        Navigator.pushNamed(context, AppRoutes.map);
        break;
      case 0:
      default:
        if (currentRoute == AppRoutes.start) return;
        Navigator.pushNamed(context, AppRoutes.start);
        break;
    }
  }
}
