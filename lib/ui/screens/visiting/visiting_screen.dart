import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/visited_sight.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/visiting/visiting_wm.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/app_dismissible.dart';
import 'package:places/ui/widgets/app_tab_bar.dart';
import 'package:places/ui/widgets/circular_progress.dart';
import 'package:places/ui/widgets/message_box.dart';
import 'package:places/ui/widgets/sight_card/sight_card.dart';
import 'package:relation/relation.dart';

/// Экран избранных/посещенных интересных мест
class VisitingScreen extends CoreMwwmWidget {
  const VisitingScreen({
    @required WidgetModelBuilder wmBuilder,
    Key key,
  })  : assert(wmBuilder != null),
        super(widgetModelBuilder: wmBuilder, key: key);

  @override
  _VisitingScreenState createState() => _VisitingScreenState();
}

class _VisitingScreenState extends WidgetState<VisitingWidgetModel>
    with SingleTickerProviderStateMixin {
  static const tabDelay = Duration(milliseconds: 350);
  static const linearCurve = Interval(0.003, 1.0);

  AppTabController tabController;
  List<Tab> visitingTabs;

  @override
  void initState() {
    super.initState();

    visitingTabs = <Tab>[
      const Tab(text: visitingWishToVisitTabText),
      const Tab(text: visitingVisitedTabText),
    ];
    tabController = AppTabController(
      vsync: this,
      length: visitingTabs.length,
      duration: tabDelay,
      curve: linearCurve,
    );
    tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  void _handleTabSelection() {
    if (tabController.index == 1) {
      wm.loadVisitedSightsAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _VisitingScreenAppBar(
        tabs: visitingTabs,
        tabController: tabController,
        wm: wm,
      ),
      body: AppTabBarView(
        controller: tabController,
        children: [
          EntityStateBuilder<List<FavoriteSight>>(
            streamedState: wm.favoritesState,
            child: (context, favorites) {
              return _VisitingScreenList(
                sights: favorites,
                onRemoveCard: wm.removeFromVisitingAction,
              );
            },
            loadingChild: Center(
              child: CircularProgress(
                primaryColor: secondaryColor2,
                secondaryColor: Theme.of(context).backgroundColor,
              ),
            ),
          ),
          EntityStateBuilder<List<VisitedSight>>(
            streamedState: wm.visitedState,
            child: (context, visited) {
              return _VisitingScreenList(
                sights: visited,
                hasVisited: true,
                onRemoveCard: wm.removeFromVisitingAction,
              );
            },
            loadingChild: Center(
              child: CircularProgress(
                primaryColor: secondaryColor2,
                secondaryColor: Theme.of(context).backgroundColor,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
    );
  }
}

class _VisitingScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _VisitingScreenAppBar({
    @required this.tabs,
    @required this.tabController,
    @required this.wm,
    Key key,
  }) : super(key: key);

  final List<Tab> tabs;
  final TabController tabController;
  final VisitingWidgetModel wm;

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
      bottom: _AppBarBottom(
        tabs: tabs,
        tabController: tabController,
        wm: wm,
      ),
    );
  }
}

class _AppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  const _AppBarBottom({
    @required this.tabs,
    @required this.tabController,
    @required this.wm,
    Key key,
  }) : super(key: key);

  final List<Tab> tabs;
  final TabController tabController;
  final VisitingWidgetModel wm;

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
        child: TabBar(controller: tabController, tabs: tabs),
      ),
    );
  }
}

class _VisitingScreenList extends StatelessWidget {
  const _VisitingScreenList({
    @required this.sights,
    @required this.onRemoveCard,
    this.hasVisited = false,
    Key key,
  }) : super(key: key);

  final List<Sight> sights;
  final bool hasVisited;
  final void Function(Sight) onRemoveCard;

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
        : ReorderableListView.builder(
            padding: const EdgeInsets.all(16.0),
            proxyDecorator: proxyDecorator,
            onReorder: onReorder,
            itemCount: sights.length,
            itemBuilder: (_, index) {
              final Sight sight = sights[index];

              return _DismissibleCard(
                key: ValueKey<int>(sight.id),
                sight: sight,
                hasVisited: hasVisited,
                onRemoveCard: onRemoveCard,
              );
            },
          );
  }

  // ignore: avoid-returning-widgets
  Widget proxyDecorator(Widget child, int index, Animation animation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Material(
        borderRadius: allBorderRadius16,
        elevation: 6.0,
        child: SightCard(sight: sights[index]),
      ),
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    final int index = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final swappingCard = sights.removeAt(oldIndex);

    sights.insert(index, swappingCard);
  }
}

class _DismissibleCard extends StatefulWidget {
  const _DismissibleCard({
    @required this.sight,
    @required this.hasVisited,
    @required this.onRemoveCard,
    Key key,
  }) : super(key: key);

  static const Duration resizeDuration = Duration(milliseconds: 350);

  final Sight sight;
  final bool hasVisited;
  final void Function(Sight) onRemoveCard;

  @override
  _DismissibleCardState createState() => _DismissibleCardState();
}

class _DismissibleCardState extends State<_DismissibleCard> {
  double resizeValue;

  @override
  void initState() {
    super.initState();

    resizeValue = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDismissible(
          key: widget.key,
          direction: AppDismissDirection.endToStart,
          onResize: (value) {
            setState(() {
              resizeValue = value;
            });
          },
          onDismissed: (_) => widget.onRemoveCard(widget.sight),
          background: _CardBackground(
            resizeValue: resizeValue,
            duration: _DismissibleCard.resizeDuration,
          ),
          child: SightCard(sight: widget.sight),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }
}

class _CardBackground extends StatelessWidget {
  const _CardBackground({
    @required this.resizeValue,
    @required this.duration,
    Key key,
  }) : super(key: key);

  final double resizeValue;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: Theme.of(context).errorColor,
        borderRadius: resizeValue == 1.0
            ? allBorderRadius18
            : allBorderRadius18 * (resizeValue - 0.3),
      ),
      duration: duration,
      child: resizeValue < 0.5
          ? const SizedBox.shrink()
          : Align(
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
    );
  }
}
