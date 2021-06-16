import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:places/data/repository/database/app_database.dart';
import 'package:places/data/repository/database/visited/visited_table.dart';
import 'package:places/domain/visited_sight.dart';

part 'visited_dao.g.dart';

/// DAO для таблицы посещенных мест
@UseDao(tables: [Visited])
class VisitedDao extends DatabaseAccessor<AppDatabase> with _$VisitedDaoMixin {
  VisitedDao(AppDatabase attachedDatabase) : super(attachedDatabase);

  /// Получение всех посещенных мест
  Future<List<VisitedSight>> all() async {
    final entries = await select(visited).get();

    return entries
        .map((e) =>
            VisitedSight.fromJson(jsonDecode(e.sight) as Map<String, dynamic>))
        .toList();
  }

  /// Добавление посещенного места
  Future<int> add(VisitedSight sight) {
    return into(visited).insert(
      VisitedCompanion(
        sightId: Value(sight.id),
        sight: Value(jsonEncode(sight)),
      ),
    );
  }

  /// Удаление посещенного места
  Future<int> remove(int id) {
    return (delete(visited)
          ..where(
            (tbl) => tbl.sightId.equals(id),
          ))
        .go();
  }

  /// Проверяет наличие места в посещенных
  Future<bool> isVisited(int id) async {
    final item = await (select(visited)
          ..where(
            (tbl) => tbl.sightId.equals(id),
          ))
        .getSingle();

    return item != null;
  }
}
