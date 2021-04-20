import 'package:places/domain/sight.dart';

/// Состояние для результатов экрана поиска
abstract class SightSearchState {}

class SearchInitialState extends SightSearchState {}

class SearchRequestState extends SightSearchState {
  SearchRequestState(this.searchText);

  final String searchText;
}

class SearchLoadingState extends SightSearchState {
  final List<Sight> foundSights = [];
}

class SearchDataState extends SightSearchState {
  SearchDataState(this.foundSights, {this.hasError = false});

  final List<Sight> foundSights;
  final bool hasError;
}
