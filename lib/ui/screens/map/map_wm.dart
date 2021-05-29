import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/location_interactor.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/data/location/exceptions.dart';
import 'package:places/data/model/location.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/screens/add_sight/add_sight_route.dart';
import 'package:relation/relation.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// WM для MapScreen
class MapWidgetModel extends WidgetModel {
  MapWidgetModel(
    WidgetModelDependencies baseDependencies, {
    @required this.locationInteractor,
    @required this.settingsInteractor,
    @required this.navigator,
  }) : super(baseDependencies);

  final LocationInteractor locationInteractor;
  final SettingsInteractor settingsInteractor;
  final NavigatorState navigator;

  YandexMapController _map;

  // Actions

  /// При тапе на кнопку
  final getLocationTapAction = Action<void>();

  /// При создании карты Яндекса
  final initMap = Action<YandexMapController>();

  /// При тапе кнопки создания нового места
  final addSightButtonTapAction = Action<void>();

  // StreamedStates

  /// Координаты текущей геопозиции
  final EntityStreamedState<Location> locationState = EntityStreamedState();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await _getLocation();
  }

  @override
  void onBind() {
    super.onBind();

    subscribe<void>(getLocationTapAction.stream, (_) => _getLocation());
    subscribe<YandexMapController>(initMap.stream, _mapInit);
    subscribe<void>(
        addSightButtonTapAction.stream, (_) => _showAddSightScreen());
  }

  /// Получает координаты текущей геопозиции
  Future<void> _getLocation() async {
    try {
      final location = await locationInteractor.getCurrentLocation();
      await locationState.content(location);

      await _map?.showUserLayer(
        iconName: AppIcons.selfPlacemark,
        arrowName: AppIcons.selfPlacemark,
        accuracyCircleFillColor: accuracyCircleFillColor.withOpacity(.24),
      );
    } on LocationException catch (e) {
      doFuture<void>(locationState.error(e), (_) => debugPrint('Error: $e'));
      await navigator.pushNamed(AppRoutes.locationError);
    }
  }

  /// Инициализация карты Яндекса
  Future<void> _mapInit(YandexMapController controller) async {
    _map = controller;

    await _map.toggleNightMode(enabled: settingsInteractor.isDarkTheme);
    await _map.logoAlignment(
      vertical: VerticalAlignment.top,
      horizontal: HorizontalAlignment.left,
    );

    // await _map.showUserLayer(
    //   iconName: AppIcons.selfPlacemark,
    //   arrowName: AppIcons.selfPlacemark,
    //   userArrowOrientation: false,
    //   accuracyCircleFillColor: accuracyCircleFillColor,
    // );

    final lastLocation = await locationInteractor.getLastKnownLocation();
    await _map.move(
      point: Point(
        latitude: lastLocation.lat,
        longitude: lastLocation.lng,
      ),
    );
  }

  /// При тапе кнопки создания нового места переход на AddSightScreen
  void _showAddSightScreen() {
    navigator.push(AddSightScreenRoute());
  }
}
