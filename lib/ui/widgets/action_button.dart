import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/assets.dart';

/// Виджет ActionButton предоставляет кнопку действия
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      width: double.infinity,
      child: RaisedButton.icon(
        elevation: 0,
        icon: SvgPicture.asset(
          AppIcons.go,
          width: 24,
          height: 24,
          color: whiteColor,
        ),
        label: Text(
          sightDetailsShowRoute.toUpperCase(),
          style: textBold14.copyWith(color: whiteColor),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: allBorderRadius12,
        ),
        onPressed: () {
          print("ActionButton pressed");
        },
      ),
    );
  }
}
