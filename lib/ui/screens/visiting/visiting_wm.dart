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
  final favoriteSightsState = EntityStreamedState<List<FavoriteSight>>();

  /// Флаг первой загрузки списка избранных мест
  final favoritesFirstLoadState = StreamedState<bool>(true);

  /// Список посещенных мест
  final visitedSightsState = EntityStreamedState<List<VisitedSight>>();

  /// Флаг первой загрузки списка посещенных мест
  final visitedFirstLoadState = StreamedState<bool>(true);

  @override
  void onLoad() {
    super.onLoad();

    _loadFavorites();
  }

  @override
  void onBind() {
    super.onBind();

    subscribe<void>(loadVisitedSightsAction.stream, (_) => _loadVisited());
    subscribe<void>(
        placeInteractor.favoriteSightsStream, (_) => _loadFavorites());
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
  void _loadFavorites() {
    if (favoritesFirstLoadState.value) favoriteSightsState.loading();

    // Delay imitation
    final Future<List<FavoriteSight>> future = Future.delayed(
        const Duration(milliseconds: loadDelay),
        () => placeInteractor.favoriteSights);

    doFutureHandleError(future, favoriteSightsState.content);
    favoritesFirstLoadState.accept(false);
  }

  /// Загружает список посещенных мест
  void _loadVisited() {
    if (visitedFirstLoadState.value) visitedSightsState.loading();

    // Delay imitation
    final Future<List<VisitedSight>> future = Future.delayed(
        const Duration(milliseconds: loadDelay),
        () => placeInteractor.visitedSights);

    doFutureHandleError(future, visitedSightsState.content);
    visitedFirstLoadState.accept(false);
  }

  /// Удаляет карточку из списка избранных/посещенных мест
  void removeFromVisiting(Sight sight) {
    if (sight is FavoriteSight) {
      removeFavoriteSightAction(sight);
    } else if (sight is VisitedSight) {
      removeVisitedSightAction(sight);
    }
  }

  /// Удаляет место из избранного
  void _removeFromFavorites(FavoriteSight sight) {
    placeInteractor.removeFromFavorites(sight);
  }

  /// Удаляет место из посещенных
  void _removeFromVisited(VisitedSight sight) {
    placeInteractor.removeFromVisited(sight);
  }
}
