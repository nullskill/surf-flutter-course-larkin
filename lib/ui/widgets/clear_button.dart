import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/ui/res/assets.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        AppIcons.clear,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
