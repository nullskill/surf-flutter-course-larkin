import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/screens/add_sight/add_sight_route.dart';
import 'package:places/ui/screens/filters/filters_screen_route.dart';
import 'package:places/ui/screens/sight_search/sight_search_route.dart';
import 'package:relation/relation.dart';

/// WM для SightListScreen
class SightListWidgetModel extends WidgetModel {
  SightListWidgetModel(
    WidgetModelDependencies baseDependencies, {
    @required this.placeInteractor,
    @required this.searchInteractor,
    @required this.navigator,
  }) : super(baseDependencies);

  final PlaceInteractor placeInteractor;
  final SearchInteractor searchInteractor;
  final NavigatorState navigator;

  // Actions

  /// При тапе на поле SearchBar
  final searchBarTapAction = Action<void>();

  /// При тапе кнопки фильтров в поле SearchBar
  final searchBarFilterTapAction = Action<void>();

  /// При тапе кнопки создания нового места
  final addSightButtonTapAction = Action<void>();

  // StreamedStates

  /// Список найденных мест
  final EntityStreamedState<List<Sight>> sightsState =
      EntityStreamedState(EntityState.content(const []));

  @override
  void onLoad() {
    super.onLoad();

    searchInteractor.initSelectedFilters();

    _reloadSights();
  }

  @override
  void onBind() {
    super.onBind();

    subscribe<void>(searchBarTapAction.stream, (_) => _showSearchScreen());
    subscribe<void>(
        searchBarFilterTapAction.stream, (_) => _showFiltersScreen());
    subscribe<void>(
        addSightButtonTapAction.stream, (_) => _showAddSightScreen());
  }

  /// При тапе на поле SearchBar переход на SightSearchScreen
  void _showSearchScreen() {
    doFuture<void>(
        navigator.push(SightSearchScreenRoute()), (_) => _reloadSights());
  }

  /// При тапе кнопки фильтров переход на FiltersScreen
  void _showFiltersScreen() {
    doFuture<void>(
        navigator.push(FiltersScreenRoute()), (_) => _reloadSights());
  }

  /// При тапе кнопки создания нового места переход на AddSightScreen
  void _showAddSightScreen() {
    doFuture<void>(
        navigator.push(AddSightScreenRoute()), (_) => _reloadSights());
  }

  /// Получение списка всех мест (с учетом фильтров)
  Future<void> _reloadSights() async {
    await sightsState.loading();

    try {
      await placeInteractor.getSights();
      searchInteractor.filterSights();
      await sightsState.content(placeInteractor.sights);
    } on Object catch (_, __) {
      await navigator.pushNamed(AppRoutes.error);
    }
  }
}
