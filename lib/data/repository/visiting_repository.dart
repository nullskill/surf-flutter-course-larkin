import 'package:places/data/repository/distance_repository.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/visited_sight.dart';

/// Репозиторий для избранных/посещенных мест
class VisitingRepository {
  final distanceRepo = DistanceRepository();

  List<FavoriteSight> _favoriteSights = [];
  final List<VisitedSight> _visitedSights = [];

  /// Отсортированный список избранных мест
  List<FavoriteSight> get favoriteSights => _favoriteSights;

  /// Список посещенных мест
  List<VisitedSight> get visitedSights => _visitedSights;

  /// Возвращает true, если место в избранном
  bool isFavoriteSight(Sight sight) =>
      _favoriteSights.contains(FavoriteSight.fromSight(sight));

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

  /// Сортирует список моделей [FavoriteSight] по удаленности
  /// и инициализирует им список [_favoriteSights]
  void _sortFavorites() =>
      _favoriteSights = distanceRepo.getSortedSights(_favoriteSights);
}
