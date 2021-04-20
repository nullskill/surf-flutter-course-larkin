import 'package:places/domain/sight.dart';

/// Базовый класс действий для экрана поиска
abstract class SightSearchAction {}

class InitSearchAction extends SightSearchAction {}

class StartSearchAction extends SightSearchAction {
  StartSearchAction(this.searchText);

  final String searchText;
}

class LoadSearchAction extends SightSearchAction {}

class FinishSearchAction extends SightSearchAction {
  FinishSearchAction(this.foundSights, {this.hasError = false});

  final List<Sight> foundSights;
  final bool hasError;
}
