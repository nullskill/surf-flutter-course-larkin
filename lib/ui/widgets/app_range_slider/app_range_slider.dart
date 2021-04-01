import 'package:flutter/material.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/widgets/app_range_slider/app_range_slider_helper.dart';

/// Виджет для отображения слайдера с выбором диапазона "от и до"
class AppRangeSlider extends StatelessWidget {
  const AppRangeSlider({
    @required this.currentRangeValues,
    @required this.setRangeValues,
    Key key,
  }) : super(key: key);

  final RangeValues currentRangeValues;
  final void Function(RangeValues) setRangeValues;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              filtersDistanceTitle,
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
        const SizedBox(height: 24.0),
        RangeSlider(
            divisions: AppRangeSliderHelper.divisions,
            min: AppRangeSliderHelper.minValue,
            max: AppRangeSliderHelper.maxValue,
            values: currentRangeValues,
            onChanged: setRangeValues),
      ],
    );
  }
}
