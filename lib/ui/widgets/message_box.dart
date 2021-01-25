import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';

/// Виджет для показа сообщения пользователю
class MessageBox extends StatelessWidget {
  const MessageBox({
    Key key,
    @required this.title,
    @required this.iconName,
    @required this.message,
    this.link,
  }) : super(key: key);

  static const pxl64 = 64.0;

  final String title, iconName, message;
  final Map<String, String> link;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconName,
            width: pxl64,
            height: pxl64,
            color: inactiveColor,
          ),
          SizedBox(
            height: 24.0,
          ),
          Text(
            title,
            style: textMedium18.copyWith(
              color: inactiveColor,
              height: lineHeight1_3,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 253.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: textRegular14.copyWith(
                    color: inactiveColor,
                    height: lineHeight1_3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
