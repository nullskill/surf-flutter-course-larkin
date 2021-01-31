import 'dart:async';
import 'dart:math';

import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';

/// Вспомогательный класс для экрана поиска
class SightSearchScreenHelper {
  static const searchDelay = 200;
  static const debounceDelay = 3000;
  static const maxHistoryLength = 5;

  final _history = <String>["центр", "площадка"];

  List<String> get history => _history.reversed
      .toList()
      .sublist(0, min(maxHistoryLength, _history.length));

  bool get isHistoryEmpty => _history.isEmpty;

  int requestCounter = 0;

  Stream<List<Sight>> getSightList(String searchString) async* {
    final _searchString = searchString.trim().toLowerCase();

    await Future.delayed(Duration(milliseconds: searchDelay));

    yield [
      ...getFilteredMocks().where((el) =>
          el.name.toLowerCase().contains(_searchString) ||
          el.details.toLowerCase().contains(_searchString)),
    ];

    requestCounter++;
    if (requestCounter % 3 == 0) throw Exception();
  }

  bool isLastInHistory(String item) {
    return history.last == item;
  }

  void addToHistory(String item) {
    deleteFromHistory(item);
    _history.add(item);
    if (_history.length > maxHistoryLength) _history.removeAt(0);
  }

  void deleteFromHistory(String item) {
    final index = _history.indexOf(item);

    if (!index.isNegative) _history.removeAt(index);
  }

  void clearHistory() {
    _history.clear();
  }
}
