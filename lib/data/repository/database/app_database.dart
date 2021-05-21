import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:places/data/repository/database/favorites/favorites_dao.dart';
import 'package:places/data/repository/database/favorites/favorites_table.dart';
import 'package:places/data/repository/database/search_requests/search_requests_dao.dart';
import 'package:places/data/repository/database/search_requests/search_requests_table.dart';
import 'package:places/data/repository/database/visited/visited_dao.dart';
import 'package:places/data/repository/database/visited/visited_table.dart';

part 'app_database.g.dart';

@UseMoor(
  tables: [SearchRequests, Favorites, Visited],
  daos: [SearchRequestsDao, FavoritesDao, VisitedDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbPath = await getApplicationDocumentsDirectory();
    final file = File(join(dbPath.path, 'app_database.sql'));
    return VmDatabase(file);
  });
}
