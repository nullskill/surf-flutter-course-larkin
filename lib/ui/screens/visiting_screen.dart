import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/mocks.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/widgets/sight_card.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';

class VisitingScreen extends StatefulWidget {
  @override
  _VisitingScreenState createState() => _VisitingScreenState();
}

class _VisitingScreenState extends State<VisitingScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: _VisitingScreenAppBar(),
        body: TabBarView(
          children: [
            _VisitingScreenList(),
            _VisitingScreenList(hasVisited: true),
          ],
        ),
        bottomNavigationBar: AppBottomNavigationBar(
          currentIndex: 2,
        ),
      ),
    );
  }
}

class _VisitingScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  _VisitingScreenAppBar({
    Key key,
  }) : super(key: key);

  final Size preferredSize = Size.fromHeight(108.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        visitingAppBarTitle,
        style: textMedium18.copyWith(
          color: Theme.of(context).primaryColor,
          height: lineHeight1_3,
        ),
      ),
      bottom: _AppBarBottom(),
    );
  }
}

class _AppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  _AppBarBottom({
    Key key,
  }) : super(key: key);

  final Size preferredSize = Size.fromHeight(52.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 6.0,
      ),
      height: 40.0,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: allBorderRadius40,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: TabBar(
          tabs: [
            Tab(
              text: visitingWishToVisitTabText,
            ),
            Tab(
              text: visitingVisitedTabText,
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitingScreenList extends StatelessWidget {
  const _VisitingScreenList({
    Key key,
    this.hasVisited = false,
  }) : super(key: key);

  static const pxl16 = 16.0;
  final bool hasVisited;

  @override
  Widget build(BuildContext context) {
    var sights = hasVisited ? visitedMocks : favoriteMocks;
    return sights.isEmpty
        ? _EmptyList(hasVisited: hasVisited)
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(pxl16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var sight in sights) ...[
                    SightCard(sight: sight),
                    SizedBox(
                      height: pxl16,
                    ),
                  ],
                ],
              ),
            ),
          );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({
    Key key,
    @required this.hasVisited,
  }) : super(key: key);

  static const pxl64 = 64.0;
  final bool hasVisited;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          hasVisited ? AppIcons.emptyGo : AppIcons.emptyCard,
          width: pxl64,
          height: pxl64,
          color: inactiveColor,
        ),
        SizedBox(
          height: 24.0,
        ),
        Text(
          visitingEmptyListText,
          style: textMedium18.copyWith(
            color: inactiveColor,
            height: lineHeight1_3,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          width: 253.5,
          child: Text(
            hasVisited
                ? visitingVisitedEmptyListText
                : visitingWishToVisitEmptyListText,
            style: textRegular14.copyWith(
              color: inactiveColor,
              height: lineHeight1_3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
