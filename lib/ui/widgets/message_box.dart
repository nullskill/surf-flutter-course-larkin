import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/widgets/link.dart';

/// Виджет для показа сообщения пользователю
class MessageBox extends StatelessWidget {
  const MessageBox({
    @required this.title,
    @required this.iconName,
    @required this.message,
    this.link = const <String, void Function()>{},
    Key key,
  }) : super(key: key);

  final String title, iconName, message;
  final Map<String, void Function()> link;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconName,
            width: 64.0,
            height: 64.0,
            color: inactiveColor,
          ),
          const SizedBox(height: 24.0),
          Text(
            title,
            style: textMedium18.copyWith(
              color: inactiveColor,
              height: lineHeight1_3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 253.5,
            child: Column(
              children: [
                Text(
                  message,
                  style: textRegular14.copyWith(
                    color: inactiveColor,
                    height: lineHeight1_3,
                  ),
                  textAlign: TextAlign.center,
                ),
                link == null || link.isEmpty
                    ? const SizedBox.shrink()
                    : Link(
                        label: link.keys.first,
                        onTap: link.values.first,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
