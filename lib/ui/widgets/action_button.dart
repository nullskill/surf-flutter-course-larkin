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
    this.onPressed,
    Key key,
  }) : super(key: key);

  final String iconName;
  final String label;
  final bool isDisabled;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: allBorderRadius12,
          ),
          elevation: 0,
        ),
        icon: iconName != null
            ? SvgPicture.asset(
                iconName,
                width: 24,
                height: 24,
                color:
                    isDisabled ? Theme.of(context).disabledColor : whiteColor,
              )
            : const SizedBox.shrink(),
        label: Text(
          label.toUpperCase(),
          style: textBold14.copyWith(
            color: isDisabled ? Theme.of(context).disabledColor : whiteColor,
          ),
        ),
        onPressed: isDisabled ? null : onPressed,
      ),
    );
  }
}
