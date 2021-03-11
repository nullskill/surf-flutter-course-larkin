import 'package:flutter/material.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/widgets/message_box.dart';

/// Экран для отображения ошибки.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    Key key,
    this.title = errorTitle,
    this.iconName = AppIcons.emptyError,
    this.message = errorMessage,
    this.link,
  }) : super(key: key);

  final String title, iconName, message;
  final Map<String, String> link;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MessageBox(
        title: title,
        iconName: iconName,
        message: message,
        link: link,
      ),
    );
  }
}
