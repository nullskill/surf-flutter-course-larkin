import 'dart:async';

import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';

/// Вспомогательный класс для экрана поиска
class SightSearchScreenHelper {
  static const searchDelay = 200;
  static const debounceDelay = 3000;

  Stream<List<Sight>> getSightList(String searchString) async* {
    searchString = searchString.trim().toLowerCase();

    await Future.delayed(Duration(milliseconds: searchDelay));
    yield [
      ...mocks.where((el) =>
          filteredMocks.contains(el) &
          (el.name.toLowerCase().contains(searchString) ||
              el.details.toLowerCase().contains(searchString))),
    ];
  }
}
