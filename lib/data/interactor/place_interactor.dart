import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repository/place_repository.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/visited_sight.dart';

/// Интерактор для работы с интересным местом
class PlaceInteractor {
  factory PlaceInteractor() {
    return _interactor;
  }

  PlaceInteractor._internal()
      : _repo = PlaceRepository(),
        _searchInt = SearchInteractor();

  static final PlaceInteractor _interactor = PlaceInteractor._internal();

  final PlaceRepository _repo;
  final SearchInteractor _searchInt;

  List<Sight> _sights = [];
  List<FavoriteSight> _favoriteSights = [];
  final List<VisitedSight> _visitedSights = [];

  /// Отсортированный список мест
  List<Sight> get sights {
    if (_searchInt.filteredNumber > 0) return _searchInt.filteredSights;
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
    if (_searchInt.filteredNumber > 0) return;

    final List<Place> _places = await _repo.getPlaces();

    _sights = _places.map((p) => Sight.fromPlace(p)).toList();
    _sortSights();
  }

  /// Получение места по [id]
  Future<Sight> getSightDetails(int id) async {
    final Place place = await _repo.getPlaceDetails(id);

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
  }

  /// Добавление места в посещенные
  void addToVisited(Sight sight) {
    _visitedSights
        .add(VisitedSight.fromSight(sight: sight, visitedDate: DateTime.now()));
  }

  /// Удаление места из избранного или из посещенных
  /// в зависимости от переданного типа [sight]
  void removeFromFavorites<T extends Sight>(T sight) {
    if (sight is VisitedSight) {
      _visitedSights.remove(sight);
    }
    _favoriteSights.remove(sight);
  }

  /// Сортирует список моделей [Sight] по удаленности
  /// и инициализирует им список [_sights]
  void _sortSights() {
    _sights = _searchInt.getSortedSights(_sights);
    _searchInt.sights = _sights;
  }

  /// Сортирует список моделей [FavoriteSight] по удаленности
  /// и инициализирует им список [_favoriteSights]
  void _sortFavorites() =>
      _favoriteSights = _searchInt.getSortedSights(_favoriteSights);
}
