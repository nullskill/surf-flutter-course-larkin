import 'package:flutter/material.dart';
import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screens/add_sight/add_sight_screen.dart';
import 'package:places/ui/screens/filters/filters_screen.dart';
import 'package:places/ui/screens/sight_search/sight_search_screen.dart';

/// Миксин для логики экрана списка карточек интересных мест
mixin SightListScreenLogic<SightListScreen extends StatefulWidget>
    on State<SightListScreen> {
  final controller = ScrollController();
  List<Sight> sights = mocks;
  bool isEmpty = false;

  // expanded height = 196 + status bar height
  double get maxHeight => 196 + MediaQuery.of(context).padding.top;

  // global constant kToolbarHeight from material + status bar height
  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;

  /// Проверяет смещение между maxHeight и minHeight
  /// и создает microtask для анимации подскроливания
  /// после завершения билда
  void snapAppBar() {
    final scrollDistance = maxHeight - minHeight;

    if (controller.offset > 0 && controller.offset < scrollDistance) {
      final double snapOffset =
          controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(
        () => controller.animateTo(
          snapOffset,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  /// При тапе на поле SearchBar переход на SightSearchScreen
  void onTapSearchBar() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SightSearchScreen(),
      ),
    );
  }

  /// При нажатии кнопки фильтров в поле SearchBar переход на FiltersScreen
  void onFilterSearchBar() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FiltersScreen(),
      ),
    );
    setState(() {
      sights = getFilteredMocks();
    });
  }

  /// При нажатии FAB кнопки "Новое место" переход на AddSightScreen
  void onPressedFab() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSightScreen(),
      ),
    );
    setState(() {});
  }
}
