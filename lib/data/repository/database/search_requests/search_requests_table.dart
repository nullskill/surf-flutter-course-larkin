import 'package:moor/moor.dart';

/// Таблица посковых запросов
class SearchRequests extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get request => text()();
}
