import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/location_interactor.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/repository/location/exceptions.dart';
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
    @required this.locationInteractor,
    @required this.navigator,
  }) : super(baseDependencies);

  final PlaceInteractor placeInteractor;
  final SearchInteractor searchInteractor;
  final LocationInteractor locationInteractor;
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
      searchBarFilterTapAction.stream,
      (_) => _showFiltersScreen(),
    );
    subscribe<void>(
      addSightButtonTapAction.stream,
      (_) => _showAddSightScreen(),
    );
  }

  /// При тапе на поле SearchBar переход на SightSearchScreen
  void _showSearchScreen() {
    doFuture<void>(
      navigator.push(SightSearchScreenRoute()),
      (_) => _reloadSights(),
    );
  }

  /// При тапе кнопки фильтров переход на FiltersScreen
  void _showFiltersScreen() {
    doFuture<bool>(navigator.push(FiltersScreenRoute()), _reloadSights);
  }

  /// При тапе кнопки создания нового места переход на AddSightScreen
  void _showAddSightScreen() {
    doFuture<void>(
      navigator.push(AddSightScreenRoute()),
      (_) => Future<void>.delayed(
        // delay for the server to save new place
        const Duration(milliseconds: 600),
        _reloadSights,
      ),
    );
  }

  /// Получение списка всех мест (с учетом фильтров)
  Future<void> _reloadSights([bool shouldFilter = true]) async {
    if (!shouldFilter) return;

    await sightsState.loading();

    try {
      await locationInteractor.initLocation();
    } on LocationException catch (_) {
      if (!locationInteractor.didShowLocationError) {
        await navigator.pushNamed(AppRoutes.locationError);
        locationInteractor.setShowLocationError();
      }
    }

    try {
      await placeInteractor.loadSights();
      searchInteractor.filterSights();
      await sightsState.content(placeInteractor.sights);
    } on DioError catch (_) {
      await navigator.pushNamed(AppRoutes.error);
    }
  }
}
