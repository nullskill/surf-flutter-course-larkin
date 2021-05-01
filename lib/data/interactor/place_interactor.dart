import 'dart:async';

import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repository/place_repository.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/visited_sight.dart';

/// Интерактор для работы с интересным местом
class PlaceInteractor {
  PlaceInteractor(this._repo, this._searchInteractor);

  final PlaceRepository _repo;
  final SearchInteractor _searchInteractor;

  List<Sight> _sights = [];
  List<FavoriteSight> _favoriteSights = [];
  final List<VisitedSight> _visitedSights = [];

  final StreamController<List<FavoriteSight>> _favoriteSightsController =
      StreamController.broadcast();

  Stream<List<FavoriteSight>> get favoriteSightsStream =>
      _favoriteSightsController.stream;

  /// Отсортированный список мест
  List<Sight> get sights {
    if (_searchInteractor.filteredNumber > 0) {
      return _searchInteractor.filteredSights;
    }
    return _sights;
  }

  /// Отсортированный список избранных мест
  List<FavoriteSight> get favoriteSights => _favoriteSights;

  /// Список посещенных мест
  List<VisitedSight> get visitedSights => _visitedSights;

  /// Возвращает true, если место в избранном
  bool isFavoriteSight(Sight sight) =>
      _favoriteSights.contains(FavoriteSight.fromSight(sight));

  /// Получение списка всех мест
  Future<void> getSights() async {
    if (_searchInteractor.filteredNumber > 0) return;

    final List<Place> _places = await _repo.getPlaces();
    _sights = _places.map((p) => Sight.fromPlace(p)).toList();
    _sortSights();
  }

  /// Получение места по [id]
  Future<Sight> getSightDetails(int id) async {
    Place place;

    place = await _repo.getPlaceDetails(id);

    return Sight.fromPlace(place);
  }

  /// Добавление нового места (возвращается с id)
  Future<void> addNewSight(Sight sight) async {
    final Place place = await _repo.addNewPlace(Place.fromSight(sight));
    _sights.add(Sight.fromPlace(place));
    _sortSights();
  }

  /// Добавление/удаление места в/из избранное
  void toggleFavoriteSight(Sight sight) {
    final FavoriteSight favoriteSight = FavoriteSight.fromSight(sight);
    if (_favoriteSights.contains(favoriteSight)) {
      removeFromFavorites(favoriteSight);
    } else {
      addToFavorites(favoriteSight);
    }
  }

  /// Добавление [favoriteSight] в список избранного
  void addToFavorites(FavoriteSight favoriteSight) {
    _favoriteSights.add(favoriteSight);
    _sortFavorites();
    _favoriteSightsController.add(_favoriteSights);
  }

  /// Добавление места в посещенные
  void addToVisited(Sight sight) {
    _visitedSights
        .add(VisitedSight.fromSight(sight: sight, visitedDate: DateTime.now()));
  }

  /// Удаление места из избранного
  void removeFromFavorites(FavoriteSight sight) {
    _favoriteSights.remove(sight);
    _favoriteSightsController.add(_favoriteSights);
  }

  /// Удаление места из посещенных
  void removeFromVisited(VisitedSight sight) {
    _visitedSights.remove(sight);
  }

  /// Закрывает все, что необходимо закрыть
  void dispose() {
    _favoriteSightsController.close();
  }

  /// Сортирует список моделей [Sight] по удаленности
  /// и инициализирует им список [_sights]
  void _sortSights() {
    _sights = _searchInteractor.getSortedSights(_sights);
    _searchInteractor.sights = _sights;
  }

  /// Сортирует список моделей [FavoriteSight] по удаленности
  /// и инициализирует им список [_favoriteSights]
  void _sortFavorites() =>
      _favoriteSights = _searchInteractor.getSortedSights(_favoriteSights);
}
