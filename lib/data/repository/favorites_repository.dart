import 'package:places/data/repository/database/app_database.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/sight.dart';

/// Репозиторий избранных мест
class FavoritesRepository {
  FavoritesRepository(this.db);

  final AppDatabase db;

  /// Получает список id всех избранных мест
  Future<List<FavoriteSight>> getFavorites() => db.favoritesDao.all();

  /// Добавляет в избранное
  Future<int> addFavorite(Sight sight) =>
      db.favoritesDao.add(FavoriteSight.fromSight(sight));

  /// Удаляет из избранного
  Future<int> removeFavorite(Sight sight) => db.favoritesDao.remove(sight.id);

  /// Проверяет наличие места в избранном
  Future<bool> isFavorite(Sight sight) => db.favoritesDao.isFavorite(sight.id);
}
