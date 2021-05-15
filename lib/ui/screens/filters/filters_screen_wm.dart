import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/filters_interactor.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/domain/category.dart';
import 'package:places/domain/sight_filter.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:relation/relation.dart';
import 'package:rxdart/rxdart.dart';

/// WM для FiltersScreen
class FiltersWidgetModel extends WidgetModel {
  FiltersWidgetModel(
    WidgetModelDependencies baseDependencies, {
    @required this.placeInteractor,
    @required this.searchInteractor,
    @required this.filtersInteractor,
    @required this.navigator,
  }) : super(baseDependencies);

  /// Задержка перед началом изменения диапазона
  static const debounceDelay = 500;

  final PlaceInteractor placeInteractor;
  final SearchInteractor searchInteractor;
  final FiltersInteractor filtersInteractor;
  final NavigatorState navigator;

  // Actions

  /// При тапе на категории
  final toggleCategoryAction = Action<Category>();

  /// При тапе на кнопке Очистить
  final resetAllSettingsAction = Action<void>();

  /// При изменении диапазона расстояния
  final setRangeValuesAction = Action<RangeValues>();

  /// При тапе кнопки Показать
  final actionButtonAction = Action<void>();

  // StreamedStates

  /// Стейт списка категорий
  final categoriesState = StreamedState<List<Category>>();

  /// Выбранный диапазон расстояния
  final rangeValuesState = StreamedState<RangeValues>();

  /// Количество отфильтрованных мест
  final filteredNumberState = StreamedState<int>();

  // Rx

  /// Стрим на входе диапазона радиуса
  final _rangeValuesSubject = BehaviorSubject<RangeValues>();

  /// Стрим на выходе диапазона радиуса
  Stream<RangeValues> _rangeValuesStream;

  @override
  void onLoad() {
    super.onLoad();

    _initRangeValuesStream();

    final rangeValues = RangeValues(
      searchInteractor.selectedMinRadius,
      searchInteractor.selectedMaxRadius,
    );

    categoriesState.accept(searchInteractor.getCategories);
    rangeValuesState.accept(rangeValues);
    filteredNumberState.accept(searchInteractor.filteredNumber);
  }

  @override
  void onBind() {
    super.onBind();

    subscribe<Category>(toggleCategoryAction.stream, _toggleCategory);
    subscribe<void>(resetAllSettingsAction.stream, (_) => _resetAllSettings());
    subscribe<RangeValues>(setRangeValuesAction.stream, _setRangeValues);
    subscribe<RangeValues>(_rangeValuesStream, (_) => _filterSights());
    subscribe<void>(actionButtonAction.stream, navigator.pop);
  }

  @override
  void dispose() {
    _rangeValuesSubject.close();
    _saveFilters();

    super.dispose();
  }

  /// Инициализация стрима для выбранного диапазона
  void _initRangeValuesStream() {
    _rangeValuesStream = _rangeValuesSubject.debounce(
      (newValues) {
        return TimerStream<bool>(
          true,
          const Duration(milliseconds: debounceDelay),
        );
      },
    ).switchMap((newValues) async* {
      yield newValues;
    });
  }

  /// Сброс всех настроек
  void _resetAllSettings() {
    searchInteractor.resetCategories();
    categoriesState.accept(searchInteractor.getCategories);
    _resetRangeValues();
  }

  /// Изменение признака выбранности категории
  void _toggleCategory(Category category) {
    category.toggle();
    categoriesState.accept(searchInteractor.getCategories);

    _filterSights();
  }

  /// Установка выбранного диапазона радиуса
  void _setRangeValues(RangeValues newValues) {
    rangeValuesState.accept(newValues);
    searchInteractor.setRadius(newValues);
    _rangeValuesSubject.add(newValues);
  }

  /// Фильтрация интересных мест
  Future<void> _filterSights() async {
    try {
      await placeInteractor.getSights();
      searchInteractor.filterSights();
      await filteredNumberState.accept(searchInteractor.filteredNumber);
    } on Object catch (_, __) {
      await navigator.pushNamed(AppRoutes.error);
    }
  }

  /// Сброс выбранного диапазона радиуса
  void _resetRangeValues() {
    const rangeValues = RangeValues(
      SearchInteractor.minRadius,
      SearchInteractor.maxRadius,
    );
    rangeValuesState.accept(rangeValues);
    searchInteractor.setRadius(rangeValues);
    filteredNumberState.accept(searchInteractor.filteredNumber);
  }

  /// Сохранение фильтров в storage
  void _saveFilters() {
    final SightFilter filters = SightFilter(
      minRadius: rangeValuesState.value.start,
      maxRadius: rangeValuesState.value.end,
      types: categoriesState.value
          .where((e) => e.selected)
          .map((e) => e.type)
          .toList(),
    );
    filtersInteractor.saveFilters(filters);
  }
}
