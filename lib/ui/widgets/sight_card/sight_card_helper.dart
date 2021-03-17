import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:places/domain/base_visiting.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/visited_sight.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:sized_context/sized_context.dart';

/// Вспомогательный класс для виджета AppRangeSlider
class SightCardHelper {
  SightCardHelper({this.sight});

  Sight sight;

  bool get isMainListCard => sight.runtimeType == Sight;

  bool get isVisitingCard =>
      [FavoriteSight, VisitedSight].contains(sight.runtimeType);

  bool get isFavoriteCard => sight.runtimeType == FavoriteSight;

  double getAspectRatio(BuildContext context) {
    if (sight.runtimeType == Sight) {
      if (context.diagonalInches > 7) {
        if (context.widthPx > 500) {
          return 21 / 9;
        } else {
          return 2;
        }
      }
      if (context.diagonalInches > 5) {
        if (context.heightPx > 700) {
          return 3 / 2;
        } else {
          return 5 / 3;
        }
      }
      return 4 / 3;
    } else {
      if (context.diagonalInches > 7) {
        return 5 / 2;
      }
      if (context.diagonalInches > 5) {
        return 16 / 9;
      }
      return 4 / 3;
    }
  }

  int getMaxLines(BuildContext context) {
    if (context.diagonalInches > 7) {
      return 5;
    }
    if (context.diagonalInches > 4) {
      return 4;
    }
    if (context.diagonalInches > 3) {
      return 3;
    }
    return 2;
  }

  String getVisitingDate() {
    if (isFavoriteCard) {
      return '$sightCardPlanned ${DateFormat.yMMMd().format((sight as FavoriteSight).plannedDate)}';
    }
    return '$sightCardVisited ${DateFormat.yMMMd().format((sight as VisitedSight).visitedDate)}';
  }

  String getOpenHours() {
    if (isVisitingCard) {
      return '$sightDetailsOpenHours ${DateFormat.Hm().format((sight as VisitingSight).openHour)}';
    }
    return '';
  }
}
