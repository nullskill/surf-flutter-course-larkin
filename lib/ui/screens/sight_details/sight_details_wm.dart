import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/domain/sight.dart';
import 'package:provider/provider.dart';
import 'package:relation/relation.dart';

/// WM для SightDetails
class SightDetailsWidgetModel extends WidgetModel {
  SightDetailsWidgetModel(
    WidgetModelDependencies baseDependencies, {
    @required this.placeInteractor,
    @required this.sight,
  }) : super(baseDependencies);

  final PlaceInteractor placeInteractor;
  final Sight sight;

  // Actions

  /// При добавлении/удалении места в/из избранное
  final toggleFavoriteSightAction = Action<void>();

  /// Проверяет принадлежность избранному
  final checkIsFavoriteSightAction = Action<void>();

  // StreamedStates

  /// Стейт детальных данных интересного места
  final sightDetailsState = EntityStreamedState<Sight>();

  /// Возвращает флаг наличия места в избранном
  final isFavoriteSightState = StreamedState<bool>();

  @override
  void onLoad() {
    super.onLoad();

    _loadSightDetails();
    _checkIsFavoriteSight();
  }

  @override
  void onBind() {
    super.onBind();

    subscribe<void>(
        toggleFavoriteSightAction.stream, (_) => _toggleFavoriteSight());
    subscribe<void>(
        checkIsFavoriteSightAction.stream, (_) => _checkIsFavoriteSight());
  }

  /// Загружает актуальные детальные данные
  void _loadSightDetails() {
    sightDetailsState.loading();

    doFutureHandleError(
        placeInteractor.getSightDetails(sight.id), sightDetailsState.content);
  }

  /// Добавляет/удаляет место в/из избранное
  /// и проверяет принадлежность избранному
  void _toggleFavoriteSight() {
    placeInteractor.toggleFavoriteSight(sight);
    _checkIsFavoriteSight();
  }

  /// Передает в [isFavoriteSightState] флаг принадлежности избранному
  void _checkIsFavoriteSight() {
    isFavoriteSightState.accept(placeInteractor.isFavoriteSight(sight));
  }
}

/// Билдер для [SightDetailsWidgetModel]
SightDetailsWidgetModel createSightDetailsWm(
        BuildContext context, Sight sight) =>
    SightDetailsWidgetModel(
      context.read<WidgetModelDependencies>(),
      placeInteractor: context.read<PlaceInteractor>(),
      sight: sight,
    );
