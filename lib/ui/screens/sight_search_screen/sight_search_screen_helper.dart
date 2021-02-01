import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';

/// Вспомогательный миксин для экрана поиска
mixin SightSearchScreenHelper<SightSearchScreen extends StatefulWidget>
    on State<SightSearchScreen> {
  static const searchDelay = 200;
  static const debounceDelay = 3000;
  static const maxHistoryLength = 5;

  final _history = <String>["центр", "площадка"];
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  StreamController<List<Sight>> streamController;
  StreamSubscription<List> streamSub;
  Timer debounce;
  String prevSearchText = "";
  bool isSearching = false;
  bool hasError = false;
  bool hasClearButton = false;

  List<String> get history => _history.reversed
      .toList()
      .sublist(0, min(maxHistoryLength, _history.length));

  bool get isHistoryEmpty => _history.isEmpty;

  int requestCounter = 0;

  @override
  void initState() {
    super.initState();

    streamController = StreamController.broadcast();
    searchController.addListener(searchControllerListener);
  }

  /// Listener изменений [searchController]
  void searchControllerListener() {
    if (prevSearchText != searchController.text) {
      setState(() {
        hasClearButton = searchController.text.isNotEmpty;
      });
      search();
      prevSearchText = searchController.text;
    }
  }

  @override
  void dispose() {
    debounce?.cancel();
    streamSub?.cancel();
    searchController.dispose();
    streamController.close();

    super.dispose();
  }

  /// При окончании редактирования поля поиска
  void onEditingComplete() {
    removeSearchFocus();
    search();
  }

  // Для снятия фокуса с поля поиска
  void removeSearchFocus() {
    searchFocusNode.unfocus();
  }

  /// Осуществляет поиск через подписку на стрим getSightList через заданный
  /// интервал [debounceDelay], отменяя при необходимости текущий. Результат
  /// поиска проваливается в [streamController], откуда поступает в [StreamBuilder]
  void search() async {
    if (debounce?.isActive ?? false) debounce.cancel();

    if (searchController.text == prevSearchText && !isSearching) {
      if (hasError) {
        // После ошибки нужна возможность заново отправить запрос по кнопке,
        // поэтому триггерим обновление стейта для ребилда виджета
        setState(() {});
      } else {
        return;
      }
    }

    if (searchController.text.isEmpty) {
      if (prevSearchText.isNotEmpty) {
        isSearching = false;
        streamSub?.cancel();
        streamController.sink.add(null);
      }
      return;
    }

    isSearching = true;

    debounce = Timer(
      const Duration(
        milliseconds: SightSearchScreenHelper.debounceDelay,
      ),
      () {
        streamSub?.cancel();
        streamSub = getSightList(searchController.text).listen(
          (searchResult) {
            isSearching = false;
            streamController.sink.add(searchResult);
            addToHistory(searchController.text);
          },
          onError: (error) {
            isSearching = false;
            streamController.addError(error);
          },
        );
      },
    );
  }

  /// Генератор для поиска карточек ближайших интересных мест,
  /// содержащих в названии, либо в описании искомую строку
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

  /// Функции для манипулирования историей поиска [_history]
  ///
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
