import 'package:flutter/material.dart';
import 'package:places/ui/res/app_color_scheme.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/text_styles.dart';

/// Виджет элемента настройки
class SettingsItem extends StatelessWidget {
  const SettingsItem({
    @required this.title,
    this.leading,
    this.trailing,
    this.paddingValue = 14.0,
    this.isDialog = false,
    this.isGreyedOut = false,
    this.isLast = false,
    this.onTap,
    Key key,
  }) : super(key: key);

  final String title;
  final Widget leading;
  final Widget trailing;
  final double paddingValue;
  final bool isDialog;
  final bool isGreyedOut;
  final bool isLast;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final Color textColor = isDialog
        ? Theme.of(context).colorScheme.appDialogLabelColor
        : isGreyedOut
            ? secondaryColor2
            : Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: paddingValue),
            child: Row(
              children: [
                leading ?? const SizedBox.shrink(),
                leading != null
                    ? const SizedBox(width: 8.0)
                    : const SizedBox.shrink(),
                Expanded(
                  child: Text(
                    title,
                    style: textRegular16.copyWith(
                      color: textColor,
                      height: lineHeight1_25,
                    ),
                  ),
                ),
                trailing ?? const SizedBox.shrink(),
              ],
            ),
          ),
          isLast ? const SizedBox() : const Divider(height: .8),
        ],
      ),
    );
  }
}
