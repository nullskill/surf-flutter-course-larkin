import 'package:flutter/material.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/mocks.dart';

class SightDetails extends StatelessWidget {
  static const appBarHeight = 360.0;
  final sight = mocks.last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: placeholderColorPurple,
        shadowColor: Colors.transparent,
        toolbarHeight: appBarHeight,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: SizedBox(
            height: appBarHeight,
            width: double.infinity,
            child: Gallery(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardLabel(sight: sight),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    sight.details,
                    style: textRegular14.copyWith(height: 1.3),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  ShowRouteButton(),
                  SizedBox(
                    height: 24,
                  ),
                  CardMenu(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Gallery extends StatelessWidget {
  const Gallery({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: white,
            borderRadius: smallButtonBorderRadius,
          ),
          margin: const EdgeInsets.only(
            left: 16.0,
            top: 12.0,
          ),
        ),
      ),
    );
  }
}

class CardLabel extends StatelessWidget {
  const CardLabel({
    Key key,
    @required this.sight,
  }) : super(key: key);

  final sight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          sight.name,
          style: textBold24.copyWith(height: 1.2),
        ),
        SizedBox(
          height: 2,
        ),
        Row(
          children: [
            Text(
              sight.type,
              style: textBold14.copyWith(height: 1.3),
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              sightDetailsClosed,
              style: textRegular14.copyWith(
                height: 1.3,
                color: textColorPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ShowRouteButton extends StatelessWidget {
  const ShowRouteButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: largeButtonBorderRadius,
        color: buttonColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DummyIcon(
            color: white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            sightDetailsShowRoute.toUpperCase(),
            style: textBold14.copyWith(color: white),
          ),
        ],
      ),
    );
  }
}

class CardMenu extends StatelessWidget {
  const CardMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1.0,
          color: textColorSecondary,
        ),
        SizedBox(
          height: 8,
        ),
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
            SizedBox(
              width: 10,
            ),
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
