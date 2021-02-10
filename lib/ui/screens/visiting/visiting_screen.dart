import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/domain/sight.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/screens/visiting/visiting_screen_helper.dart';

import 'package:places/ui/widgets/sight_card.dart';
import 'package:places/ui/widgets/message_box.dart';
import 'package:places/ui/widgets/app_dismissible.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';

/// Экран избранных/посещенных интересных мест
class VisitingScreen extends StatefulWidget {
  @override
  _VisitingScreenState createState() => _VisitingScreenState();
}

class _VisitingScreenState extends State<VisitingScreen>
    with VisitingScreenHelper {
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
              sights: getFavoriteMocks,
              isDrag: isDrag,
              onDragCardStarted: onDragCardStarted,
              onDragCardEnd: onDragCardEnd,
              onRemoveCard: onRemoveCard,
              swapCards: swapCards,
            ),
            _VisitingScreenList(
              sights: getVisitedMocks,
              isDrag: isDrag,
              hasVisited: true,
              onDragCardStarted: onDragCardStarted,
              onDragCardEnd: onDragCardEnd,
              onRemoveCard: onRemoveCard,
              swapCards: swapCards,
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
    this.isDrag = false,
    @required this.onDragCardStarted,
    @required this.onDragCardEnd,
    @required this.onRemoveCard,
    @required this.swapCards,
  }) : super(key: key);

  final List sights;
  final bool hasVisited;
  final bool isDrag;
  final Function onDragCardStarted;
  final Function onDragCardEnd;
  final Function onRemoveCard;
  final Function swapCards;

  @override
  // ignore: long-method
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
                  _DragTarget(
                    index: 0,
                    hasVisited: hasVisited,
                    onRemoveCard: onRemoveCard,
                    swapCards: swapCards,
                  ),
                  for (var sight in sights) ...[
                    _Draggable(
                      sight: sight,
                      hasVisited: hasVisited,
                      isDrag: isDrag,
                      onDragCardStarted: onDragCardStarted,
                      onDragCardEnd: onDragCardEnd,
                      onRemoveCard: onRemoveCard,
                    ),
                    _DragTarget(
                      index: sights.indexOf(sight),
                      hasVisited: hasVisited,
                      onRemoveCard: onRemoveCard,
                      swapCards: swapCards,
                    ),
                    // SizedBox(
                    //   height: 16.0,
                    // ),
                  ],
                ],
              ),
            ),
          );
  }
}

class _DragTarget extends StatelessWidget {
  const _DragTarget({
    Key key,
    @required this.index,
    @required this.hasVisited,
    @required this.onRemoveCard,
    @required this.swapCards,
  }) : super(key: key);

  final int index;
  final bool hasVisited;
  final Function onRemoveCard;
  final Function swapCards;

  @override
  Widget build(BuildContext context) {
    return DragTarget<FavoriteSight>(
      onAccept: (data) {
        // ignore: prefer-trailing-comma
        swapCards(hasVisited, data, index);
      },
      builder: (
        BuildContext context,
        List<dynamic> candidateData,
        List<dynamic> rejectedData,
      ) {
        if (candidateData.isEmpty)
          return SizedBox(
            height: 16,
            width: double.infinity,
          );

        return _DismissibleCard(
          sight: candidateData.first,
          hasVisited: hasVisited,
          onRemoveCard: onRemoveCard,
        );
      },
    );
  }
}

class _Draggable extends StatelessWidget {
  const _Draggable({
    Key key,
    @required this.sight,
    @required this.hasVisited,
    @required this.isDrag,
    @required this.onDragCardStarted,
    @required this.onDragCardEnd,
    @required this.onRemoveCard,
  }) : super(key: key);

  final dynamic sight;
  final bool hasVisited;
  final bool isDrag;
  final Function onDragCardStarted;
  final Function onDragCardEnd;
  final Function onRemoveCard;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<FavoriteSight>(
      data: sight,
      axis: Axis.vertical,
      childWhenDragging: SizedBox.shrink(),
      feedback: Container(
        height: 100,
        width: MediaQuery.of(context).size.width - 32.0,
        decoration: BoxDecoration(
          color: placeholderColor,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(sight.url),
          ),
          borderRadius: allBorderRadius16,
        ),
      ),
      onDragStarted: () => onDragCardStarted,
      onDragEnd: (_) => onDragCardEnd,
      child: isDrag
          ? SizedBox.shrink()
          : _DismissibleCard(
              sight: sight,
              hasVisited: hasVisited,
              onRemoveCard: onRemoveCard,
            ),
    );
  }
}

class _DismissibleCard extends StatelessWidget {
  const _DismissibleCard({
    Key key,
    @required this.sight,
    @required this.hasVisited,
    @required this.onRemoveCard,
  }) : super(key: key);

  final dynamic sight;
  final bool hasVisited;
  final Function onRemoveCard;

  @override
  Widget build(BuildContext context) {
    return AppDismissible(
      key: ValueKey(sight.name),
      direction: AppDismissDirection.endToStart,
      onDismissed: (_) => onRemoveCard(hasVisited, sight),
      background: _BackgroundCard(),
      child: SightCard(
        key: ValueKey(sight.name),
        sight: sight,
        onRemoveCard: () => onRemoveCard(hasVisited, sight),
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
    return ClipRRect(
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
    );
  }
}
