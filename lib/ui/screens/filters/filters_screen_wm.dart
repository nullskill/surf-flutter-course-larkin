import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/domain/category.dart';
import 'package:relation/relation.dart';

/// WM для FiltersScreen
class FiltersWidgetModel extends WidgetModel {
  FiltersWidgetModel(
    WidgetModelDependencies baseDependencies, {
    @required this.placeInteractor,
    @required this.searchInteractor,
    @required this.navigator,
  }) : super(baseDependencies);

  final PlaceInteractor placeInteractor;
  final SearchInteractor searchInteractor;
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

  @override
  void onLoad() {
    super.onLoad();

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
    subscribe<void>(actionButtonAction.stream, navigator.pop);
  }

  /// Сброс всех настроек
  void _resetAllSettings() {
    searchInteractor.resetCategories();
    resetRangeValues();
    categoriesState.accept(searchInteractor.getCategories);
  }

  /// Изменение признака выбранности категории
  /// и фильтрация интересных мест
  void _toggleCategory(Category category) {
    category.toggle();
    placeInteractor.getSights();
    searchInteractor.filterSights();
    categoriesState.accept(searchInteractor.getCategories);
    filteredNumberState.accept(searchInteractor.filteredNumber);
  }

  /// Установка выбранного диапазона радиуса
  /// и фильтрация интересных мест
  void _setRangeValues(RangeValues newValues) {
    rangeValuesState.accept(newValues);
    searchInteractor.setRadius(newValues);
    placeInteractor.getSights();
    searchInteractor.filterSights();
    filteredNumberState.accept(searchInteractor.filteredNumber);
  }

  /// Сброс выбранного диапазона радиуса
  void resetRangeValues() {
    const rangeValues = RangeValues(
      SearchInteractor.minRadius,
      SearchInteractor.maxRadius,
    );
    rangeValuesState.accept(rangeValues);
    searchInteractor.setRadius(rangeValues);
    filteredNumberState.accept(searchInteractor.filteredNumber);
  }
}