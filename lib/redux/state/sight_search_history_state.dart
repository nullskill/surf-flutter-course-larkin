import 'dart:math';

import 'package:places/util/consts.dart';

/// Состояние для истории экрана поиска
abstract class SightSearchHistoryState {
  SightSearchHistoryState([List<String> history])
      : _history = history ?? const [];

  final List<String> _history;

  /// История поиска
  List<String> get history => _history;

  /// История поиска в обратном порядке
  List<String> get reversedHistory => _history.reversed
      .toList()
      .sublist(0, min(maxSearchHistoryLength, _history.length));

  /// Возвращает true, если история поиска пуста
  bool get isHistoryEmpty => _history.isEmpty;

  /// Возвращает true, если элемент последний
  bool isLastInHistory(String item) {
    return _history.last == item;
  }
}

class HistoryInitialState extends SightSearchHistoryState {}

class HistoryDataState extends SightSearchHistoryState {
  HistoryDataState(List<String> history) : super(history);
}
