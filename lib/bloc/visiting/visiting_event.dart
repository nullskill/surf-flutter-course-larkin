import 'package:equatable/equatable.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/visited_sight.dart';

/// Базовое событие экрана избранных/посещенных мест
abstract class VisitingEvent extends Equatable {
  const VisitingEvent();

  @override
  List<Object> get props => [];
}

/// Событие начала загрузки избранных/посещенных мест
class VisitingLoadEvent extends VisitingEvent {}

/// Событие удаления места из избранных мест
class VisitingRemoveFromFavoritesEvent extends VisitingEvent {
  const VisitingRemoveFromFavoritesEvent(this.favoriteSight);

  final FavoriteSight favoriteSight;
}

/// Событие удаления места из посещенных мест
class VisitingRemoveFromVisitedEvent extends VisitingEvent {
  const VisitingRemoveFromVisitedEvent(this.visitedSight);

  final VisitedSight visitedSight;
}
