import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/visited_sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/app_dismissible.dart';
import 'package:places/ui/widgets/message_box.dart';
import 'package:places/ui/widgets/sight_card/sight_card.dart';

/// Экран избранных/посещенных интересных мест
// ignore: use_key_in_widget_constructors
class VisitingScreen extends StatefulWidget {
  @override
  _VisitingScreenState createState() => _VisitingScreenState();
}

class _VisitingScreenState extends State<VisitingScreen> {
  final List<FavoriteSight> _favoriteMocks = favoriteMocks;
  final List<VisitedSight> _visitedMocks = visitedMocks;
  bool isDrag = false;

  List get getFavoriteMocks => _favoriteMocks;

  List get getVisitedMocks => _visitedMocks;

  /// При удалении карточки из списка
  void onRemoveCard<T extends Sight>(T sight) {
    setState(() {
      if (sight.runtimeType is VisitedSight) {
        _visitedMocks.remove(sight);
      } else {
        _favoriteMocks.remove(sight);
      }
    });
  }

  /// При начале перетаскивания карточки
  void onDragCardStarted() {
    setState(() {
      isDrag = true;
    });
  }

  /// При окончании перетаскивания карточки
  void onDragCardEnd() {
    setState(() {
      isDrag = false;
    });
  }

  /// Меняет индекс карточки [sight] в списке на [index]
  void swapCards<T extends Sight>(T sight, int index) {
    setState(() {
      if (sight.runtimeType is VisitedSight) {
        _visitedMocks
          ..remove(sight)
          ..insert(index, (sight as VisitedSight));
      } else {
        _favoriteMocks
          ..remove(sight)
          ..insert(index, (sight as FavoriteSight));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const _VisitingScreenAppBar(),
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
        bottomNavigationBar: const AppBottomNavigationBar(
          currentIndex: 2,
        ),
      ),
    );
  }
}

class _VisitingScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _VisitingScreenAppBar({
    Key key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(108.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        visitingAppBarTitle,
        style: textMedium18.copyWith(
          color: Theme.of(context).primaryColor,
          height: lineHeight1_3,
        ),
      ),
      bottom: const _AppBarBottom(),
    );
  }
}

class _AppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  const _AppBarBottom({
    Key key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(52.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
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
        child: const TabBar(
          tabs: [
            Tab(text: visitingWishToVisitTabText),
            Tab(text: visitingVisitedTabText),
          ],
        ),
      ),
    );
  }
}

class _VisitingScreenList<T extends Sight> extends StatelessWidget {
  const _VisitingScreenList({
    @required this.sights,
    @required this.onDragCardStarted,
    @required this.onDragCardEnd,
    @required this.onRemoveCard,
    @required this.swapCards,
    this.hasVisited = false,
    this.isDrag = false,
    Key key,
  }) : super(key: key);

  final List sights;
  final bool hasVisited;
  final bool isDrag;
  final void Function() onDragCardStarted;
  final void Function() onDragCardEnd;
  final void Function(Sight) onRemoveCard;
  final void Function(Sight, int) swapCards;

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
        : ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _DragTarget(
                index: 0,
                hasVisited: hasVisited,
                onRemoveCard: onRemoveCard,
                swapCards: swapCards,
              ),
              for (var sight in sights) ...[
                _Draggable<T>(
                  sight: sight as T,
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
          );
  }
}

class _DragTarget extends StatelessWidget {
  const _DragTarget({
    @required this.index,
    @required this.hasVisited,
    @required this.onRemoveCard,
    @required this.swapCards,
    Key key,
  }) : super(key: key);

  final int index;
  final bool hasVisited;
  final void Function(Sight) onRemoveCard;
  final void Function(Sight, int) swapCards;

  @override
  Widget build(BuildContext context) {
    return DragTarget<FavoriteSight>(
      onAccept: (data) {
        // ignore: prefer-trailing-comma
        swapCards(data, index);
      },
      builder: (
        context,
        candidateData,
        rejectedData,
      ) {
        if (candidateData.isEmpty) {
          return const SizedBox(
            height: 16,
            width: double.infinity,
          );
        }

        return _DismissibleCard(
          sight: candidateData.first,
          hasVisited: hasVisited,
          onRemoveCard: onRemoveCard,
        );
      },
    );
  }
}

class _Draggable<T extends Sight> extends StatelessWidget {
  const _Draggable({
    @required this.sight,
    @required this.hasVisited,
    @required this.isDrag,
    @required this.onDragCardStarted,
    @required this.onDragCardEnd,
    @required this.onRemoveCard,
    Key key,
  }) : super(key: key);

  final T sight;
  final bool hasVisited;
  final bool isDrag;
  final void Function() onDragCardStarted;
  final void Function() onDragCardEnd;
  final void Function(Sight) onRemoveCard;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<T>(
      data: sight,
      axis: Axis.vertical,
      childWhenDragging: const SizedBox.shrink(),
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
          ? const SizedBox.shrink()
          : _DismissibleCard(
              sight: sight,
              hasVisited: hasVisited,
              onRemoveCard: onRemoveCard,
            ),
    );
  }
}

class _DismissibleCard<T extends Sight> extends StatelessWidget {
  const _DismissibleCard({
    @required this.sight,
    @required this.hasVisited,
    @required this.onRemoveCard,
    Key key,
  }) : super(key: key);

  final T sight;
  final bool hasVisited;
  final void Function(Sight) onRemoveCard;

  @override
  Widget build(BuildContext context) {
    return AppDismissible(
      key: ValueKey<String>(sight.name),
      direction: AppDismissDirection.endToStart,
      onDismissed: (_) => onRemoveCard(sight),
      background: const _CardBackground(),
      child: SightCard(
        key: ValueKey<String>(sight.name),
        sight: sight,
        onRemoveCard: () => onRemoveCard(sight),
      ),
    );
  }
}

class _CardBackground extends StatelessWidget {
  const _CardBackground({
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
                const SizedBox(height: 10.0),
                Text(
                  visitingDeleteCardLabel,
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
