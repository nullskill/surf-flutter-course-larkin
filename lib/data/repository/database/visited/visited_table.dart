import 'package:moor/moor.dart';

/// Таблица посещенных мест
class Visited extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sightId => integer().customConstraint('type UNIQUE')();
  TextColumn get sight => text()();
}
