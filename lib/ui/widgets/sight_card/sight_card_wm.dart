import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/domain/base/visiting_sight.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/visited_sight.dart';
import 'package:provider/provider.dart';
import 'package:relation/relation.dart';

/// WM для SightCard
class SightCardWidgetModel extends WidgetModel {
  SightCardWidgetModel(
    WidgetModelDependencies baseDependencies, {
    @required this.placeInteractor,
    @required this.sight,
  }) : super(baseDependencies);

  final PlaceInteractor placeInteractor;
  final Sight sight;

  // Actions

  /// При добавлении/удалении места в/из избранное
  final toggleFavoriteSightAction = Action<void>();

  /// При удалении места из избранного
  final removeFavoriteSightAction = Action<void>();

  /// Проверяет принадлежность избранному
  final checkIsFavoriteSightAction = Action<void>();

  /// При удалении места из посещенных
  final removeVisitedSightAction = Action<void>();

  // StreamedStates

  /// Стейт интересного места
  final sightState = StreamedState<SightData>();

  /// Возвращает флаг наличия места в избранном
  final isFavoriteSightState = StreamedState<bool>();

  @override
  void onBind() {
    super.onBind();

    sightState.accept(SightData(sight));
    isFavoriteSightState.accept(placeInteractor.isFavoriteSight(sight));

    subscribe<void>(
        toggleFavoriteSightAction.stream, (_) => _toggleFavoriteSight());
    subscribe<void>(
        removeFavoriteSightAction.stream, (_) => _removeFromFavorites());
    subscribe<void>(
        checkIsFavoriteSightAction.stream, (_) => _checkIsFavoriteSight());
    subscribe<void>(
        removeVisitedSightAction.stream, (_) => _removeFromVisited());
  }

  /// Добавляет/удаляет место в/из избранное
  /// и проверяет принадлежность избранному
  void _toggleFavoriteSight() {
    placeInteractor.toggleFavoriteSight(sight);
    _checkIsFavoriteSight();
  }

  /// Удаляет место из избранного
  /// и проверяет принадлежность избранному
  void _removeFromFavorites() {
    placeInteractor.removeFromFavorites(sight as FavoriteSight);
    _checkIsFavoriteSight();
  }

  /// Передает в [isFavoriteSightState] флаг принадлежности избранному
  void _checkIsFavoriteSight() {
    isFavoriteSightState.accept(placeInteractor.isFavoriteSight(sight));
  }

  /// Удаляет место из посещенных
  void _removeFromVisited() {
    placeInteractor.removeFromVisited(sight as VisitedSight);
  }
}

/// Билдер для [SightCardWidgetModel]
SightCardWidgetModel createSightCardWm(BuildContext context, Sight sight) =>
    SightCardWidgetModel(
      context.read<WidgetModelDependencies>(),
      placeInteractor: context.read<PlaceInteractor>(),
      sight: sight,
    );

/// Данные интересного места
class SightData {
  SightData(this.sight);

  final Sight sight;

  bool get isSightCard => sight.runtimeType == Sight;

  bool get isVisitingCard =>
      [FavoriteSight, VisitedSight].contains(sight.runtimeType);

  bool get isFavoriteCard => sight.runtimeType == FavoriteSight;

  DateTime get openHour => (sight as VisitingSight).openHour;

  DateTime get plannedDate => (sight as FavoriteSight).plannedDate;

  DateTime get visitedDate => (sight as VisitedSight).visitedDate;
}
