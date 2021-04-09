import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repository/place_repository.dart';
import 'package:places/domain/sight.dart';

part 'sight_list_store.g.dart';

class SightListStore = SightListStoreBase with _$SightListStore;

abstract class SightListStoreBase with Store {
  SightListStoreBase(this._repo, this._searchInteractor);

  final PlaceRepository _repo;
  final SearchInteractor _searchInteractor;

  /// Отсортированный список мест
  @observable
  ObservableList<Sight> sights = ObservableList<Sight>();

  /// Флаг загрузки
  @observable
  bool isLoading;

  /// Флаг ошибки
  @observable
  bool hasError;

  /// Получение списка всех мест
  @action
  Future<void> loadSights() async {
    isLoading = true;
    hasError = false;

    try {
      final List<Place> _places = await _repo.getPlaces();
      sights = ObservableList.of(_places.map((p) => Sight.fromPlace(p)));
      _sortSights();
    } on DioError catch (e) {
      debugPrint('Error loading sights: ${e.error}');
      hasError = true;
    } finally {
      isLoading = false;
    }
  }

  /// Получение места по [id]
  @observable
  Future<Sight> getSightDetails(int id) async {
    Place place;

    place = await _repo.getPlaceDetails(id);

    return Sight.fromPlace(place);
  }

  /// Добавление нового места (возвращается с id)
  @action
  Future<void> addNewSight(Sight sight) async {
    final Place place = await _repo.addNewPlace(Place.fromSight(sight));
    sights.add(Sight.fromPlace(place));
    _sortSights();
  }

  /// Сортирует список моделей [Sight] по удаленности
  /// и инициализирует им список [sights]
  void _sortSights() {
    List<Sight> _sights = _searchInteractor.getSortedSights(sights);
    if (_searchInteractor.filteredNumber > 0) {
      _sights = _sights
          .where((s) => _searchInteractor.filteredSights.contains(s))
          .toList();
    }
    _searchInteractor.sights = _sights;
    sights = ObservableList.of(_sights);
  }
}
