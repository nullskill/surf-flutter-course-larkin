import 'package:flutter/material.dart';

import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    Key key,
    @required this.title,
    @required this.trailing,
    this.paddingValue = 14.0,
    this.isGreyedOut = false,
    this.onTap,
  }) : super(key: key);

  final String title;
  final Widget trailing;
  final double paddingValue;
  final bool isGreyedOut;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: paddingValue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textRegular16.copyWith(
                color: isGreyedOut
                    ? secondaryColor2
                    : Theme.of(context).primaryColor,
                height: lineHeight1_25,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}