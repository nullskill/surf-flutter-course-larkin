import 'dart:async';

import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repository/favorites_repository.dart';
import 'package:places/data/repository/place_repository.dart';
import 'package:places/data/repository/visited_repository.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/visited_sight.dart';

/// Интерактор для работы с интересным местом
class PlaceInteractor {
  PlaceInteractor(
    this._placeRepo,
    this._favoritesRepo,
    this._visitedRepo,
    this._searchInteractor,
  );

  final PlaceRepository _placeRepo;
  final FavoritesRepository _favoritesRepo;
  final VisitedRepository _visitedRepo;
  final SearchInteractor _searchInteractor;

  List<Sight> _sights = [];

  final StreamController<List<FavoriteSight>> _favoritesController =
      StreamController.broadcast();

  final StreamController<List<VisitedSight>> _visitedController =
      StreamController.broadcast();

  Stream<List<FavoriteSight>> get favoritesStream =>
      _favoritesController.stream;

  Stream<List<VisitedSight>> get visitedStream => _visitedController.stream;

  /// Отсортированный список мест
  List<Sight> get sights {
    if (_searchInteractor.filteredNumber > 0) {
      return _searchInteractor.filteredSights;
    }

    return _sights;
  }

  /// Закрывает все, что необходимо закрыть
  void dispose() {
    _favoritesController.close();
    _visitedController.close();
  }

  // Sights

  /// Получение списка всех мест
  Future<void> loadSights() async {
    final List<Place> _places = await _placeRepo.getPlaces();
    _sights = _places.map((p) => Sight.fromPlace(p)).toList();
    _sortSights();
  }

  /// Получение места по [id]
  Future<Sight> getSightDetails(int id) async {
    final Place place = await _placeRepo.getPlaceDetails(id);

    return Sight.fromPlace(place);
  }

  /// Добавление нового места (возвращается с id)
  Future<void> addNewSight(Sight sight) async {
    final Place place = await _placeRepo.addNewPlace(Place.fromSight(sight));
    _sights.add(Sight.fromPlace(place));
    _sortSights();
  }

  // Favorites

  /// Получение списка всех избранных мест
  Future<List<FavoriteSight>> getFavorites() => _favoritesRepo.getFavorites();

  /// Добавление/удаление места в/из избранное
  Future<void> toggleFavorite(Sight sight) async {
    if (await isFavorite(sight)) {
      await removeFromFavorites(sight);
    } else {
      await addToFavorites(sight);
    }
  }

  /// Возвращает true, если место в избранном
  Future<bool> isFavorite(Sight sight) => _favoritesRepo.isFavorite(sight);

  /// Добавление места в список избранного
  Future<void> addToFavorites(Sight sight) async {
    await _favoritesRepo.addFavorite(sight);
    _favoritesController.add(await getFavorites());
  }

  /// Удаление места из избранного
  Future<void> removeFromFavorites(Sight sight) async {
    await _favoritesRepo.removeFavorite(sight);
    _favoritesController.add(await getFavorites());
  }

  // Visited

  /// Получение списка всех посещенных мест
  Future<List<VisitedSight>> getVisited() => _visitedRepo.getVisited();

  /// Добавление места в посещенные
  Future<void> addToVisited(Sight sight) => _visitedRepo.addVisited(sight);

  /// Удаление места из посещенных
  Future<void> removeFromVisited(Sight sight) async {
    await _visitedRepo.removeVisited(sight);
    _visitedController.add(await getVisited());
  }

  // Sorting

  /// Сортирует список моделей [Sight] по удаленности
  /// и инициализирует им список [_sights]
  void _sortSights() {
    _sights = _searchInteractor.getSortedSights(_sights);
    _searchInteractor.sights = _sights;
  }
}
