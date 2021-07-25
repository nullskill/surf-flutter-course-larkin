import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/location_interactor.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/data/model/location.dart';
import 'package:places/data/repository/location/exceptions.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/sight_type.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/screens/add_sight/add_sight_route.dart';
import 'package:places/ui/screens/filters/filters_screen_route.dart';
import 'package:places/ui/screens/sight_search/sight_search_route.dart';
import 'package:relation/relation.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// WM для MapScreen
class MapWidgetModel extends WidgetModel {
  MapWidgetModel(
    WidgetModelDependencies baseDependencies, {
    @required this.locationInteractor,
    @required this.settingsInteractor,
    @required this.searchInteractor,
    @required this.placeInteractor,
    @required this.navigator,
  }) : super(baseDependencies);

  final LocationInteractor locationInteractor;
  final SettingsInteractor settingsInteractor;
  final SearchInteractor searchInteractor;
  final PlaceInteractor placeInteractor;
  final NavigatorState navigator;

  /// Контроллер карты
  YandexMapController _mapCtrl;

  /// Список плейсмарков, необходим, т.к.
  /// в YandexMapController.placemarks вегда пуст.
  /// Манипуляции списком плейсмарков на карте
  /// только через API "addPlacemark" и "removePlacemark"
  final _placemarks = <Placemark>[];

  // Actions

  /// При тапе на поле SearchBar
  final searchBarTapAction = Action<void>();

  /// При тапе кнопки фильтров в поле SearchBar
  final searchBarFilterTapAction = Action<void>();

  /// При тапе на кнопку обновления
  final refreshTapAction = Action<void>();

  /// При тапе на кнопку показа геолокации
  final showLocationTapAction = Action<void>();

  /// При создании карты Яндекса
  final initMap = Action<YandexMapController>();

  /// При тапе кнопки создания нового места
  final addSightButtonTapAction = Action<void>();

  /// При добавлении места в посещенные
  final addToVisitedAction = Action<void>();

  /// При отмене выбора места
  final deselectSightAction = Action<void>();

  // StreamedStates

  /// Выбранное место
  final StreamedState<Sight> selectedSightState = StreamedState();

  /// Текущая локация
  final StreamedState<Location> locationState = StreamedState();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await _initLocation();
    await _reloadSights();

    await locationState.accept(locationInteractor.location);
  }

  @override
  void onBind() {
    super.onBind();

    subscribe<YandexMapController>(initMap.stream, _initMap);
    subscribe<void>(searchBarTapAction.stream, (_) => _showSearchScreen());
    subscribe<void>(
      searchBarFilterTapAction.stream,
      (_) => _showFiltersScreen(),
    );
    subscribe<void>(refreshTapAction.stream, (_) => _refreshPlacemarks());
    subscribe<void>(showLocationTapAction.stream, (_) => _showLocationOnMap());
    subscribe<void>(
      addSightButtonTapAction.stream,
      (_) => _showAddSightScreen(),
    );
    subscribe<void>(addToVisitedAction.stream, (_) => _addToVisited());
    subscribe<void>(deselectSightAction.stream, (_) => _deselectSight());
  }

  /// Инициализация координат локации
  Future<void> _initLocation() async {
    if (locationInteractor.location != null) return;

    try {
      await locationInteractor.initLocation();
    } on LocationException catch (_) {
      if (!locationInteractor.didShowLocationError) {
        await navigator.pushNamed(AppRoutes.locationError);
        locationInteractor.setShowLocationError();
      }
    }
  }

  /// Инициализация карты Яндекса
  Future<void> _initMap(YandexMapController controller) async {
    _mapCtrl = controller;

    await _mapCtrl.toggleNightMode(enabled: settingsInteractor.isDarkTheme);
    await _mapCtrl.logoAlignment(
      vertical: VerticalAlignment.top,
      horizontal: HorizontalAlignment.left,
    );

    await _showLocationOnMap();
  }

  /// Показывает и смещается к локации на карте
  Future<void> _showLocationOnMap() async {
    final location = locationInteractor.location;

    if (location == null) return;

    await _mapCtrl.showUserLayer(
      iconName: AppIcons.selfPlacemark,
      arrowName: AppIcons.selfPlacemark,
      accuracyCircleFillColor: accuracyCircleFillColor.withOpacity(0.24),
    );

    await _mapCtrl.move(
      point: Point(latitude: location.lat, longitude: location.lng),
    );

    await locationState.accept(location);
  }

  /// Добавляет место в посещенные
  void _addToVisited() {
    placeInteractor.addToVisited(selectedSightState.value);
  }

  /// Выделяет на карте и показывает превью выбранного места
  void _selectSight(Sight sight) {
    selectedSightState.accept(sight..openHour = DateTime(1970, 1, 1, 9));

    _refreshPlacemarks();

    _mapCtrl.move(point: Point(latitude: sight.lat, longitude: sight.lng));
  }

  /// Снимает выделение выбранного места на карте
  void _deselectSight() {
    selectedSightState.accept(null);

    _refreshPlacemarks();
  }

  /// Обновление плейсмарков
  void _refreshPlacemarks() {
    for (final placemark in _placemarks) {
      _mapCtrl.removePlacemark(placemark);
    }
    _placemarks.clear();

    for (final sight in placeInteractor.sights) {
      String iconName;
      switch (sight.type) {
        case SightType.restaurant:
          iconName = settingsInteractor.isDarkTheme
              ? AppIcons.lightPlacemarkRestaurant
              : AppIcons.darkPlacemarkRestaurant;
          break;
        case SightType.cafe:
          iconName = settingsInteractor.isDarkTheme
              ? AppIcons.lightPlacemarkCafe
              : AppIcons.darkPlacemarkCafe;
          break;
        case SightType.park:
          iconName = settingsInteractor.isDarkTheme
              ? AppIcons.lightPlacemarkPark
              : AppIcons.darkPlacemarkPark;
          break;
        case SightType.hotel:
          iconName = settingsInteractor.isDarkTheme
              ? AppIcons.lightPlacemarkHotel
              : AppIcons.darkPlacemarkHotel;
          break;
        case SightType.museum:
          iconName = settingsInteractor.isDarkTheme
              ? AppIcons.lightPlacemarkMuseum
              : AppIcons.darkPlacemarkMuseum;
          break;
        default:
          iconName = settingsInteractor.isDarkTheme
              ? AppIcons.lightPlacemark
              : AppIcons.darkPlacemark;
      }
      final placemark = Placemark(
        point: Point(latitude: sight.lat, longitude: sight.lng),
        style: PlacemarkStyle(
          scale: 0.7,
          opacity: 1.0,
          iconName: selectedSightState.value == sight
              ? AppIcons.selectedPlacemark
              : iconName,
        ),
        onTap: (_, __) => _selectSight(sight),
      );
      _mapCtrl.addPlacemark(
        placemark,
      );
      _placemarks.add(placemark);
    }
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
    doFuture<void>(
      navigator.push(FiltersScreenRoute()),
      (_) => _reloadSights(),
    );
  }

  /// Получение списка всех мест (с учетом фильтров)
  Future<void> _reloadSights() async {
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
      _refreshPlacemarks();
    } on DioError catch (_) {
      await navigator.pushNamed(AppRoutes.error);
    }
  }

  /// При тапе кнопки создания нового места переход на AddSightScreen
  void _showAddSightScreen() {
    navigator.push(AddSightScreenRoute());
  }
}
