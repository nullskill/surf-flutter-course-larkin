/// Базовый класс действий для истории поиска экрана поиска
abstract class SightSearchHistoryAction {}

class InitHistoryAction extends SightSearchHistoryAction {}

class AddToHistoryAction extends SightSearchHistoryAction {
  AddToHistoryAction(this.item);

  final String item;
}

class DeleteFromHistoryAction extends SightSearchHistoryAction {
  DeleteFromHistoryAction(this.item);

  final String item;
}

class ClearHistoryAction extends SightSearchHistoryAction {}
