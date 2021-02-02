import 'package:flutter/material.dart';

import 'package:places/ui/res/app_color_scheme.dart';

/// Виджет градиентной кнопки а-ля [FloatingActionButton.extended]
class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    Key key,
    this.icon,
    @required this.label,
    @required this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final Widget label;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 177,
        height: 48.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.appPrimaryGradientColor,
              Theme.of(context).buttonColor,
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: icon == null
                    ? <Widget>[
                        const SizedBox(width: 20.0),
                        label,
                        const SizedBox(width: 20.0),
                      ]
                    : <Widget>[
                        const SizedBox(width: 16.0),
                        icon,
                        const SizedBox(width: 8.0),
                        label,
                        const SizedBox(width: 20.0),
                      ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
