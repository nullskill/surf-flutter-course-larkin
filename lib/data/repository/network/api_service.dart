import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:places/data/repository/network/exceptions.dart';
import 'package:places/util/consts.dart';

/// Сервис для работы с API
class ApiService {
  ApiService() {
    _dio = Dio(_baseOptions);

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (e, handler) {
        debugPrint('API error: $e');
        handler.next(e);
      },
      onRequest: (options, handler) {
        debugPrint(
            '>> [${options.method} ${options.path}]: ${options.data ?? ''}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        final req = response.requestOptions;
        debugPrint(
            '<< ${response.statusCode} [${req.method} ${req.path}]: ${response.data}');
        handler.next(response);
      },
    ));
  }

  static const _timeOut = 5000;

  Dio _dio;

  final BaseOptions _baseOptions = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: _timeOut,
    receiveTimeout: _timeOut,
    sendTimeout: _timeOut,
    followRedirects: false,
    validateStatus: (status) => status <= 500,
    headers: <String, String>{'Accept': 'application/json'},
    responseType: ResponseType.plain,
  );

  Future<String> get<T>(String path) async {
    final response = await _dio.get<T>(path);
    return _getResponseData(response);
  }

  Future<String> post<T>(String path, Map<String, dynamic> data) async {
    final response = await _dio.post<T>(path, data: data);
    return _getResponseData(response);
  }

  String _getResponseData(Response response) {
    if (response == null) {
      throw Exception('Network Unreachable');
    }
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data.toString();
      case 400:
        throw BadRequestException(response.data.toString());
      case 409:
        throw BadRequestException('Object Already Exists');
      case 404:
        throw BadRequestException('No Object Found');
      case 500:
      default:
        throw FetchDataException(
            'Server Responded With ${response.statusCode} Code');
    }
  }
}
