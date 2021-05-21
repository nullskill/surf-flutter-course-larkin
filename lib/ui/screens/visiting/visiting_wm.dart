import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/visited_sight.dart';
import 'package:relation/relation.dart';

/// WM для VisitingScreen
class VisitingWidgetModel extends WidgetModel {
  VisitingWidgetModel(
    WidgetModelDependencies baseDependencies, {
    @required this.placeInteractor,
  }) : super(baseDependencies);

  /// Задержка при загрузке списков
  static const loadDelay = 500;

  final PlaceInteractor placeInteractor;

  // Actions

  /// При загрузке посещенных мест
  final loadVisitedSightsAction = Action<void>();

  /// При удалении места из избранных/посещенных мест
  final removeFromVisitingAction = Action<Sight>();

  /// При удалении места из избранного
  final removeFavoriteSightAction = Action<FavoriteSight>();

  /// При удалении места из посещенных
  final removeVisitedSightAction = Action<VisitedSight>();

  // StreamedStates

  /// Список избранных мест
  final favoritesState = EntityStreamedState<List<FavoriteSight>>();

  /// Флаг первой загрузки списка избранных мест
  final favoritesFirstLoadState = StreamedState<bool>(true);

  /// Список посещенных мест
  final visitedState = EntityStreamedState<List<VisitedSight>>();

  /// Флаг первой загрузки списка посещенных мест
  final visitedFirstLoadState = StreamedState<bool>(true);

  @override
  void onLoad() {
    super.onLoad();

    _reloadFavorites();
  }

  @override
  void onBind() {
    super.onBind();

    subscribe<void>(loadVisitedSightsAction.stream, (_) => _reloadVisited());
    subscribe<void>(placeInteractor.favoritesStream, (_) => _reloadFavorites());
    subscribe<Sight>(removeFromVisitingAction.stream, removeFromVisiting);
    subscribe<FavoriteSight>(
        removeFavoriteSightAction.stream, _removeFromFavorites);
    subscribe<VisitedSight>(
        removeVisitedSightAction.stream, _removeFromVisited);
  }

  @override
  void dispose() {
    placeInteractor.dispose();

    super.dispose();
  }

  /// Загружает список избранных мест
  void _reloadFavorites() {
    if (favoritesFirstLoadState.value) favoritesState.loading();

    doFutureHandleError(placeInteractor.getFavorites(), favoritesState.content);
    favoritesFirstLoadState.accept(false);
  }

  /// Загружает список посещенных мест
  void _reloadVisited() {
    if (visitedFirstLoadState.value) visitedState.loading();

    doFutureHandleError(placeInteractor.getVisited(), visitedState.content);
    visitedFirstLoadState.accept(false);
  }

  /// Удаляет карточку из списка избранных/посещенных мест
  void removeFromVisiting(Sight sight) {
    if (sight is FavoriteSight) {
      removeFavoriteSightAction.accept(sight);
    } else if (sight is VisitedSight) {
      removeVisitedSightAction.accept(sight);
    }
  }

  /// Удаляет место из избранного
  Future<void> _removeFromFavorites(FavoriteSight sight) async {
    await placeInteractor.removeFromFavorites(sight);
    doFutureHandleError<List<FavoriteSight>>(
        placeInteractor.getFavorites(), favoritesState.content);
  }

  /// Удаляет место из посещенных
  Future<void> _removeFromVisited(VisitedSight sight) async {
    await placeInteractor.removeFromVisited(sight);
    doFutureHandleError<List<VisitedSight>>(
        placeInteractor.getVisited(), visitedState.content);
  }
}
