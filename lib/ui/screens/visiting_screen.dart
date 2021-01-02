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
  final Function changeThemeMode;
  // Don't like this but since we haven't covered state architecture yet...
  VisitingScreen({@required this.changeThemeMode});

  @override
  _VisitingScreenState createState() =>
      _VisitingScreenState(changeThemeMode: changeThemeMode);
}

class _VisitingScreenState extends State<VisitingScreen> {
  final Function changeThemeMode;
  // Don't like this but since we haven't covered state architecture yet...
  _VisitingScreenState({@required this.changeThemeMode});

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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            changeThemeMode();
          },
          label: Text(
            "Switch Theme",
          ),
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
          height: 1.3,
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
        SvgPicture.asset(
          hasVisited ? AppIcons.go : AppIcons.card,
          width: 64,
          height: 64,
          color: inactiveColor,
        ),
        // Container(
        //   width: 64.0,
        //   height: 64.0,
        //   color: inactiveColor,
        // ),
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
