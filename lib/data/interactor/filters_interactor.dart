import 'dart:convert';

import 'package:places/data/storage/app_storage.dart';
import 'package:places/domain/sight_filter.dart';

/// Класс интерактора критериев поиска
class FiltersInteractor {
  static const _filtersKey = 'filters';

  /// Возвращает критерии поиска
  SightFilter get filters {
    final String filterString = AppStorage.getString(_filtersKey);
    if (filterString.isNotEmpty) {
      final filtersJson = jsonDecode(filterString) as Map<String, dynamic>;
      return SightFilter.fromJson(filtersJson);
    }
    return SightFilter();
  }

  /// Сохраняет критерии поиска
  void saveFilters(SightFilter value) {
    AppStorage.setString(_filtersKey, jsonEncode(value));
  }
}
