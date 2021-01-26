import 'dart:async';

import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';

/// Вспомогательный класс для экрана поиска
class SightSearchScreenHelper {
  Stream<List<Sight>> getSightList(String searchString) async* {
    searchString = searchString.trim().toLowerCase();

    if (searchString.isEmpty) {
      yield null;
    }

    await Future.delayed(Duration(seconds: 2));
    yield [
      ...mocks.where((el) =>
          el.name.toLowerCase().contains(searchString) ||
          el.details.toLowerCase().contains(searchString)),
    ];
  }
}

// // Стрим, в котором данные результата запроса
// StreamController<List<Sight>> _streamController;
//
// // Подписка для отмены текущего запроса
// StreamSubscription<List> _loadingDataSubscr;
//
// // Таймер для паузы между запросом и вводом пользователя.
// Timer _debounceTimer;
//
// // _doSearch выполняется через 3 сек, если раньше не прилетело в _onSearch
// Future<void> _onSearch(String value) async {
//   _debounceTimer?.cancel();
//   if (value != '') {
//     _debounceTimer = Timer(Duration(milliseconds: 3000), () {
//       _loadingDataSubscr?.cancel();
//       _loadingDataSubscr = _doSearch(value).asStream().listen((searchResult) {
//         _streamController.sink.add(searchResult);
//       }, onError: (error) {
//         _streamController.addError(error);
//       });
//     });
//   }
// }
//
// Future<List<Sight>> _doSearch(String value) async {
//   // ...
// }

// В том коде что я прислал 2 стрима.
// Один для результатов поиска, на него подписывается StreamBuilder
// и в него посылаем результаты.
// И второй, который получается из Future -   _doSearch(value).asStream().
// На него подписывемся (_loadingDataSubscr),
// чтобы была возможность отменить в случае,
// если пришел еще запрос, а _doSearch уже выполняется.
