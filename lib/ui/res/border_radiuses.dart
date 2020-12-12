import 'package:flutter/painting.dart';

/// Радиусы границ

//Top
BorderRadius topBorderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16.0),
      topRight: const Radius.circular(16.0),
    ),

//Bottom
    bottomBorderRadius = BorderRadius.only(
      bottomLeft: const Radius.circular(16.0),
      bottomRight: const Radius.circular(16.0),
    ),

//Button
    smallButtonBorderRadius = const BorderRadius.all(Radius.circular(10.0)),
    largeButtonBorderRadius = const BorderRadius.all(Radius.circular(12.0));
