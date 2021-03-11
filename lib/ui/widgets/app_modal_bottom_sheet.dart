import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:places/ui/res/border_radiuses.dart';

class AppModalBottomSheet extends StatelessWidget {
  const AppModalBottomSheet({
    @required this.child,
    this.backgroundColor,
    Key key,
  }) : super(key: key);

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 40.0;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: Material(
          color: backgroundColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: topBorderRadius12,
          child: child,
        ),
      ),
    );
  }
}

Future<T> showAppModalBottomSheet<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  Color backgroundColor,
}) async {
  final result = await showCustomModalBottomSheet<T>(
      context: context,
      builder: builder,
      containerWidget: (_, animation, child) => AppModalBottomSheet(
            child: child,
          ),
      expand: false);

  return result;
}
