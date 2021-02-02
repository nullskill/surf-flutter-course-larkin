import 'package:flutter/material.dart';

import 'package:places/mocks.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/widgets/sight_card.dart';
import 'package:places/ui/widgets/message_box.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';

/// Экран избранных/посещенных интересных мест
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
        ? MessageBox(
            iconName: hasVisited ? AppIcons.emptyGo : AppIcons.emptyCard,
            title: visitingEmptyListText,
            message: hasVisited
                ? visitingVisitedEmptyListText
                : visitingWishToVisitEmptyListText,
          )
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
