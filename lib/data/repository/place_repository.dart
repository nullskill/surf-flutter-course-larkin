import 'package:places/data/model/place.dart';
import 'package:places/data/repository/json_parsing.dart';
import 'package:places/data/repository/network/api_service.dart';
import 'package:places/data/repository/network/error_handler.dart';

/// Репозиторий для интересного места
class PlaceRepository {
  final ApiService _api = ApiService();

  static const String placePath = '/place';

  /// GET /place
  /// Получение списка всех мест
  Future<List<Place>> getPlaces() async {
    final String response = await handleError(
      future: () => _api.get<String>(placePath),
      message: 'Error getting sights',
    );

    return parsePlaces(response);
  }

  /// GET /place/:id
  /// Получение места по [id]
  Future<Place> getPlaceDetails(int id) async {
    final String response = await handleError(
      future: () => _api.get<String>('$placePath/$id'),
      message: 'Error getting sight details',
    );

    return parsePlace(response);
  }

  /// POST /place
  /// Добавление места
  Future<Place> addNewPlace(Place place) async {
    final String response = await handleError(
      future: () => _api.post<String>(placePath, place.toJson()),
      message: 'Error adding new sight',
    );

    return parsePlace(response);
  }
}
