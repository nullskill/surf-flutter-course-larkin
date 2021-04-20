import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/bloc/visiting/visiting_bloc.dart';
import 'package:places/bloc/visiting/visiting_event.dart';
import 'package:places/bloc/visiting/visiting_state.dart';
import 'package:places/data/repository/visiting_repository.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/visited_sight.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/app_dismissible.dart';
import 'package:places/ui/widgets/circular_progress.dart';
import 'package:places/ui/widgets/message_box.dart';
import 'package:places/ui/widgets/sight_card/sight_card.dart';

/// Экран избранных/посещенных интересных мест
class VisitingScreen extends StatefulWidget {
  const VisitingScreen({Key key}) : super(key: key);

  @override
  _VisitingScreenState createState() => _VisitingScreenState();
}

class _VisitingScreenState extends State<VisitingScreen> {
  VisitingBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = VisitingBloc(context.read<VisitingRepository>())
      ..add(VisitingLoadEvent());
  }

  /// Удаляет карточку из списка избранных/посещенных мест
  void removeFromVisiting<T extends Sight>(T sight) {
    if (sight is FavoriteSight) {
      bloc.add(VisitingRemoveFromFavoritesEvent(sight));
    } else if (sight is VisitedSight) {
      bloc.add(VisitingRemoveFromVisitedEvent(sight));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const _VisitingScreenAppBar(),
        body: TabBarView(
          children: [
            BlocBuilder<VisitingBloc, VisitingState>(
                bloc: bloc,
                builder: (_, state) {
                  if (state is VisitingLoadInProgress) {
                    return Center(
                      child: CircularProgress(
                        size: 40.0,
                        primaryColor: secondaryColor2,
                        secondaryColor: Theme.of(context).backgroundColor,
                      ),
                    );
                  }
                  if (state is VisitingLoadSuccess) {
                    return _VisitingScreenList(
                      sights: state.favoriteSights,
                      onRemoveCard: removeFromVisiting,
                    );
                  }
                  throw ArgumentError('Wrong state in _VisitingScreenState');
                }),
            BlocBuilder<VisitingBloc, VisitingState>(
                bloc: bloc,
                builder: (_, state) {
                  if (state is VisitingLoadInProgress) {
                    return Center(
                      child: CircularProgress(
                        size: 40.0,
                        primaryColor: secondaryColor2,
                        secondaryColor: Theme.of(context).backgroundColor,
                      ),
                    );
                  }
                  if (state is VisitingLoadSuccess) {
                    return _VisitingScreenList(
                      sights: state.visitedSights,
                      hasVisited: true,
                      onRemoveCard: removeFromVisiting,
                    );
                  }
                  throw ArgumentError('Wrong state in _VisitingScreenState');
                }),
          ],
        ),
        bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
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
    @required this.onRemoveCard,
    this.hasVisited = false,
    Key key,
  }) : super(key: key);

  final List<T> sights;
  final bool hasVisited;
  final void Function<T extends Sight>(T) onRemoveCard;

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
              final T sight = sights[index];
              return _DismissibleCard<T>(
                key: ValueKey<int>(sight.id),
                sight: sight,
                hasVisited: hasVisited,
                onRemoveCard: onRemoveCard,
              );
            },
          );
  }

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

class _DismissibleCard<T extends Sight> extends StatelessWidget {
  const _DismissibleCard({
    @required this.sight,
    @required this.hasVisited,
    @required this.onRemoveCard,
    Key key,
  }) : super(key: key);

  final T sight;
  final bool hasVisited;
  final void Function<T extends Sight>(T) onRemoveCard;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDismissible(
          key: key,
          direction: AppDismissDirection.endToStart,
          onDismissed: (_) => onRemoveCard(sight),
          background: const _CardBackground(),
          child: SightCard(
            sight: sight,
            onRemoveCard: () => onRemoveCard(sight),
          ),
        ),
        const SizedBox(height: 24.0),
      ],
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
