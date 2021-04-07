import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Future<String> handleError({
  Future<String> Function() future,
  String message,
}) async {
  try {
    return await future();
  } on DioError catch (e) {
    debugPrint('$message: ${e.error}');
    rethrow;
  }
}
