import 'package:places/data/repository/database/app_database.dart';

/// Репозиторий поисковых запросов
class SearchRequestsRepository {
  SearchRequestsRepository(this.db);

  final AppDatabase db;

  /// Получает все запросы
  Future<List<String>> allRequests() async {
    final allRequests = await db.searchRequestsDao.all();

    return allRequests.map((r) => r.request).toList();
  }

  /// Добавляет запрос
  Future<int> addRequest(String request) => db.searchRequestsDao.add(request);

  /// Удаляет запрос
  Future<int> removeRequest(String request) =>
      db.searchRequestsDao.remove(request);

  /// Очищает таблицу
  Future<int> emptyRequests() => db.searchRequestsDao.empty();
}
