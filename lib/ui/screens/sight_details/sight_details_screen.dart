import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/domain/categories.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/res/app_color_scheme.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/sight_details/sight_details_wm.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:relation/relation.dart';
import 'package:sized_context/sized_context.dart';

/// Экран отображения подробной информации о посещаемом месте.
class SightDetailsScreen extends CoreMwwmWidget {
  SightDetailsScreen({
    @required this.sight,
    Key key,
  }) : super(
            widgetModelBuilder: (context) =>
                createSightDetailsWm(context, sight),
            key: key);

  final Sight sight;

  @override
  _SightDetailsScreenState createState() => _SightDetailsScreenState();
}

class _SightDetailsScreenState extends WidgetState<SightDetailsWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return EntityStateBuilder<Sight>(
      streamedState: wm.sightDetailsState,
      child: (context, sight) {
        return Scaffold(
          backgroundColor: transparentColor,
          body: CustomScrollView(
            slivers: [
              _SightDetailsAppBar(sight: sight),
              _SightDetailsBody(sight: sight, wm: wm),
            ],
          ),
        );
      },
      loadingChild: const SizedBox.shrink(),
    );
  }
}

class _SightDetailsAppBar extends StatelessWidget {
  const _SightDetailsAppBar({
    @required this.sight,
    Key key,
  }) : super(key: key);

  final Sight sight;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: _Gallery(
              imgUrls: sight.urls,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Container(
                height: 4.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: allBorderRadius8,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                AppIcons.cardClose,
                width: 40.0,
                height: 40.0,
              ),
            ),
          ),
        ],
      ),
      expandedHeight: 360.0,
      backgroundColor: placeholderColor,
    );
  }
}

class _Gallery extends StatefulWidget {
  const _Gallery({
    @required this.imgUrls,
    Key key,
  }) : super(key: key);

  final List<String> imgUrls;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemCount: widget.imgUrls.length,
          itemBuilder: (context, index) {
            return Image.network(
              widget.imgUrls[currentIndex],
              fit: BoxFit.cover,
              loadingBuilder: (
                context,
                child,
                loadingProgress,
              ) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            );
          },
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            height: 8.0,
            width: context.widthPx / widget.imgUrls.length * (currentIndex + 1),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: rightBorderRadius8,
            ),
          ),
        ),
      ],
    );
  }
}

class _SightDetailsBody extends StatelessWidget {
  const _SightDetailsBody({
    @required this.sight,
    @required this.wm,
    Key key,
  }) : super(key: key);

  final Sight sight;
  final SightDetailsWidgetModel wm;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        width: double.infinity,
        color: Theme.of(context).canvasColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _CardLabel(sight: sight),
            const SizedBox(height: 24.0),
            Text(
              sight.details,
              style: textRegular14.copyWith(
                height: lineHeight1_3,
                color: Theme.of(context).colorScheme.appTitleColor,
              ),
            ),
            const SizedBox(height: 24.0),
            ActionButton(
              iconName: AppIcons.go,
              label: sightDetailsActionButtonLabel,
              onPressed: () {
                // TODO: Make ActionButton callback
              },
            ),
            const SizedBox(height: 24.0),
            StreamedStateBuilder<bool>(
              streamedState: wm.isFavoriteSightState,
              builder: (context, isFavoriteSight) => _CardMenu(
                  isFavoriteSight: isFavoriteSight,
                  addToFavorites: wm.toggleFavoriteSightAction),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel({
    @required this.sight,
    Key key,
  }) : super(key: key);

  final Sight sight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sight.name,
          style: textBold24.copyWith(
            height: lineHeight1_2,
            color: Theme.of(context).colorScheme.appTitleColor,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              categories.firstWhere((el) => el.type == sight.type).name,
              style: textBold14.copyWith(
                height: lineHeight1_3,
                color: Theme.of(context).colorScheme.appSubtitleColor,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '$sightDetailsOpenHours 09:00',
              style: textRegular14.copyWith(
                height: lineHeight1_3,
                color: secondaryColor2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CardMenu extends StatelessWidget {
  const _CardMenu({
    @required this.isFavoriteSight,
    @required this.addToFavorites,
    Key key,
  }) : super(key: key);

  final bool isFavoriteSight;
  final void Function() addToFavorites;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: .8),
        const SizedBox(height: 8),
        Row(
          children: [
            _ExpandedButton(
              title: sightDetailsPlan,
              iconName: AppIcons.calendar,
              onPressed: addToFavorites,
            ),
            _ExpandedButton(
              title: sightDetailsAddToFavorites,
              iconName: isFavoriteSight ? AppIcons.heartFull : AppIcons.heart,
              selected: true,
              onPressed: addToFavorites,
            ),
          ],
        ),
      ],
    );
  }
}

class _ExpandedButton extends StatelessWidget {
  const _ExpandedButton({
    @required this.title,
    @required this.iconName,
    @required this.onPressed,
    this.selected = false,
    Key key,
  }) : super(key: key);

  final String title;
  final String iconName;
  final bool selected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? Theme.of(context).colorScheme.appTitleColor : inactiveColor;
    return Expanded(
      child: TextButton.icon(
        style: TextButton.styleFrom(
          minimumSize: const Size(40.0, 40.0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onPressed,
        icon: SvgPicture.asset(
          iconName,
          width: 24.0,
          height: 24.0,
          color: color,
        ),
        label: Text(
          title,
          style: textRegular14.copyWith(height: 1.3, color: color),
        ),
      ),
    );
  }
}
