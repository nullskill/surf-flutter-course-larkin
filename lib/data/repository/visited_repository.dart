import 'package:places/data/repository/database/app_database.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/visited_sight.dart';

/// Репозиторий посещенных мест
class VisitedRepository {
  VisitedRepository(this.db);

  final AppDatabase db;

  /// Получает список всех посещенных мест
  Future<List<VisitedSight>> getVisited() => db.visitedDao.all();

  /// Добавляет в посещенные места
  Future<int> addVisited(Sight sight) =>
      db.visitedDao.add(VisitedSight.fromSight(sight));

  /// Удаляет из посещенных мест
  Future<int> removeVisited(Sight sight) => db.visitedDao.remove(sight.id);
}
