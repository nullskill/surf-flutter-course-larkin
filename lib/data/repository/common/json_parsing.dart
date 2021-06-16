import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:places/data/model/place.dart';
import 'package:places/util/consts.dart';

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

/// Парсит список URL файлов
List<String> parseFilesUrls(String rawJson) {
  final Map<String, dynamic> urlsJson =
      jsonDecode(rawJson) as Map<String, dynamic>;
  final List<String> urls = (urlsJson['urls'] as List<dynamic>)
      .cast<String>()
      .map((e) => p.join(baseUrl, e))
      .toList();

  return urls;
}
