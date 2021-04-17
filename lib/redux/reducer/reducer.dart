import 'package:places/redux/action/sight_search_action.dart';
import 'package:places/redux/action/sight_search_history_action.dart';
import 'package:places/redux/reducer/sight_search_history_reducer.dart';
import 'package:places/redux/reducer/sight_search_reducer.dart';
import 'package:places/redux/state/app_state.dart';
import 'package:redux/redux.dart';

/// Основной редьюсер
final reducer = combineReducers<AppState>([
  // Search reducers
  TypedReducer<AppState, InitSearchAction>(initSearchReducer),
  TypedReducer<AppState, StartSearchAction>(startSearchReducer),
  TypedReducer<AppState, LoadSearchAction>(loadSearchReducer),
  TypedReducer<AppState, FinishSearchAction>(finishSearchReducer),
  // Search history reducers
  TypedReducer<AppState, InitHistoryAction>(initHistoryReducer),
  TypedReducer<AppState, AddToHistoryAction>(addToHistoryReducer),
  TypedReducer<AppState, DeleteFromHistoryAction>(deleteFromHistoryReducer),
  TypedReducer<AppState, ClearHistoryAction>(clearHistoryReducer),
]);
