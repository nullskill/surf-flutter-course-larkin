import 'package:flutter/material.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/mocks.dart';

/// Экран отображения подробной информации о посещаемом месте.
class SightDetails extends StatelessWidget {
  final sight = mocks.last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SightDetailsAppBar(),
      body: _SightDetailsBody(sight: sight),
    );
  }
}

//Private widgets
class _SightDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Size preferredSize = Size.fromHeight(360.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: white,
          borderRadius: smallButtonBorderRadius,
        ),
        margin: const EdgeInsets.only(
          left: 16.0,
          top: 16.0,
        ),
        child: Icon(
          Icons.arrow_back_ios_rounded,
          color: iconColor,
        ),
      ),
      flexibleSpace: Align(
        alignment: Alignment.topLeft,
        child: _Gallery(),
      ),
      backgroundColor: placeholderColorPurple,
      elevation: 0,
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _SightDetailsBody extends StatelessWidget {
  const _SightDetailsBody({
    Key key,
    @required this.sight,
  }) : super(key: key);

  final sight;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                _CardLabel(sight: sight),
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
                _ShowRouteButton(),
                SizedBox(
                  height: 24,
                ),
                _CardMenu(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel({
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
              sightDetailsOpenHours,
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

class _ShowRouteButton extends StatelessWidget {
  const _ShowRouteButton({
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
          _DummyIcon(
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

class _CardMenu extends StatelessWidget {
  const _CardMenu({
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
            _FlexibleButton(
              title: sightDetailsPlan,
            ),
            _FlexibleButton(
              title: sightDetailsAddToFavorites,
              primary: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _FlexibleButton extends StatelessWidget {
  final String title;
  final bool primary;

  const _FlexibleButton({
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
            _DummyIcon(
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

class _DummyIcon extends StatelessWidget {
  final Color color;

  const _DummyIcon({
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