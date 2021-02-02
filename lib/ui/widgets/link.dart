import 'package:flutter/material.dart';

import 'package:places/ui/res/text_styles.dart';

class Link extends StatelessWidget {
  const Link({
    Key key,
    @required this.label,
    @required this.onTap,
  }) : super(key: key);

  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 13.0),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: textMedium16.copyWith(
            color: Theme.of(context).buttonColor,
            height: lineHeight1_25,
          ),
        ),
      ),
    );
  }
}
