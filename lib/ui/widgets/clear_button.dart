import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/colors.dart';

/// Виджет кнопки очистки/удаления
class ClearButton extends StatelessWidget {
  const ClearButton({
    @required this.onTap,
    this.isBig = false,
    this.isDeletion = false,
    Key key,
  }) : super(key: key);

  final bool isBig;
  final bool isDeletion;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        AppIcons.clear,
        width: !isBig ? 24.0 : 40.0,
        height: !isBig ? 24.0 : 40.0,
        color: isDeletion ? whiteColor : Theme.of(context).primaryColor,
      ),
    );
  }
}
