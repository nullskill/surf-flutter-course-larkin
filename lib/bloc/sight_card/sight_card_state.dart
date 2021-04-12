import 'package:equatable/equatable.dart';

/// Базовое состояние манипулирования местом в избранном
abstract class SightCardState extends Equatable {
  const SightCardState();

  @override
  List<Object> get props => [];
}

/// Состояние начала добавления/удаления в избранное
class SightCardLoadInProgress extends SightCardState {}

/// Состояние после добавления/удаления в избранное
class SightCardLoadSuccess extends SightCardState {
  // ignore: avoid_positional_boolean_parameters
  const SightCardLoadSuccess(this.isFavoriteSight);

  final bool isFavoriteSight;

  @override
  List<Object> get props => [isFavoriteSight];

  @override
  String toString() {
    return 'SightCardLoadSuccess{isFavoriteSight: $isFavoriteSight}';
  }
}
