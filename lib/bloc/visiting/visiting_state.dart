import 'package:equatable/equatable.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/visited_sight.dart';

/// Базовое состояние для экрана избранных/посещенных мест
abstract class VisitingState extends Equatable {
  const VisitingState();

  @override
  List<Object> get props => [];
}

/// Состояние загрузки избранных/посещенных мест
class VisitingLoadInProgress extends VisitingState {}

/// Состояние при удалении места из избранных/посещенных
class VisitingRemoveInProgress extends VisitingState {}

/// Состояние загруженных избранных/посещенных мест
class VisitingLoadSuccess extends VisitingState {
  const VisitingLoadSuccess(this.favoriteSights, this.visitedSights);

  final List<FavoriteSight> favoriteSights;
  final List<VisitedSight> visitedSights;

  @override
  List<Object> get props => [favoriteSights, visitedSights];

  @override
  String toString() {
    return 'VisitingLoadSuccess{favoriteSights: $favoriteSights, favoriteSights: $favoriteSights}';
  }
}
