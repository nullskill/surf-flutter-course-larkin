// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sight_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SightListStore on SightListStoreBase, Store {
  final _$sightsAtom = Atom(name: 'SightListStoreBase.sights');

  @override
  ObservableList<Sight> get sights {
    _$sightsAtom.reportRead();
    return super.sights;
  }

  @override
  set sights(ObservableList<Sight> value) {
    _$sightsAtom.reportWrite(value, super.sights, () {
      super.sights = value;
    });
  }

  final _$isLoadingAtom = Atom(name: 'SightListStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$hasErrorAtom = Atom(name: 'SightListStoreBase.hasError');

  @override
  bool get hasError {
    _$hasErrorAtom.reportRead();
    return super.hasError;
  }

  @override
  set hasError(bool value) {
    _$hasErrorAtom.reportWrite(value, super.hasError, () {
      super.hasError = value;
    });
  }

  @override
  ObservableFuture<Sight> getSightDetails(int id) {
    final _$future = super.getSightDetails(id);
    return ObservableFuture<Sight>(_$future);
  }

  final _$loadSightsAsyncAction = AsyncAction('SightListStoreBase.loadSights');

  @override
  Future<void> loadSights() {
    return _$loadSightsAsyncAction.run(() => super.loadSights());
  }

  final _$addNewSightAsyncAction =
      AsyncAction('SightListStoreBase.addNewSight');

  @override
  Future<void> addNewSight(Sight sight) {
    return _$addNewSightAsyncAction.run(() => super.addNewSight(sight));
  }

  @override
  String toString() {
    return '''
sights: ${sights},
isLoading: ${isLoading},
hasError: ${hasError}
    ''';
  }
}
