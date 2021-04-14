import 'package:equatable/equatable.dart';

/// Базовое событие манипулирования местом в избранном
abstract class SightCardEvent extends Equatable {
  const SightCardEvent();

  @override
  List<Object> get props => [];
}

/// Событие проверки, что место в избранном
class SightCardCheckIsFavoriteEvent extends SightCardEvent {}

/// Событие добавления/удаления в избранное
class SightCardToggleFavoriteEvent extends SightCardEvent {}
