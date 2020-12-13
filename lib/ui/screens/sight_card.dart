import 'package:flutter/material.dart';

import 'package:places/domain/sight.dart';

import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/border_radiuses.dart';

class SightCard extends StatelessWidget {
  final Sight sight;

  const SightCard({Key key, this.sight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        height: 188.0,
        width: 328.0,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: topBorderRadius,
                color: placeholderColorPurple,
              ),
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              height: 96.0,
              child: Stack(
                children: [
                  Text(
                    sight.type,
                    style: textBold14.copyWith(color: white),
                  ),
                  Positioned(
                    top: 3,
                    right: 2,
                    child: Container(
                      width: 20,
                      height: 18,
                      color: white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: bottomBorderRadius,
                color: cardColor,
              ),
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              height: 92.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sight.name,
                    style: textMedium16.copyWith(
                      height: 1.25,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    sight.details,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textRegular14.copyWith(
                      height: 1.3,
                      color: textColorPrimary,
                    ),
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
