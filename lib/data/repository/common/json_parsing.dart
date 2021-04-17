import 'dart:convert';

import 'package:places/data/model/place.dart';

/// Парсит интересные места
List<Place> parsePlaces(String rawJson) {
  final List<dynamic> placeListJson = jsonDecode(rawJson) as List<dynamic>;
  final List<Map<String, dynamic>> placeList =
      List<Map<String, dynamic>>.from(placeListJson);
  final List<Place> places =
      placeList.map((placeJson) => Place.fromJson(placeJson)).toList();

  return places;
}

/// Парсит интересное место
Place parsePlace(String rawJson) {
  final Map<String, dynamic> placeJson =
      jsonDecode(rawJson) as Map<String, dynamic>;
  final Place place = Place.fromJson(placeJson);

  return place;
}
