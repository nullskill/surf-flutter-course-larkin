import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/model/places_filter_dto.dart';
import 'package:places/domain/sight.dart';
import 'package:places/redux/action/sight_search_action.dart';
import 'package:places/redux/state/app_state.dart';
import 'package:redux/redux.dart';

class SightSearchMiddleware implements MiddlewareClass<AppState> {
  SightSearchMiddleware(this._searchInteractor);

  final SearchInteractor _searchInteractor;

  // Требует именно dynamic
  @override
  dynamic call(
    Store<AppState> store,
    // ignore: avoid_annotating_with_dynamic
    dynamic action,
    NextDispatcher next,
  ) async {
    if (action is StartSearchAction) {
      if (action.searchText.isEmpty) {
        next(InitSearchAction());
        return;
      }

      next(LoadSearchAction());

      bool hasError = false;
      List<Sight> _foundSights = [];

      try {
        _foundSights = await _searchInteractor
            .searchPlaces(PlacesFilterDto(nameFilter: action.searchText));
      } on DioError catch (e) {
        debugPrint('Error searching places: ${e.error}');
        hasError = true;
      } finally {
        next(FinishSearchAction(_foundSights, hasError: hasError));
      }
    } else {
      next(action);
    }
  }
}
