import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';

/// Виджет ActionButton предоставляет кнопку действия
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key key,
    this.iconName,
    @required this.label,
    this.isDisabled = false,
    this.onPressed,
  }) : super(key: key);

  final String iconName;
  final String label;
  final bool isDisabled;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      width: double.infinity,
      child: RaisedButton.icon(
        elevation: 0,
        icon: iconName != null
            ? SvgPicture.asset(
                iconName,
                width: 24,
                height: 24,
                color:
                    isDisabled ? Theme.of(context).disabledColor : whiteColor,
              )
            : SizedBox(),
        label: Text(
          label.toUpperCase(),
          style: textBold14.copyWith(
            color: isDisabled ? Theme.of(context).disabledColor : whiteColor,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: allBorderRadius12,
        ),
        onPressed: isDisabled ? null : onPressed,
      ),
    );
  }
}
