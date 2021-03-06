import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
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
    @required this.isPreview,
    this.showRoute,
  }) : super(baseDependencies);

  final PlaceInteractor placeInteractor;
  final Sight sight;
  final bool isPreview;
  final void Function() showRoute;

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
  final isFavoriteSightState = StreamedState<bool>(false);

  @override
  void onLoad() {
    super.onLoad();

    sightState.accept(SightData(sight, isPreview: isPreview));
    doFuture<bool>(
      placeInteractor.isFavorite(sight),
      isFavoriteSightState.accept,
    );
  }

  @override
  void onBind() {
    super.onBind();

    subscribe<void>(
      toggleFavoriteSightAction.stream,
      (_) => _toggleFavoriteSight(),
    );
    subscribe<void>(
      removeFavoriteSightAction.stream,
      (_) => _removeFromFavorites(),
    );
    subscribe<void>(
      checkIsFavoriteSightAction.stream,
      (_) => _checkIsFavoriteSight(),
    );
    subscribe<void>(
      removeVisitedSightAction.stream,
      (_) => _removeFromVisited(),
    );
  }

  /// Добавляет/удаляет место в/из избранное
  /// и проверяет принадлежность избранному
  Future<void> _toggleFavoriteSight() async {
    await placeInteractor.toggleFavorite(sight);
    await _checkIsFavoriteSight();
  }

  /// Удаляет место из избранного
  /// и проверяет принадлежность избранному
  Future<void> _removeFromFavorites() async {
    await placeInteractor.removeFromFavorites(sight);
    await _checkIsFavoriteSight();
  }

  /// Передает в [isFavoriteSightState] флаг принадлежности избранному
  Future<void> _checkIsFavoriteSight() async {
    final isFavorite = await placeInteractor.isFavorite(sight);
    await isFavoriteSightState.accept(isFavorite);
  }

  /// Удаляет место из посещенных
  void _removeFromVisited() {
    placeInteractor.removeFromVisited(sight as VisitedSight);
  }
}

/// Билдер для [SightCardWidgetModel]
SightCardWidgetModel createSightCardWm(
  BuildContext context,
  Sight sight, {
  @required bool isPreview,
  void Function() showRoute,
}) =>
    SightCardWidgetModel(
      context.read<WidgetModelDependencies>(),
      placeInteractor: context.read<PlaceInteractor>(),
      sight: sight,
      isPreview: isPreview,
      showRoute: showRoute,
    );

/// Данные интересного места
class SightData {
  SightData(this.sight, {@required this.isPreview, this.showRoute});

  final Sight sight;
  final bool isPreview;
  final void Function() showRoute;

  bool get isSightCard => sight.runtimeType == Sight;

  bool get isVisitingCard =>
      [FavoriteSight, VisitedSight].contains(sight.runtimeType);

  bool get isFavoriteCard => sight.runtimeType == FavoriteSight;

  DateTime get openHour => sight.openHour;

  DateTime get plannedDate => (sight as FavoriteSight).plannedDate;

  DateTime get visitedDate => (sight as VisitedSight).visitedDate;
}
