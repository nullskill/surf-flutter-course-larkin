import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/sight_list/sight_list_wm.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/app_floating_action_button.dart';
import 'package:places/ui/widgets/circular_progress.dart';
import 'package:places/ui/widgets/search_bar.dart';
import 'package:places/ui/widgets/sight_card/sight_card.dart';
import 'package:relation/relation.dart';
import 'package:sized_context/sized_context.dart';

/// Экран списка карточек интересных мест.
class SightListScreen extends CoreMwwmWidget {
  const SightListScreen({
    @required WidgetModelBuilder wmBuilder,
    Key key,
  })  : assert(wmBuilder != null),
        super(widgetModelBuilder: wmBuilder, key: key);

  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends WidgetState<SightListWidgetModel> {
  final ScrollController controller = ScrollController();
  // expanded height = 196 + status bar height
  double get maxHeight =>
      context.isLandscape ? 140 : 196 + context.mq.padding.top;

  // global constant kToolbarHeight from material + status bar height
  double get minHeight => kToolbarHeight + context.mq.padding.top;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  /// Проверяет смещение между [maxHeight] и [minHeight]
  /// и создает microtask для анимации подскроливания
  /// после завершения билда
  void snapAppBar() {
    final scrollDistance = maxHeight - minHeight;

    if (controller.offset > 0 && controller.offset < scrollDistance) {
      final double snapOffset =
          controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(
        () => controller.animateTo(
          snapOffset,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          snapAppBar();
          return false;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller,
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: _Header(
                maxHeight: maxHeight,
                minHeight: minHeight,
                onTap: wm.searchBarTapAction,
                onFilter: wm.searchBarFilterTapAction,
              ),
              expandedHeight: maxHeight - context.mq.padding.top,
            ),
            _CardColumn(wm: wm),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AppFloatingActionButton(
        icon: SvgPicture.asset(AppIcons.plus, color: whiteColor),
        label: Text(
          sightListFabLabel.toUpperCase(),
          style: textBold14.copyWith(
            color: whiteColor,
            height: lineHeight1_3,
          ),
        ),
        onPressed: wm.addSightButtonTapAction,
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    this.maxHeight,
    this.minHeight,
    this.onFilter,
    this.onTap,
    Key key,
  }) : super(key: key);

  final double maxHeight;
  final double minHeight;
  final void Function() onTap;
  final void Function() onFilter;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expandRatio = _calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expandRatio);
        final listTitle = expandRatio < 1.0
            ? sightListAppBarTitle
            : sightListAppBarWrappedTitle;

        return Container(
          color: Theme.of(context).canvasColor,
          padding: EdgeInsets.only(
            top: context.mq.padding.top + (context.isLandscape ? 0.0 : 16.0),
          ),
          child: Column(
            children: [
              SizedBox(
                height:
                    Tween<double>(begin: context.isLandscape ? 16 : 0, end: 24)
                        .evaluate(animation),
              ),
              Align(
                alignment: AlignmentTween(
                  begin: Alignment.bottomCenter,
                  end: Alignment.bottomLeft,
                ).evaluate(animation),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: context.isLandscape ? 34.0 : 16.0),
                  child: context.isLandscape
                      ? Text(
                          sightListAppBarTitle,
                          style: textMedium18.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18.0,
                            height: lineHeight1_3,
                          ),
                        )
                      : Text(
                          listTitle,
                          style: textMedium18.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Tween<double>(
                              begin: 18.0,
                              end: 32.0,
                            ).evaluate(animation),
                            fontWeight: _getFontWeight(animation),
                            height: Tween<double>(
                              begin: lineHeight1_3,
                              end: lineHeight1_1,
                            ).evaluate(animation),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: Tween<double>(begin: 0, end: 52).evaluate(animation),
                child: SearchBar(
                  readOnly: true,
                  onTap: onTap,
                  onFilter: onFilter,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio =
        (constraints.maxHeight - minHeight) / (maxHeight - minHeight);
    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.0) expandRatio = 0.0;
    return expandRatio;
  }

  FontWeight _getFontWeight(Animation<double> animation) {
    final listTitleWeight =
        Tween<double>(begin: 1.0, end: 3.0).evaluate(animation).toInt();

    switch (listTitleWeight) {
      case 1:
        return FontWeight.w500;
      case 2:
        return FontWeight.w600;
      case 3:
      default:
        return FontWeight.w700;
    }
  }
}

class _CardColumn extends StatelessWidget {
  const _CardColumn({
    @required this.wm,
    Key key,
  }) : super(key: key);

  final SightListWidgetModel wm;

  @override
  Widget build(BuildContext context) {
    final _topPadding = context.isLandscape ? 14.0 : 0.0;
    final _restPadding = context.isLandscape ? 34.0 : 16.0;
    return EntityStateBuilder<List<Sight>>(
      streamedState: wm.sightsState,
      child: (context, sights) {
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(
            _restPadding,
            _topPadding,
            _restPadding,
            _restPadding,
          ),
          sliver: context.isLandscape
              ? _SliverGrid(sights: sights)
              : _SliverList(sights: sights),
        );
      },
      loadingChild: SliverFillRemaining(
        child: FractionallySizedBox(
          alignment: Alignment.topCenter,
          heightFactor: .8,
          child: Center(
            child: CircularProgress(
              primaryColor: secondaryColor2,
              secondaryColor: Theme.of(context).backgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverGrid extends StatelessWidget {
  const _SliverGrid({this.sights, Key key}) : super(key: key);

  final List<Sight> sights;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          final Sight sight = sights[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SightCard(sight: sight),
          );
        },
        childCount: sights.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 36.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: context.diagonalInches > 7 ? 1.7 : 1.0,
      ),
    );
  }
}

class _SliverList extends StatelessWidget {
  const _SliverList({this.sights, Key key}) : super(key: key);

  final List<Sight> sights;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          final Sight sight = sights[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: SightCard(
              sight: sight,
              key: ValueKey<int>(sight.id),
            ),
          );
        },
        childCount: sights.length,
      ),
    );
  }
}
