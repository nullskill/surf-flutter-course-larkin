import 'package:moor/moor.dart';

/// Таблица избранных мест
class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sightId => integer().customConstraint('type UNIQUE')();
  // TODO(me): Make sorting by user order
  IntColumn get orderId => integer().customConstraint('type UNIQUE')();
  TextColumn get sight => text()();
}
