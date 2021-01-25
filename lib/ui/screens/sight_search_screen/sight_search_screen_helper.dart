import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';

/// Вспомогательный класс для экрана поиска
class SightSearchScreenHelper {
  Stream<List<Sight>> getSightList(String searchString) async* {
    await Future.delayed(Duration(seconds: 2));
    yield [
      ...mocks.where((el) =>
          el.name.contains(searchString) || el.details.contains(searchString)),
    ];
  }
}
