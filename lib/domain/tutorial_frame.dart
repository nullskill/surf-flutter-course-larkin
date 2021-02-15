import 'package:flutter/foundation.dart';

/// Класс фрейма для онбординга
class TutorialFrame {
  String _iconName, _title, _message;

  get iconName => _iconName;

  get title => _title;

  get message => _message;

  TutorialFrame({
    @required iconName,
    @required title,
    @required message,
  }) {
    _iconName = iconName;
    _title = title;
    _message = message;
  }
}
