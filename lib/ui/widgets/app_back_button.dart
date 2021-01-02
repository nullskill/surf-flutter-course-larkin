import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/custom_color_scheme.dart';
import 'package:places/ui/res/assets.dart';

/// Виджет AppActionButton предоставляет кнопку возврата на предыдущий экран
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 8,
        top: 12,
        bottom: 12,
      ),
      child: FlatButton(
        height: 32,
        minWidth: 32,
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: Theme.of(context).colorScheme.appBackButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: allBorderRadius10,
        ),
        onPressed: () {
          print("AppBackButton pressed");
        },
        child: SvgPicture.asset(
          AppIcons.arrow,
          width: 24,
          height: 24,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
