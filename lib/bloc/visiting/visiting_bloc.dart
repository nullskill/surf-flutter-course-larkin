import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/visiting/visiting_event.dart';
import 'package:places/bloc/visiting/visiting_state.dart';
import 'package:places/data/repository/visiting_repository.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/visited_sight.dart';

/// Блок экрана избранных/посещенных мест
class VisitingBloc extends Bloc<VisitingEvent, VisitingState> {
  VisitingBloc(this._repo) : super(VisitingLoadInProgress());

  final VisitingRepository _repo;

  @override
  Stream<VisitingState> mapEventToState(VisitingEvent event) async* {
    if (event is VisitingLoadEvent) {
      yield* _mapVisitingLoadToState();
    } else if (event is VisitingRemoveFromFavoritesEvent) {
      yield* _mapRemoveFromFavoritesToState(event.favoriteSight);
    } else if (event is VisitingRemoveFromVisitedEvent) {
      yield* _mapRemoveFromVisitedToState(event.visitedSight);
    }
  }

  Stream<VisitingState> _mapVisitingLoadToState() async* {
    yield* _visitingLoadSuccess();
  }

  Stream<VisitingState> _mapRemoveFromFavoritesToState(
      FavoriteSight favoriteSight) async* {
    yield VisitingRemoveInProgress();

    _repo.removeFromFavorites(favoriteSight);

    yield* _visitingLoadSuccess();
  }

  Stream<VisitingState> _mapRemoveFromVisitedToState(
      VisitedSight visitedSight) async* {
    yield VisitingRemoveInProgress();

    _repo.removeFromFavorites(visitedSight);

    yield* _visitingLoadSuccess();
  }

  Stream<VisitingState> _visitingLoadSuccess() async* {
    final favoriteSights = _repo.favoriteSights;
    final visitedSights = _repo.visitedSights;

    yield VisitingLoadSuccess(favoriteSights, visitedSights);
  }
}
