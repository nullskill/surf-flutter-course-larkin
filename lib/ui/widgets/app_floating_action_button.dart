import 'package:flutter/material.dart';
import 'package:places/ui/res/app_color_scheme.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';

/// Виджет градиентной кнопки а-ля [FloatingActionButton.extended]
class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    @required this.label,
    @required this.onPressed,
    this.icon,
    Key key,
  }) : super(key: key);

  final Widget icon;
  final Widget label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: allBorderRadius50,
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(0.0, 4.0),
            blurRadius: 4.0,
            color: blackColor.withOpacity(.25),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.appPrimaryGradientColor,
            Theme.of(context).buttonColor,
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: allBorderRadius50,
        child: SizedBox(
          width: 177,
          height: 48.0,
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
      ),
    );
  }
}
