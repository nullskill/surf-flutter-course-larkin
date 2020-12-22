import 'package:flutter/material.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';

import 'package:places/mocks.dart';

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
        backgroundColor: whiteColor,
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
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        visitingAppBarTitle,
        style: textMedium18.copyWith(
          color: primaryColor,
          height: 1.3,
        ),
      ),
      elevation: 0,
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
        color: backgroundColor,
        borderRadius: allBorderRadius40,
      ),
      child: Theme(
        data: ThemeData(
          // removes ripple effect from inkwell inside tabs
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: TabBar(
          indicator: BoxDecoration(
            color: secondaryColor,
            borderRadius: allBorderRadius40,
          ),
          labelColor: whiteColor,
          unselectedLabelColor: inactiveColor,
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

  final bool hasVisited;

  @override
  Widget build(BuildContext context) {
    var sights = hasVisited ? visitedMocks : favoriteMocks;
    return sights.isEmpty
        ? _EmptyList(hasVisited: hasVisited)
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var sight in sights) ...[
                    SightCard(sight: sight),
                    SizedBox(
                      height: 16,
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

  final bool hasVisited;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64.0,
          height: 64.0,
          color: inactiveColor,
        ),
        SizedBox(
          height: 24.0,
        ),
        Text(
          visitingEmptyListText,
          style: textMedium18.copyWith(
            color: inactiveColor,
            height: 1.3,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          width: 253.5,
          child: Text(
            hasVisited
                ? visitingVisitedTabViewEmptyListText
                : visitingWishToVisitTabViewEmptyListText,
            style: textRegular14.copyWith(
              color: inactiveColor,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
