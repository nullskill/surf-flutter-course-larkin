import 'package:places/data/model/place.dart';
import 'package:places/data/model/places_filter_dto.dart';
import 'package:places/data/repository/common/error_handler.dart';
import 'package:places/data/repository/common/json_parsing.dart';
import 'package:places/data/repository/network/api_service.dart';

/// Репозиторий поиска и фильтрации интересных мест
class SearchRepository {
  final ApiService _api = ApiService();

  static const String filteredPlacesPath = '/filtered_places';

  /// POST /filtered_places
  /// Получение списка отфильтрованных мест
  Future<List<Place>> getFilteredPlaces(PlacesFilterDto filterDto) async {
    final String response = await handleError<String>(
      () => _api.post<String>(filteredPlacesPath, filterDto.toJson()),
      message: 'Error searching places',
    );

    return parsePlaces(response);
  }
}
