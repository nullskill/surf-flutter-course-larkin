import 'dart:math';

import 'package:flutter/material.dart';
import 'package:places/data/interactor/filters_interactor.dart';
import 'package:places/data/interactor/location_interactor.dart';
import 'package:places/data/model/location.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/places_filter_dto.dart';
import 'package:places/data/repository/search_repository.dart';
import 'package:places/data/repository/search_requests_repository.dart';
import 'package:places/domain/categories.dart';
import 'package:places/domain/category.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/sight_type.dart';
import 'package:places/util/consts.dart';

/// Интерактор поиска и фильтрации интересных мест
class SearchInteractor {
  SearchInteractor(
    this._searchRepo,
    this._searchRequestsRepo,
    this._filtersInteractor,
    this._locationInteractor,
  );

  /// Минимальный и максимальный радиус по умолчанию (в метрах)
  static const double minRadius = 100.0, maxRadius = 5000.0;

  /// Выбранные минимальный и максимальный радиус
  double selectedMinRadius = minRadius, selectedMaxRadius = maxRadius;

  final SearchRepository _searchRepo;
  final SearchRequestsRepository _searchRequestsRepo;
  final FiltersInteractor _filtersInteractor;
  final LocationInteractor _locationInteractor;
  final List<Category> _categories = <Category>[...categories];

  List<Sight> _sights = [];
  List<Sight> _filteredSights = [];
  List<Sight> _foundSights = [];

  /// Минимальная дистанция
  double get minDistance => selectedMinRadius / kilometer;

  /// Максимальная дистанция
  double get maxDistance => selectedMaxRadius / kilometer;

  /// Дефолтная локация (временно)
  Location get location => _locationInteractor.location;

  /// Категории мест
  List<Category> get getCategories => _categories;

  /// Отфильтрованные интересные места
  List<Sight> get filteredSights => _filteredSights;

  /// Кол-во найденных интересных мест
  int get filteredNumber => _filteredSights.length;

  /// Найденные интересные места
  List<Sight> get foundSights => _foundSights;

  /// Выбранные типы категорий
  List<SightType> get selectedTypes =>
      _categories.where((c) => c.selected).map((e) => e.type).toList();

  /// Инициализирует полный список интересных мест
  // ignore: avoid_setters_without_getters
  set sights(List<Sight> sights) => _sights = sights;

  /// Инициализация выбранных фильтров
  Future<void> initSelectedFilters() async {
    final filters = _filtersInteractor.filters;

    if (filters != null && filters.types != null) {
      selectedMinRadius = filters.minRadius;
      selectedMaxRadius = filters.maxRadius;

      for (final category in _categories) {
        category.selected = false;
        for (final type in filters.types) {
          if (category.type == type) {
            category.selected = true;
          }
        }
      }
    }
  }

  /// Сброс выбранных категорий
  void resetCategories() {
    for (final category in _categories) {
      category.reset();
    }
    _filteredSights = [];
  }

  /// Установка выбранных значений радиуса
  void setRadius(RangeValues rangeValues) {
    selectedMinRadius = rangeValues.start;
    selectedMaxRadius = rangeValues.end;
  }

  /// Получение списка найденных/отфильтрованных мест в репо
  Future<List<Sight>> searchPlaces(PlacesFilterDto filterDto) async {
    final List<Place> _places = await _searchRepo.getFilteredPlaces(filterDto);
    _foundSights = _places.map((p) => Sight.fromPlace(p)).toList();
    _foundSights = getSortedSights(_foundSights);

    return _foundSights;
  }

  /// Сортирует список моделей [Sight] по удаленности,
  /// фильтрует по выбранным типам категорий
  /// и инициализирует им список [_filteredSights]
  void filterSights() {
    _filteredSights = getSortedSights(_sights);
    _filteredSights =
        _filteredSights.where((el) => selectedTypes.contains(el.type)).toList();
  }

  /// Сортирует модели [Sight] по удаленности и возвращает список [Sight]
  List<T> getSortedSights<T extends Sight>(List<T> sights) {
    // Если локацию определить не удалось, то сортируем по имени
    if (location == null) {
      return sights..sort((a, b) => a.name.compareTo(b.name));
    }

    // Если локация определена, то сортируем по удаленности
    return sights.map(_setSightDistance).where(_isSightNear).toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
  }

  /// Вычисляет дистанцию до координат места [sight]
  /// от локации [location] и устанавливает в свойство [Sight.distance]
  T _setSightDistance<T extends Sight>(T sight) {
    const double ky = 40000 / 360;
    final double kx = cos(pi * location.lat / 180.0) * ky;
    final double dx = (location.lng - sight.lng).abs() * kx;
    final double dy = (location.lat - sight.lat).abs() * ky;
    final double d = sqrt(dx * dx + dy * dy);

    sight.distance = d;

    return sight;
  }

  /// Проверяет вхождение дистанции до интересного места [sight]
  /// в интервале радиуса от [minDistance] до [maxDistance]
  bool _isSightNear(Sight sight) =>
      sight.distance >= minDistance && sight.distance <= maxDistance;

  // History

  /// Получает всю историю и возвращает [maxSearchHistoryLength] элементов
  Future<List<String>> getHistory() async {
    final allRequests = await _searchRequestsRepo.allRequests();

    return allRequests.sublist(
      0,
      min(maxSearchHistoryLength, allRequests.length),
    );
  }

  /// Добавляет элемент истории
  Future<int> addToHistory(String item) {
    return _searchRequestsRepo.addRequest(item);
  }

  /// Удаляет элемент истории
  Future<int> deleteFromHistory(String item) {
    return _searchRequestsRepo.removeRequest(item);
  }

  /// Очистка истории
  Future<int> clearHistory() {
    return _searchRequestsRepo.emptyRequests();
  }
}
