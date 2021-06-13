import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repository/common/error_handler.dart';
import 'package:places/data/repository/common/json_parsing.dart';
import 'package:places/data/repository/network/api_service.dart';
import 'package:uuid/uuid.dart';

/// Репозиторий для интересного места
class PlaceRepository {
  final ApiService _api = ApiService();

  static const String placePath = '/place';
  static const String uploadPath = '/upload_file';

  /// GET /place
  /// Получение списка всех мест
  Future<List<Place>> getPlaces() async {
    final String response = await handleError<String>(
      () => _api.get<String>(placePath),
      message: 'Error getting places',
    );

    return parsePlaces(response);
  }

  /// GET /place/:id
  /// Получение места по [id]
  Future<Place> getPlaceDetails(int id) async {
    final String response = await handleError<String>(
      () => _api.get<String>('$placePath/$id'),
      message: 'Error getting place details',
    );

    return parsePlace(response);
  }

  /// POST /place
  /// Добавление места
  Future<Place> addNewPlace(Place place) async {
    place.urls = await uploadImages(place.urls);

    final String response = await handleError<String>(
      () => _api.post<String>(placePath, place.toJson()),
      message: 'Error adding new place',
    );

    return parsePlace(response);
  }

  /// POST /upload_file
  /// Загрузка картинок
  Future<List<String>> uploadImages(List<String> images) async {
    const jpegMime = 'image/jpeg', jpegExt = 'jpg';
    const uuid = Uuid();
    final FormData formData = FormData();

    formData.files.addAll(
      images
          .map((filePath) => File(filePath))
          .where((file) => file.existsSync())
          .map(
        (file) {
          final mimeType = mime(file.path) ?? jpegMime;
          final mimeExt =
              mimeType == jpegMime ? jpegExt : extensionFromMime(mimeType);

          return MapEntry(
            'files',
            MultipartFile.fromFileSync(
              file.path,
              filename: '${uuid.v1()}.$mimeExt',
              contentType: MediaType.parse(mimeType),
            ),
          );
        },
      ),
    );

    final String response = await handleError<String>(
      () => _api.postFiles<String>(uploadPath, formData),
      message: 'Error uploading images',
    );

    return parseFilesUrls(response);
  }
}
