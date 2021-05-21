import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';

/// Виджет AppActionButton предоставляет кнопку возврата на предыдущий экран
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    this.onPressed,
    Key key,
  }) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 8.0,
        top: 12.0,
        bottom: 12.0,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(32.0, 32.0),
          padding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).canvasColor,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: allBorderRadius10),
        ),
        onPressed: onPressed ??
            () {
              Navigator.pop(context);
            },
        child: SvgPicture.asset(
          AppIcons.arrow,
          width: 24.0,
          height: 24.0,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
