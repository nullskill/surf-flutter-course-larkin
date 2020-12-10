import 'package:flutter/material.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/sized_boxes.dart';
import 'package:places/mocks.dart';

class SightDetails extends StatelessWidget {
  final sight = mocks.last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: placeholderColorPurple,
              height: 360.0,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sight.name,
                    style: textBold24.copyWith(height: 1.2),
                  ),
                  verticalBox2,
                  Row(
                    children: [
                      Text(
                        sight.type,
                        style: textBold14.copyWith(height: 1.3),
                      ),
                      horizontalBox16,
                      Text(
                        sightDetailsClosed,
                        style: textRegular14.copyWith(
                            height: 1.3, color: textColorPrimary),
                      ),
                    ],
                  ),
                  verticalBox24,
                  Text(
                    sight.details,
                    style: textRegular14.copyWith(height: 1.3),
                  ),
                  verticalBox24,
                  Container(
                    height: 48.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: buttonBorderRadius,
                      color: buttonColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DummyIcon(
                          color: white,
                        ),
                        horizontalBox10,
                        Text(
                          sightDetailsShowRoute.toUpperCase(),
                          style: textBold14.copyWith(color: white),
                        ),
                      ],
                    ),
                  ),
                  verticalBox24,
                  Container(
                    width: double.infinity,
                    height: 1.0,
                    color: textColorSecondary,
                  ),
                  verticalBox8,
                  Row(
                    children: [
                      FlexibleButton(
                        title: sightDetailsPlan,
                      ),
                      FlexibleButton(
                        title: sightDetailsAddToFavorites,
                        primary: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlexibleButton extends StatelessWidget {
  final String title;
  final bool primary;

  const FlexibleButton({
    Key key,
    this.title,
    this.primary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color =
        primary ? titleColorPrimary : textColorSecondary.withOpacity(.56);
    return Flexible(
      flex: 1,
      child: Container(
        height: 40.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DummyIcon(
              color: color,
            ),
            horizontalBox10,
            Text(
              title,
              style: textRegular14.copyWith(height: 1.3, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class DummyIcon extends StatelessWidget {
  final Color color;

  const DummyIcon({
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 18,
      color: color,
    );
  }
}
