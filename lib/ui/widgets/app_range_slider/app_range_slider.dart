import 'package:flutter/material.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';

import 'package:places/ui/widgets/app_range_slider/app_range_slider_helper.dart';
import 'package:places/ui/screens/filters_screen/filters_screen.dart';

/// Виджет для отображения слайдера с выбором диапазона "от и до"
class AppRangeSlider extends StatelessWidget {
  const AppRangeSlider({this.currentRangeValues});

  static const _minValue = AppRangeSliderHelper.minValue;
  static const _maxValue = AppRangeSliderHelper.maxValue;
  final currentRangeValues;

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
                height: lineHeight1_25,
              ),
            ),
            Text(
              AppRangeSliderHelper.getRangeDescription(currentRangeValues),
              style: textRegular16.copyWith(
                color: secondaryColor2,
                height: lineHeight1_25,
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
          values: currentRangeValues,
          onChanged: (newValues) {
            FiltersScreen.of(context).setRangeValues(newValues);
          },
        ),
      ],
    );
  }
}
