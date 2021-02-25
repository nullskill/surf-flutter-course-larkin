import 'package:flutter/painting.dart';
import 'package:places/ui/res/colors.dart';

/// Стили текстов
TextStyle _text = const TextStyle(
      fontStyle: FontStyle.normal,
      fontFamily: "Roboto",
      color: secondaryColor,
    ),

//Light
    textLight = _text.copyWith(fontWeight: FontWeight.w300),

//Regular
    textRegular = _text.copyWith(fontWeight: FontWeight.w400),
    textRegular12 = textRegular.copyWith(fontSize: 12.0),
    textRegular14 = textRegular.copyWith(fontSize: 14.0),
    textRegular16 = textRegular.copyWith(fontSize: 16.0),

//Medium
    textMedium = _text.copyWith(fontWeight: FontWeight.w500),
    textMedium12 = textMedium.copyWith(fontSize: 12.0),
    textMedium16 = textMedium.copyWith(fontSize: 16.0),
    textMedium18 = textMedium.copyWith(fontSize: 18.0),

//Bold
    textBold = _text.copyWith(fontWeight: FontWeight.bold),
    textBold14 = textBold.copyWith(fontSize: 14.0),
    textBold24 = textBold.copyWith(fontSize: 24.0),
    textBold32 = textBold.copyWith(fontSize: 32.0);

/// Высоты строк
const lineHeight1_1 = 1.1,
    lineHeight1_2 = 1.2,
    lineHeight1_25 = 1.25,
    lineHeight1_3 = 1.3,
    lineHeight1_5 = 1.5;
