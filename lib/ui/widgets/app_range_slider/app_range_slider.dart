import 'package:flutter/material.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';

import 'package:places/ui/widgets/app_range_slider/app_range_slider_helper.dart';

/// Виджет для отображения слайдера с выбором диапазона "от и до"
class AppRangeSlider extends StatefulWidget {
  const AppRangeSlider({
    Key key,
  }) : super(key: key);

  @override
  _AppRangeSliderState createState() => _AppRangeSliderState();
}

class _AppRangeSliderState extends State<AppRangeSlider> {
  static const _minValue = AppRangeSliderHelper.minValue;
  static const _maxValue = AppRangeSliderHelper.maxValue;
  RangeValues _currentValues = RangeValues(_minValue, _maxValue);

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
              AppRangeSliderHelper.getRangeDescription(_currentValues),
              style: textRegular16.copyWith(
                color: secondaryColor2,
                height: 1.25,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 24.0,
        ),
        RangeSlider(
          divisions: AppRangeSliderHelper.divisions,
          min: _minValue,
          max: _maxValue,
          values: _currentValues,
          onChanged: (newValues) {
            setState(() {
              _currentValues = newValues;
            });
          },
        ),
      ],
    );
  }
}
