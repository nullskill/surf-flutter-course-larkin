import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:places/data/repository/network/exceptions.dart';
import 'package:places/util/consts.dart';

/// Сервис для работы с API
class ApiService {
  ApiService() {
    _dio = Dio(baseOptions);

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (e) {
        debugPrint('API error: $e');
      },
      onRequest: (options) {
        debugPrint(
            '>> [${options.method} ${options.path}]: ${options.data ?? ''}');
      },
      onResponse: (response) {
        final req = response.request;
        debugPrint(
            '<< ${response.statusCode} [${req.method} ${req.path}]: ${response.data}');
      },
    ));
  }

  static const timeOut = 5000;

  Dio _dio;

  final BaseOptions baseOptions = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: timeOut,
    receiveTimeout: timeOut,
    sendTimeout: timeOut,
    followRedirects: false,
    validateStatus: (status) {
      return status <= 500;
    },
    headers: <String, String>{'Accept': 'application/json'},
  );

  Future<dynamic> get<T>(String path) async {
    final response = await _dio.get<T>(path);
    return _getResponseData(response);
  }

  Future<dynamic> post<T>(String path, Map<String, dynamic> data) async {
    final response = await _dio.post<T>(path, data: data);
    return _getResponseData(response);
  }

  dynamic _getResponseData(Response response) {
    if (response == null) {
      throw Exception('Network unreachable');
    }
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 409:
        throw BadRequestException('Object already exists');
      case 404:
        throw BadRequestException('No object found');
      case 500:
      default:
        throw FetchDataException(
            'Server Responded With ${response.statusCode} Code');
    }
  }
}
