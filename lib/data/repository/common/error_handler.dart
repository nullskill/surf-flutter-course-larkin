import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Future<T> handleError<T extends Object>(
  Future<T> Function() future, {
  String message = 'Error',
}) {
  try {
    return future();
  } on DioError catch (e) {
    debugPrint('$message: ${e.error}');
    rethrow;
  }
}
