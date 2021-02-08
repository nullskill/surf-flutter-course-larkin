import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/mocks.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/widgets/sight_card.dart';
import 'package:places/ui/widgets/message_box.dart';
import 'package:places/ui/widgets/app_dismissible.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';

/// Экран избранных/посещенных интересных мест
class VisitingScreen extends StatefulWidget {
  @override
  _VisitingScreenState createState() => _VisitingScreenState();
}

class _VisitingScreenState extends State<VisitingScreen> {
  List _favoriteMocks = favoriteMocks;
  List _visitedMocks = visitedMocks;

  /// При удалении карточки из списка
  void onRemoveCard(hasVisited, sight) {
    setState(() {
      if (hasVisited)
        _visitedMocks.remove(sight);
      else
        _favoriteMocks.remove(sight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: _VisitingScreenAppBar(),
        body: TabBarView(
          children: [
            _VisitingScreenList(
              sights: _favoriteMocks,
              onRemoveCard: onRemoveCard,
            ),
            _VisitingScreenList(
              sights: _visitedMocks,
              hasVisited: true,
              onRemoveCard: onRemoveCard,
            ),
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
    @required this.sights,
    this.hasVisited = false,
    this.onRemoveCard,
  }) : super(key: key);

  final List sights;
  final bool hasVisited;
  final Function onRemoveCard;

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var sight in sights) ...[
                    AppDismissible(
                      key: ValueKey(sight.name),
                      direction: AppDismissDirection.endToStart,
                      onDismissed: (_) => onRemoveCard(hasVisited, sight),
                      background: _BackgroundCard(),
                      child: SightCard(
                        key: ValueKey(sight.name),
                        sight: sight,
                        onRemoveCard: () => onRemoveCard(hasVisited, sight),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                  ],
                ],
              ),
            ),
          );
  }
}

class _BackgroundCard extends StatelessWidget {
  const _BackgroundCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: ClipRRect(
        borderRadius: allBorderRadius16,
        child: Container(
          color: Theme.of(context).errorColor,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppIcons.bucket,
                    color: whiteColor,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Удалить",
                    style: textMedium12.copyWith(
                      color: whiteColor,
                      height: lineHeight1_3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
