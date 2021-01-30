import 'dart:async';
import 'dart:math';

import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';

/// Вспомогательный класс для экрана поиска
class SightSearchScreenHelper {
  static const searchDelay = 200;
  static const debounceDelay = 3000;
  static const maxHistoryLength = 5;

  Stream<List<Sight>> getSightList(String searchString) async* {
    final _searchString = searchString.trim().toLowerCase();

    await Future.delayed(Duration(milliseconds: searchDelay));
    yield [
      ...getFilteredMocks().where((el) =>
          el.name.toLowerCase().contains(_searchString) ||
          el.details.toLowerCase().contains(_searchString)),
    ];
  }

  List<String> getHistory(List<String> history) {
    return history.reversed
        .toList()
        .sublist(0, min(maxHistoryLength, history.length));
  }

  void addToHistory(String item, List<String> history) {
    deleteFromHistory(item, history);
    history.add(item);
    if (history.length > maxHistoryLength) history.removeAt(0);
  }

  void deleteFromHistory(String item, List<String> history) {
    final index = history.lastIndexOf(item);

    if (!index.isNegative) history.removeAt(index);
  }
}
