import 'package:places/redux/state/sight_search_history_state.dart';
import 'package:places/redux/state/sight_search_state.dart';

/// Состояние приложения
class AppState {
  AppState({
    SightSearchState sightSearchState,
    SightSearchHistoryState sightSearchHistoryState,
  })  : sightSearchState = sightSearchState ?? SearchInitialState(),
        sightSearchHistoryState =
            sightSearchHistoryState ?? HistoryInitialState();

  AppState copyWith({
    SightSearchState sightSearchState,
    SightSearchHistoryState sightSearchHistoryState,
  }) =>
      AppState(
          sightSearchState: sightSearchState ?? this.sightSearchState,
          sightSearchHistoryState:
              sightSearchHistoryState ?? this.sightSearchHistoryState);

  final SightSearchState sightSearchState;
  final SightSearchHistoryState sightSearchHistoryState;
}
