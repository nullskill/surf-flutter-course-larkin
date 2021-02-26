import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/sight_list/sight_list_logic.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/app_floating_action_button.dart';
import 'package:places/ui/widgets/search_bar.dart';
import 'package:places/ui/widgets/sight_card.dart';

/// Экран списка карточек интересных мест.
class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen>
    with SightListScreenLogic {
  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          snapAppBar();
          return false;
        },
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: controller,
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              elevation: 0,
              flexibleSpace: _Header(
                maxHeight: maxHeight,
                minHeight: minHeight,
                statusBarHeight: statusBarHeight,
                onTap: onTapSearchBar,
                onFilter: onFilterSearchBar,
              ),
              expandedHeight: maxHeight - statusBarHeight,
            ),
            _CardColumn(sights: sights),
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
        onPressed: onPressedFab,
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }
}

class _Header extends StatelessWidget {
  final double maxHeight;
  final double minHeight;
  final double statusBarHeight;
  final Function onTap;
  final Function onFilter;

  const _Header({
    Key key,
    this.maxHeight,
    this.minHeight,
    this.onFilter,
    this.onTap,
    this.statusBarHeight,
  }) : super(key: key);

  @override
  // ignore: long-method
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
          padding: EdgeInsets.only(top: statusBarHeight + 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Tween<double>(begin: 0, end: 24).evaluate(animation),
              ),
              Align(
                alignment: AlignmentTween(
                  begin: Alignment.bottomCenter,
                  end: Alignment.bottomLeft,
                ).evaluate(animation),
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
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
              SizedBox(height: 16.0),
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

  FontWeight _getFontWeight(animation) {
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
    Key key,
    @required this.sights,
  }) : super(key: key);

  final List<Sight> sights;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SightCard(sight: sights[index]),
            );
          },
          childCount: sights.length,
        ),
      ),
    );
  }
}
