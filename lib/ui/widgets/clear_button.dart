import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/assets.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({
    Key key,
    @required this.onTap,
    this.isBig = false,
    this.isDeletion = false,
  }) : super(key: key);

  final bool isBig;
  final bool isDeletion;
  final Function onTap;

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
