import 'package:flutter/material.dart';

import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';

/// Виджет для вывода подзаголовка экрана
class Subtitle extends StatelessWidget {
  const Subtitle({
    Key key,
    @required this.subtitle,
  }) : super(key: key);

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        subtitle.toUpperCase(),
        style: textRegular12.copyWith(
          color: inactiveColor,
          height: lineHeight1_3,
        ),
      ),
    );
  }
}
