import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:places/data/repository/database/app_database.dart';
import 'package:places/data/repository/database/favorites/favorites_table.dart';
import 'package:places/domain/favorite_sight.dart';

part 'favorites_dao.g.dart';

/// DAO для таблицы избранных мест
@UseDao(tables: [Favorites])
class FavoritesDao extends DatabaseAccessor<AppDatabase>
    with _$FavoritesDaoMixin {
  FavoritesDao(AppDatabase attachedDatabase) : super(attachedDatabase);

  /// Получение всех избранных мест
  Future<List<FavoriteSight>> all() async {
    final entries = await (select(favorites)
          ..orderBy(
            [(t) => OrderingTerm.asc(t.orderId)],
          ))
        .get();
    return entries
        .map((e) =>
            FavoriteSight.fromJson(jsonDecode(e.sight) as Map<String, dynamic>))
        .toList();
  }

  /// Добавление избранного места
  Future<int> add(FavoriteSight sight) async {
    final count = countAll();
    final query = selectOnly(favorites)..addColumns([count]);
    final int rowsNumber =
        await query.map((row) => row.read(count)).getSingle();

    return into(favorites).insert(
      FavoritesCompanion(
        sightId: Value(sight.id),
        orderId: Value(rowsNumber + 1),
        sight: Value(jsonEncode(sight.toJson())),
      ),
    );
  }

  /// Удаление избранного места
  Future<int> remove(int id) {
    return (delete(favorites)
          ..where(
            (tbl) => tbl.sightId.equals(id),
          ))
        .go();
  }

  /// Проверяет наличие места в избранном
  Future<bool> isFavorite(int id) async {
    final item = await (select(favorites)
          ..where(
            (tbl) => tbl.sightId.equals(id),
          ))
        .getSingleOrNull();
    return item != null;
  }
}
