// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class SearchRequest extends DataClass implements Insertable<SearchRequest> {
  final int id;
  final String request;
  SearchRequest({@required this.id, @required this.request});
  factory SearchRequest.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return SearchRequest(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      request: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}request']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || request != null) {
      map['request'] = Variable<String>(request);
    }
    return map;
  }

  SearchRequestsCompanion toCompanion(bool nullToAbsent) {
    return SearchRequestsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      request: request == null && nullToAbsent
          ? const Value.absent()
          : Value(request),
    );
  }

  factory SearchRequest.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SearchRequest(
      id: serializer.fromJson<int>(json['id']),
      request: serializer.fromJson<String>(json['request']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'request': serializer.toJson<String>(request),
    };
  }

  SearchRequest copyWith({int id, String request}) => SearchRequest(
        id: id ?? this.id,
        request: request ?? this.request,
      );
  @override
  String toString() {
    return (StringBuffer('SearchRequest(')
          ..write('id: $id, ')
          ..write('request: $request')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, request.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchRequest &&
          other.id == this.id &&
          other.request == this.request);
}

class SearchRequestsCompanion extends UpdateCompanion<SearchRequest> {
  final Value<int> id;
  final Value<String> request;
  const SearchRequestsCompanion({
    this.id = const Value.absent(),
    this.request = const Value.absent(),
  });
  SearchRequestsCompanion.insert({
    this.id = const Value.absent(),
    @required String request,
  }) : request = Value(request);
  static Insertable<SearchRequest> custom({
    Expression<int> id,
    Expression<String> request,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (request != null) 'request': request,
    });
  }

  SearchRequestsCompanion copyWith({Value<int> id, Value<String> request}) {
    return SearchRequestsCompanion(
      id: id ?? this.id,
      request: request ?? this.request,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (request.present) {
      map['request'] = Variable<String>(request.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchRequestsCompanion(')
          ..write('id: $id, ')
          ..write('request: $request')
          ..write(')'))
        .toString();
  }
}

class $SearchRequestsTable extends SearchRequests
    with TableInfo<$SearchRequestsTable, SearchRequest> {
  final GeneratedDatabase _db;
  final String _alias;
  $SearchRequestsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _requestMeta = const VerificationMeta('request');
  GeneratedTextColumn _request;
  @override
  GeneratedTextColumn get request => _request ??= _constructRequest();
  GeneratedTextColumn _constructRequest() {
    return GeneratedTextColumn(
      'request',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, request];
  @override
  $SearchRequestsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'search_requests';
  @override
  final String actualTableName = 'search_requests';
  @override
  VerificationContext validateIntegrity(Insertable<SearchRequest> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('request')) {
      context.handle(_requestMeta,
          request.isAcceptableOrUnknown(data['request'], _requestMeta));
    } else if (isInserting) {
      context.missing(_requestMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchRequest map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SearchRequest.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SearchRequestsTable createAlias(String alias) {
    return $SearchRequestsTable(_db, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final int id;
  final int sightId;
  final int orderId;
  final String sight;
  Favorite(
      {@required this.id,
      @required this.sightId,
      @required this.orderId,
      @required this.sight});
  factory Favorite.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Favorite(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      sightId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sight_id']),
      orderId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}order_id']),
      sight: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sight']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || sightId != null) {
      map['sight_id'] = Variable<int>(sightId);
    }
    if (!nullToAbsent || orderId != null) {
      map['order_id'] = Variable<int>(orderId);
    }
    if (!nullToAbsent || sight != null) {
      map['sight'] = Variable<String>(sight);
    }
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      sightId: sightId == null && nullToAbsent
          ? const Value.absent()
          : Value(sightId),
      orderId: orderId == null && nullToAbsent
          ? const Value.absent()
          : Value(orderId),
      sight:
          sight == null && nullToAbsent ? const Value.absent() : Value(sight),
    );
  }

  factory Favorite.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Favorite(
      id: serializer.fromJson<int>(json['id']),
      sightId: serializer.fromJson<int>(json['sightId']),
      orderId: serializer.fromJson<int>(json['orderId']),
      sight: serializer.fromJson<String>(json['sight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sightId': serializer.toJson<int>(sightId),
      'orderId': serializer.toJson<int>(orderId),
      'sight': serializer.toJson<String>(sight),
    };
  }

  Favorite copyWith({int id, int sightId, int orderId, String sight}) =>
      Favorite(
        id: id ?? this.id,
        sightId: sightId ?? this.sightId,
        orderId: orderId ?? this.orderId,
        sight: sight ?? this.sight,
      );
  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('id: $id, ')
          ..write('sightId: $sightId, ')
          ..write('orderId: $orderId, ')
          ..write('sight: $sight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(sightId.hashCode, $mrjc(orderId.hashCode, sight.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.id == this.id &&
          other.sightId == this.sightId &&
          other.orderId == this.orderId &&
          other.sight == this.sight);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<int> id;
  final Value<int> sightId;
  final Value<int> orderId;
  final Value<String> sight;
  const FavoritesCompanion({
    this.id = const Value.absent(),
    this.sightId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.sight = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.id = const Value.absent(),
    @required int sightId,
    @required int orderId,
    @required String sight,
  })  : sightId = Value(sightId),
        orderId = Value(orderId),
        sight = Value(sight);
  static Insertable<Favorite> custom({
    Expression<int> id,
    Expression<int> sightId,
    Expression<int> orderId,
    Expression<String> sight,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sightId != null) 'sight_id': sightId,
      if (orderId != null) 'order_id': orderId,
      if (sight != null) 'sight': sight,
    });
  }

  FavoritesCompanion copyWith(
      {Value<int> id,
      Value<int> sightId,
      Value<int> orderId,
      Value<String> sight}) {
    return FavoritesCompanion(
      id: id ?? this.id,
      sightId: sightId ?? this.sightId,
      orderId: orderId ?? this.orderId,
      sight: sight ?? this.sight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sightId.present) {
      map['sight_id'] = Variable<int>(sightId.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (sight.present) {
      map['sight'] = Variable<String>(sight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('id: $id, ')
          ..write('sightId: $sightId, ')
          ..write('orderId: $orderId, ')
          ..write('sight: $sight')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  final GeneratedDatabase _db;
  final String _alias;
  $FavoritesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _sightIdMeta = const VerificationMeta('sightId');
  GeneratedIntColumn _sightId;
  @override
  GeneratedIntColumn get sightId => _sightId ??= _constructSightId();
  GeneratedIntColumn _constructSightId() {
    return GeneratedIntColumn('sight_id', $tableName, false,
        $customConstraints: 'type UNIQUE');
  }

  final VerificationMeta _orderIdMeta = const VerificationMeta('orderId');
  GeneratedIntColumn _orderId;
  @override
  GeneratedIntColumn get orderId => _orderId ??= _constructOrderId();
  GeneratedIntColumn _constructOrderId() {
    return GeneratedIntColumn('order_id', $tableName, false,
        $customConstraints: 'type UNIQUE');
  }

  final VerificationMeta _sightMeta = const VerificationMeta('sight');
  GeneratedTextColumn _sight;
  @override
  GeneratedTextColumn get sight => _sight ??= _constructSight();
  GeneratedTextColumn _constructSight() {
    return GeneratedTextColumn(
      'sight',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, sightId, orderId, sight];
  @override
  $FavoritesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'favorites';
  @override
  final String actualTableName = 'favorites';
  @override
  VerificationContext validateIntegrity(Insertable<Favorite> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('sight_id')) {
      context.handle(_sightIdMeta,
          sightId.isAcceptableOrUnknown(data['sight_id'], _sightIdMeta));
    } else if (isInserting) {
      context.missing(_sightIdMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id'], _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('sight')) {
      context.handle(
          _sightMeta, sight.isAcceptableOrUnknown(data['sight'], _sightMeta));
    } else if (isInserting) {
      context.missing(_sightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Favorite map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Favorite.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(_db, alias);
  }
}

class VisitedData extends DataClass implements Insertable<VisitedData> {
  final int id;
  final int sightId;
  final String sight;
  VisitedData(
      {@required this.id, @required this.sightId, @required this.sight});
  factory VisitedData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return VisitedData(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      sightId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sight_id']),
      sight: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sight']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || sightId != null) {
      map['sight_id'] = Variable<int>(sightId);
    }
    if (!nullToAbsent || sight != null) {
      map['sight'] = Variable<String>(sight);
    }
    return map;
  }

  VisitedCompanion toCompanion(bool nullToAbsent) {
    return VisitedCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      sightId: sightId == null && nullToAbsent
          ? const Value.absent()
          : Value(sightId),
      sight:
          sight == null && nullToAbsent ? const Value.absent() : Value(sight),
    );
  }

  factory VisitedData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return VisitedData(
      id: serializer.fromJson<int>(json['id']),
      sightId: serializer.fromJson<int>(json['sightId']),
      sight: serializer.fromJson<String>(json['sight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sightId': serializer.toJson<int>(sightId),
      'sight': serializer.toJson<String>(sight),
    };
  }

  VisitedData copyWith({int id, int sightId, String sight}) => VisitedData(
        id: id ?? this.id,
        sightId: sightId ?? this.sightId,
        sight: sight ?? this.sight,
      );
  @override
  String toString() {
    return (StringBuffer('VisitedData(')
          ..write('id: $id, ')
          ..write('sightId: $sightId, ')
          ..write('sight: $sight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(sightId.hashCode, sight.hashCode)));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisitedData &&
          other.id == this.id &&
          other.sightId == this.sightId &&
          other.sight == this.sight);
}

class VisitedCompanion extends UpdateCompanion<VisitedData> {
  final Value<int> id;
  final Value<int> sightId;
  final Value<String> sight;
  const VisitedCompanion({
    this.id = const Value.absent(),
    this.sightId = const Value.absent(),
    this.sight = const Value.absent(),
  });
  VisitedCompanion.insert({
    this.id = const Value.absent(),
    @required int sightId,
    @required String sight,
  })  : sightId = Value(sightId),
        sight = Value(sight);
  static Insertable<VisitedData> custom({
    Expression<int> id,
    Expression<int> sightId,
    Expression<String> sight,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sightId != null) 'sight_id': sightId,
      if (sight != null) 'sight': sight,
    });
  }

  VisitedCompanion copyWith(
      {Value<int> id, Value<int> sightId, Value<String> sight}) {
    return VisitedCompanion(
      id: id ?? this.id,
      sightId: sightId ?? this.sightId,
      sight: sight ?? this.sight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sightId.present) {
      map['sight_id'] = Variable<int>(sightId.value);
    }
    if (sight.present) {
      map['sight'] = Variable<String>(sight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitedCompanion(')
          ..write('id: $id, ')
          ..write('sightId: $sightId, ')
          ..write('sight: $sight')
          ..write(')'))
        .toString();
  }
}

class $VisitedTable extends Visited with TableInfo<$VisitedTable, VisitedData> {
  final GeneratedDatabase _db;
  final String _alias;
  $VisitedTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _sightIdMeta = const VerificationMeta('sightId');
  GeneratedIntColumn _sightId;
  @override
  GeneratedIntColumn get sightId => _sightId ??= _constructSightId();
  GeneratedIntColumn _constructSightId() {
    return GeneratedIntColumn('sight_id', $tableName, false,
        $customConstraints: 'type UNIQUE');
  }

  final VerificationMeta _sightMeta = const VerificationMeta('sight');
  GeneratedTextColumn _sight;
  @override
  GeneratedTextColumn get sight => _sight ??= _constructSight();
  GeneratedTextColumn _constructSight() {
    return GeneratedTextColumn(
      'sight',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, sightId, sight];
  @override
  $VisitedTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'visited';
  @override
  final String actualTableName = 'visited';
  @override
  VerificationContext validateIntegrity(Insertable<VisitedData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('sight_id')) {
      context.handle(_sightIdMeta,
          sightId.isAcceptableOrUnknown(data['sight_id'], _sightIdMeta));
    } else if (isInserting) {
      context.missing(_sightIdMeta);
    }
    if (data.containsKey('sight')) {
      context.handle(
          _sightMeta, sight.isAcceptableOrUnknown(data['sight'], _sightMeta));
    } else if (isInserting) {
      context.missing(_sightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VisitedData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return VisitedData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $VisitedTable createAlias(String alias) {
    return $VisitedTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $SearchRequestsTable _searchRequests;
  $SearchRequestsTable get searchRequests =>
      _searchRequests ??= $SearchRequestsTable(this);
  $FavoritesTable _favorites;
  $FavoritesTable get favorites => _favorites ??= $FavoritesTable(this);
  $VisitedTable _visited;
  $VisitedTable get visited => _visited ??= $VisitedTable(this);
  SearchRequestsDao _searchRequestsDao;
  SearchRequestsDao get searchRequestsDao =>
      _searchRequestsDao ??= SearchRequestsDao(this as AppDatabase);
  FavoritesDao _favoritesDao;
  FavoritesDao get favoritesDao =>
      _favoritesDao ??= FavoritesDao(this as AppDatabase);
  VisitedDao _visitedDao;
  VisitedDao get visitedDao => _visitedDao ??= VisitedDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [searchRequests, favorites, visited];
}
