import 'package:places/redux/action/sight_search_action.dart';
import 'package:places/redux/state/app_state.dart';
import 'package:places/redux/state/sight_search_state.dart';

AppState initSearchReducer(AppState state, InitSearchAction action) {
  return state.copyWith(sightSearchState: SearchInitialState());
}

AppState startSearchReducer(AppState state, StartSearchAction action) {
  return state.copyWith(
      sightSearchState: SearchRequestState(action.searchText));
}

AppState loadSearchReducer(AppState state, LoadSearchAction action) {
  return state.copyWith(sightSearchState: SearchLoadingState());
}

AppState finishSearchReducer(AppState state, FinishSearchAction action) {
  return state.copyWith(
      sightSearchState:
          SearchDataState(action.foundSights, hasError: action.hasError));
}
