import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/model/places_filter_dto.dart';
import 'package:places/data/repository/network/api_service.dart';

/// Репозиторий поиска и фильтрации интересных мест
class SearchRepository {
  final ApiService _helper = ApiService();

  /// POST /filtered_places
  /// Получение списка отфильтрованных мест
  Future<List<Place>> getFilteredPlaces(PlacesFilterDto filterDto) async {
    final dynamic response =
        await _helper.post<String>('/filtered_places', filterDto.toJson());

    return _parseFilteredPlaces(response.toString());
  }

  List<Place> _parseFilteredPlaces(String rawJson) {
    final List<dynamic> placeListJson = jsonDecode(rawJson) as List<dynamic>;
    final List<Map<String, dynamic>> placeList =
        List<Map<String, dynamic>>.from(placeListJson);
    final List<Place> places =
        placeList.map((placeJson) => Place.fromJson(placeJson)).toList();

    debugPrint(places.length.toString());

    return places;
  }
}
