import 'dart:convert';

import 'package:places/data/storage/app_storage.dart';
import 'package:places/domain/sight_filter.dart';

/// Класс интерактора критериев поиска
class FiltersInteractor {
  FiltersInteractor() {
    final String filterString = AppStorage.getString(_filtersKey);
    if (filterString.isNotEmpty) {
      final filtersJson = jsonDecode(filterString) as Map<String, dynamic>;
      _filters = SightFilter.fromJson(filtersJson);
    }
  }

  static const _filtersKey = 'filters';

  SightFilter _filters;

  /// Возвращает критерии поиска
  SightFilter get filters => _filters;

  /// Сохраняет критерии поиска
  void saveFilters(SightFilter value) {
    AppStorage.setString(_filtersKey, jsonEncode(value));
  }
}
