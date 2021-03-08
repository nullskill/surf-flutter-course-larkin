import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/res/app_color_scheme.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/app_back_button.dart';

/// Экран отображения подробной информации о посещаемом месте.
class SightDetailsScreen extends StatelessWidget {
  const SightDetailsScreen({
    @required this.sight,
    Key key,
  }) : super(key: key);

  final Sight sight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _SightDetailsAppBar(sight: sight),
          _SightDetailsBody(sight: sight),
        ],
      ),
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
      leading: const AppBackButton(),
      flexibleSpace: SizedBox(
        height: double.infinity,
        child: _Gallery(
          imgUrl: sight.url,
        ),
      ),
      expandedHeight: 360.0,
      backgroundColor: placeholderColor,
    );
  }
}

class _Gallery extends StatefulWidget {
  const _Gallery({
    @required this.imgUrl,
    Key key,
  }) : super(key: key);

  static const imageCount = 5;
  final String imgUrl;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  int currentIndex = 1;

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          onPageChanged: (index) {
            setState(() {
              currentIndex = index + 1;
            });
          },
          itemCount: _Gallery.imageCount,
          itemBuilder: (context, index) {
            return Image.network(
              widget.imgUrl,
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
            width: MediaQuery.of(context).size.width /
                _Gallery.imageCount *
                currentIndex,
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
    Key key,
  }) : super(key: key);

  final Sight sight;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        width: double.infinity,
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
                // ignore: avoid_print
                print('ActionButton pressed');
              },
            ),
            const SizedBox(height: 24.0),
            const _CardMenu(),
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
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: .8),
        const SizedBox(height: 8),
        Row(
          children: const [
            _ExpandedButton(
              title: sightDetailsPlan,
              iconName: AppIcons.calendar,
            ),
            _ExpandedButton(
              title: sightDetailsAddToFavorites,
              iconName: AppIcons.heart,
              selected: true,
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
    this.selected = false,
    Key key,
  }) : super(key: key);

  final String title;
  final String iconName;
  final bool selected;

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
        onPressed: () {
          // ignore: avoid_print
          print('_ExpandedButton pressed');
        },
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
