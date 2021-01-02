import 'package:flutter/material.dart';

import 'package:places/ui/res/text_styles.dart';

import 'package:places/ui/widgets/app_back_button.dart';

class FiltersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        actions: [
          Center(
            child: _ClearButton(),
          ),
        ],
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        print("_ClearButton pressed");
      },
      child: Text(
        "Очистить",
        style: textMedium16.copyWith(
          color: Theme.of(context).buttonColor,
          height: 1.25,
        ),
      ),
    );
  }
}
