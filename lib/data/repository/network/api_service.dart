import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:places/data/repository/network/exceptions.dart';
import 'package:places/util/consts.dart';

/// Сервис для работы с API
class ApiService {
  ApiService() {
    _dio = Dio(_baseOptions);

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (e, _) {
        _throwException(e);
      },
      onRequest: (options, handler) {
        debugPrint(
            '>> [${options.method} ${options.path}]: ${options.data ?? ''}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        final req = response.requestOptions;
        debugPrint(
            '<< ${response.statusCode} [${req.method} ${req.baseUrl}${req.path}]: ${response.data}');
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
    validateStatus: (status) => status < 300,
    headers: <String, String>{'Accept': 'application/json'},
    responseType: ResponseType.plain,
  );

  Future<String> get<T>(String path) async {
    final response = await _dio.get<T>(path);
    return response.data.toString();
  }

  Future<String> post<T>(String path, Map<String, dynamic> data) async {
    final response = await _dio.post<T>(path, data: data);
    return response.data.toString();
  }

  String _throwException(DioError e) {
    final res = e.response;
    final req = e.requestOptions;
    final reqString =
        '${res?.statusCode ?? 'No Response'} [${req.method} ${req.baseUrl}${req.path}]';

    switch (res?.statusCode) {
      case 400:
        throw BadRequestException(reqString);
      case 409:
        throw BadRequestException('$reqString: Object Already Exists');
      case 404:
        throw BadRequestException('$reqString: No Object Found');
      case 500:
      default:
        throw NetworkException(reqString);
    }
  }
}
