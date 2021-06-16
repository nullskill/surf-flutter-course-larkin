import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/location_interactor.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/location.dart';
import 'package:places/domain/sight.dart';
import 'package:provider/provider.dart';
import 'package:relation/relation.dart';

/// WM для SightDetails
class SightDetailsWidgetModel extends WidgetModel {
  SightDetailsWidgetModel(
    WidgetModelDependencies baseDependencies, {
    @required this.locationInteractor,
    @required this.placeInteractor,
    @required this.sight,
  }) : super(baseDependencies);

  final LocationInteractor locationInteractor;
  final PlaceInteractor placeInteractor;
  final Sight sight;

  // Actions

  /// При добавлении/удалении места в/из избранное
  final toggleFavoriteSightAction = Action<void>();

  /// Проверяет принадлежность избранному
  final checkIsFavoriteSightAction = Action<void>();

  /// При добавлении места в посещенные
  final addToVisitedAction = Action<void>();

  // StreamedStates

  /// Стейт детальных данных интересного места
  final sightDetailsState = EntityStreamedState<Sight>();

  /// Возвращает флаг наличия места в избранном
  final isFavoriteSightState = StreamedState<bool>();

  // StreamedStates

  /// Текущая локация
  final StreamedState<Location> locationState = StreamedState();

  @override
  void onLoad() {
    super.onLoad();

    _loadSightDetails();
    _checkIsFavoriteSight();

    locationState.accept(locationInteractor.location);
  }

  @override
  void onBind() {
    super.onBind();

    subscribe<void>(
      toggleFavoriteSightAction.stream,
      (_) => _toggleFavoriteSight(),
    );
    subscribe<void>(
      checkIsFavoriteSightAction.stream,
      (_) => _checkIsFavoriteSight(),
    );
    subscribe<void>(addToVisitedAction.stream, (_) => _addToVisited());
  }

  /// Загружает актуальные детальные данные
  void _loadSightDetails() {
    sightDetailsState.loading();

    doFutureHandleError(
      placeInteractor.getSightDetails(sight.id),
      sightDetailsState.content,
    );
  }

  /// Добавляет/удаляет место в/из избранное
  /// и проверяет принадлежность избранному
  Future<void> _toggleFavoriteSight() async {
    await placeInteractor.toggleFavorite(sight);
    await _checkIsFavoriteSight();
  }

  /// Передает в [isFavoriteSightState] флаг принадлежности избранному
  Future<void> _checkIsFavoriteSight() async {
    await isFavoriteSightState.accept(await placeInteractor.isFavorite(sight));
  }

  /// Добавляет место в посещенные
  void _addToVisited() {
    placeInteractor.addToVisited(sight);
  }
}

/// Билдер для [SightDetailsWidgetModel]
SightDetailsWidgetModel createSightDetailsWm(
  BuildContext context,
  Sight sight,
) =>
    SightDetailsWidgetModel(
      context.read<WidgetModelDependencies>(),
      locationInteractor: context.read<LocationInteractor>(),
      placeInteractor: context.read<PlaceInteractor>(),
      sight: sight,
    );
