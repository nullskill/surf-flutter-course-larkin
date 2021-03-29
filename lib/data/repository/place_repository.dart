import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repository/network/api_service.dart';

/// Репозиторий для интересного места
class PlaceRepository {
  final ApiService _helper = ApiService();

  /// GET /place
  /// Получение списка всех мест
  Future<List<Place>> getPlaces() async {
    final dynamic response = await _helper.get<String>('/place');

    return _parsePlaces(response.toString());
  }

  /// GET /place/:id
  /// Получение места по [id]
  Future<Place> getPlaceDetails(int id) async {
    final dynamic response = await _helper.get<String>('/place/$id');

    return _parsePlace(response.toString());
  }

  /// POST /place
  /// Добавление места
  Future<Place> addNewPlace(Place place) async {
    final dynamic response =
        await _helper.post<String>('/place', place.toJson());

    return _parsePlace(response.toString());
  }

  List<Place> _parsePlaces(String rawJson) {
    final List<dynamic> placeListJson = jsonDecode(rawJson) as List<dynamic>;
    final List<Map<String, dynamic>> placeList =
        List<Map<String, dynamic>>.from(placeListJson);
    final List<Place> places =
        placeList.map((placeJson) => Place.fromJson(placeJson)).toList();

    debugPrint(places.length.toString());

    return places;
  }

  Place _parsePlace(String rawJson) {
    final Map<String, dynamic> placeJson =
        jsonDecode(rawJson) as Map<String, dynamic>;
    final Place place = Place.fromJson(placeJson);

    return place;
  }
}
