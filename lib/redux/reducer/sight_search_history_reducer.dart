import 'package:places/redux/action/sight_search_history_action.dart';
import 'package:places/redux/state/app_state.dart';
import 'package:places/redux/state/sight_search_history_state.dart';
import 'package:places/util/consts.dart';

AppState initHistoryReducer(AppState state, InitHistoryAction action) {
  return state.copyWith(sightSearchHistoryState: HistoryInitialState());
}

AppState addToHistoryReducer(AppState state, AddToHistoryAction action) {
  final List<String> history = state.sightSearchHistoryState.history
      .where((item) => item != action.item)
      .toList()
        ..add(action.item);
  if (history.length > maxSearchHistoryLength) history.removeAt(0);

  return state.copyWith(sightSearchHistoryState: HistoryDataState(history));
}

AppState deleteFromHistoryReducer(
    AppState state, DeleteFromHistoryAction action) {
  final List<String> history = state.sightSearchHistoryState.history
      .where((item) => item != action.item)
      .toList();

  return state.copyWith(sightSearchHistoryState: HistoryDataState(history));
}

AppState clearHistoryReducer(AppState state, ClearHistoryAction action) {
  return state.copyWith(sightSearchHistoryState: HistoryInitialState());
}
