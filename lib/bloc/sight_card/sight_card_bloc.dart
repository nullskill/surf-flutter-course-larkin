import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/bloc/sight_card/sight_card_event.dart';
import 'package:places/bloc/sight_card/sight_card_state.dart';
import 'package:places/data/repository/visiting_repository.dart';
import 'package:places/domain/sight.dart';

/// Блок манипулирования местом в избранном
class SightCardBloc extends Bloc<SightCardEvent, SightCardState> {
  SightCardBloc(this._repo, this.sight) : super(SightCardLoadInProgress());

  final VisitingRepository _repo;
  final Sight sight;

  @override
  Stream<SightCardState> mapEventToState(SightCardEvent event) async* {
    if (event is SightCardCheckIsFavoriteEvent) {
      yield* _mapCheckIsFavoriteToState();
    } else if (event is SightCardToggleFavoriteEvent) {
      yield* _mapToggleFavoriteToState();
    }
  }

  Stream<SightCardState> _mapCheckIsFavoriteToState() async* {
    yield* _checkIsFavorite();
  }

  Stream<SightCardState> _mapToggleFavoriteToState() async* {
    _repo.toggleFavoriteSight(sight);

    yield* _checkIsFavorite();
  }

  Stream<SightCardState> _checkIsFavorite() async* {
    final isFavoriteSight = _repo.isFavoriteSight(sight);

    yield SightCardLoadSuccess(isFavoriteSight);
  }
}
