import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/text_styles.dart';

/// Виджет ActionButton предоставляет кнопку действия
class ActionButton extends StatelessWidget {
  const ActionButton({
    @required this.label,
    this.iconName,
    this.isDisabled = false,
    this.isDialogButton = false,
    this.onPressed,
    Key key,
  }) : super(key: key);

  final String iconName;
  final String label;
  final bool isDisabled;
  final bool isDialogButton;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = isDialogButton
        ? Theme.of(context).canvasColor
        : Theme.of(context).buttonColor;
    final Color labelColor = isDialogButton
        ? Theme.of(context).buttonColor
        : isDisabled
            ? Theme.of(context).disabledColor
            : whiteColor;
    return SizedBox(
      height: 48.0,
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: allBorderRadius12,
          ),
        ),
        icon: iconName != null
            ? SvgPicture.asset(
                iconName,
                width: 24,
                height: 24,
                color: labelColor,
              )
            : const SizedBox.shrink(),
        label: Text(
          label.toUpperCase(),
          style: textBold14.copyWith(
            color: labelColor,
          ),
        ),
        onPressed: isDisabled ? null : onPressed,
      ),
    );
  }
}
