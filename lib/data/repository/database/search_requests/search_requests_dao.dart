import 'package:moor/moor.dart';
import 'package:places/data/repository/database/app_database.dart';
import 'package:places/data/repository/database/search_requests/search_requests_table.dart';

part 'search_requests_dao.g.dart';

/// DAO для таблицы поисковых запросов
@UseDao(tables: [SearchRequests])
class SearchRequestsDao extends DatabaseAccessor<AppDatabase>
    with _$SearchRequestsDaoMixin {
  SearchRequestsDao(AppDatabase attachedDatabase) : super(attachedDatabase);

  /// Получение всех поисковых запросов
  Future<List<SearchRequest>> all() {
    return (select(searchRequests)
          ..orderBy(
            [(t) => OrderingTerm.desc(t.id)],
          ))
        .get();
  }

  /// Добавление поискового запроса
  Future<int> add(String request) async {
    await remove(request);

    return into(searchRequests).insert(
      SearchRequestsCompanion(
        request: Value(request),
      ),
    );
  }

  /// Удаление поискового запроса
  Future<int> remove(String request) {
    return (delete(searchRequests)
          ..where(
            (tbl) => tbl.request.equals(request),
          ))
        .go();
  }

  /// Очистка всех записей
  Future<int> empty() {
    return delete(searchRequests).go();
  }
}
