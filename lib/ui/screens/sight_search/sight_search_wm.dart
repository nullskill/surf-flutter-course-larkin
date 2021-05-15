import 'dart:math';

import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/model/places_filter_dto.dart';
import 'package:places/domain/sight.dart';
import 'package:places/util/consts.dart';
import 'package:relation/relation.dart';
import 'package:rxdart/rxdart.dart';

/// WM для SightSearchScreen
class SightSearchWidgetModel extends WidgetModel {
  SightSearchWidgetModel(
    WidgetModelDependencies baseDependencies, {
    @required this.searchInteractor,
    @required this.navigator,
  }) : super(baseDependencies);

  /// Задержка перед началом поиска
  static const debounceDelay = 2000;

  final SearchInteractor searchInteractor;
  final NavigatorState navigator;

  /// Фокус-нода поля поиска
  final searchFocusNode = FocusNode();

  // Actions

  /// Для снятия фокуса с поля поиска
  final removeSearchFocusAction = Action<void>();

  /// Экшен контроллера поля поиска
  final searchEditingAction = TextEditingAction();

  /// При окончании редактирования поля поиска
  final searchEditingCompleteAction = Action<void>();

  /// При добавлении элемента истории
  final addToHistoryAction = Action<String>();

  /// При удалении элемента истории
  final deleteFromHistoryAction = Action<String>();

  /// При тапе на элементе истории
  final historyTapAction = Action<String>();

  /// При очистке истории
  final clearHistoryAction = Action<BuildContext>();

  // StreamedStates

  /// Последний текст поиска
  final lastSearchedText = StreamedState<String>('');

  /// Флаг состояния поиска
  final isSearchingState = StreamedState<bool>(false);

  /// Флаг необходимости кнопки очистки
  final hasClearButtonState = StreamedState<bool>(false);

  /// Список истории поиска
  final historyState = StreamedState<List<String>>(const []);

  /// Список найденных мест
  final EntityStreamedState<List<Sight>> foundSights =
      EntityStreamedState(EntityState.content(const []));

  // Rx

  /// Стрим на входе поиска
  final _searchSubject = BehaviorSubject<String>();

  /// Стрим на выходе поиска
  Stream<List<Sight>> _foundSightsStream;

  @override
  void onLoad() {
    super.onLoad();

    _initSearchStream();
  }

  @override
  void onBind() {
    super.onBind();

    subscribe<void>(
        removeSearchFocusAction.stream, (_) => _removeSearchFocus());
    subscribe<String>(searchEditingAction.stream, _onSearchTextChange);
    subscribe<void>(
        searchEditingCompleteAction.stream, (_) => _onEditingComplete());
    subscribeHandleError<List<Sight>>(_foundSightsStream, _onSearchResults,
        onError: _onSearchError);
    subscribe<String>(addToHistoryAction.stream, _addToHistory);
    subscribe<String>(deleteFromHistoryAction.stream, _deleteFromHistory);
    subscribe<String>(historyTapAction.stream, _searchByHistoryItem);
    subscribe<BuildContext>(clearHistoryAction.stream, _clearHistory);
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    _searchSubject.close();

    super.dispose();
  }

  /// Инициализация стрима, осуществляющего поиск
  void _initSearchStream() {
    _foundSightsStream = _searchSubject
        .debounce(
      (_) => TimerStream<bool>(
        true,
        const Duration(milliseconds: debounceDelay),
      ),
    )
        .switchMap((text) async* {
      yield await searchInteractor
          .searchPlaces(PlacesFilterDto(nameFilter: text));
    });
  }

  /// Завершение редактирования поля поиска (нажатие кнопки поиска)
  void _onEditingComplete() {
    _removeSearchFocus();

    _toggleSearch(searchEditingAction.value);
  }

  /// Изменение строки поиска
  void _onSearchTextChange(String text) {
    if (text != lastSearchedText.value) {
      _toggleSearch(text);
    }
  }

  /// Начинает/завершает процесс поиска
  void _toggleSearch(String text) {
    isSearchingState.accept(text.isNotEmpty);
    hasClearButtonState.accept(text.isNotEmpty);

    if (text.isNotEmpty) {
      foundSights.loading();
      _searchSubject.add(text);
    }
  }

  /// Успешное завершение поиска
  void _onSearchResults(List<Sight> results) {
    foundSights.content(results);
    lastSearchedText.accept(searchEditingAction.value);
    addToHistoryAction.accept(searchEditingAction.value);
  }

  /// Завершение поиска с ошибкой
  void _onSearchError(Object error) {
    foundSights.error(error);
    lastSearchedText.accept(searchEditingAction.value);
    addToHistoryAction.accept(searchEditingAction.value);
  }

  /// Снимает фокус с поля поиска
  void _removeSearchFocus() {
    searchFocusNode.unfocus();
  }

  /// Добавляет элемент истории
  void _addToHistory(String item) {
    if (item.isNotEmpty) {
      final newHistory = [item, ...historyState.value.where((i) => i != item)];

      historyState.accept(newHistory.sublist(
          0, min(maxSearchHistoryLength, newHistory.length)));
    }
  }

  /// Удаляет элемент истории
  void _deleteFromHistory(String item) {
    historyState.accept([...historyState.value.where((i) => i != item)]);
  }

  /// Очистка истории
  void _clearHistory(BuildContext context) {
    historyState.accept(const []);
    FocusScope.of(context).requestFocus(searchFocusNode);
  }

  /// Начинает поиск выбранного элемента истории
  void _searchByHistoryItem(String item) {
    searchEditingAction.controller.text = item;
    _toggleSearch(item);
  }
}
