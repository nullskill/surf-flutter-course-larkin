import 'package:flutter/material.dart';
import 'package:places/mocks.dart';

/// Вспомогательный миксин для экрана избранных/посещенных интересных мест
mixin VisitingScreenHelper<VisitingScreen extends StatefulWidget>
    on State<VisitingScreen> {
  List _favoriteMocks = favoriteMocks;
  List _visitedMocks = visitedMocks;

  List get getFavoriteMocks => _favoriteMocks;

  List get getVisitedMocks => _visitedMocks;

  bool isDrag = false;

  /// При удалении карточки из списка
  void onRemoveCard(bool hasVisited, var sight) {
    setState(() {
      if (hasVisited)
        _visitedMocks.remove(sight);
      else
        _favoriteMocks.remove(sight);
    });
  }

  /// При начале перетаскивания карточки
  void onDragCardStarted() {
    setState(() {
      isDrag = true;
    });
  }

  /// При окончании перетаскивания карточки
  void onDragCardEnd() {
    setState(() {
      isDrag = false;
    });
  }

  /// Меняет индекс карточки [sight] в списке на [index]
  // ignore: prefer-trailing-comma
  void swapCards(bool hasVisited, var sight, int index) {
    setState(() {
      if (hasVisited) {
        _visitedMocks.remove(sight);
        _visitedMocks.insert(index, sight);
      } else {
        _favoriteMocks.remove(sight);
        _favoriteMocks.insert(index, sight);
      }
    });
  }
}