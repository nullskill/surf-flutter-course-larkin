import 'package:flutter/material.dart';
import 'package:places/ui/res/colors.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';

import 'package:places/ui/widgets/app_back_button.dart';
import 'package:places/ui/widgets/action_button.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Column(
            children: [
              _DistanceBlock(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: ActionButton(
          label: filtersScreenActionButtonLabel,
        ),
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
        filtersScreenClearButtonLabel,
        style: textMedium16.copyWith(
          color: Theme.of(context).buttonColor,
          height: 1.25,
        ),
      ),
    );
  }
}

class _DistanceBlock extends StatefulWidget {
  const _DistanceBlock({
    Key key,
  }) : super(key: key);

  @override
  __DistanceBlockState createState() => __DistanceBlockState();
}

class __DistanceBlockState extends State<_DistanceBlock> {
  static const _minValue = 100.0;
  static const _maxValue = 10000.0;
  double _currentValue = _minValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              filtersScreenDistanceTitle,
              style: textMedium16.copyWith(
                color: Theme.of(context).primaryColor,
                height: 1.25,
              ),
            ),
            Text(
              "от 10 до 30 км",
              style: textRegular16.copyWith(
                color: secondaryColor2,
                height: 1.25,
              ),
            ),
          ],
        ),
        Slider(
          divisions: 100,
          min: _minValue,
          max: _maxValue,
          value: _currentValue,
          onChanged: (newValue) {
            setState(() {
              _currentValue = newValue;
            });
          },
        ),
      ],
    );
  }
}
