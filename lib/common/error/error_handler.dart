import 'package:flutter/foundation.dart';
import 'package:mwwm/mwwm.dart';

/// Общий обработчик ошибок
class DefaultErrorHandler extends ErrorHandler {
  @override
  void handleError(Object e) {
    debugPrint('Handled error: $e');
  }
}
