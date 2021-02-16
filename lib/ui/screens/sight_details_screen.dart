import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final sight;

  const SightDetailsScreen({
    Key key,
    @required this.sight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SightDetailsAppBar(sight: sight),
      body: _SightDetailsBody(sight: sight),
    );
  }
}

class _SightDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  _SightDetailsAppBar({
    Key key,
    @required this.sight,
  }) : super(key: key);

  final sight;
  final Size preferredSize = Size.fromHeight(360.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: AppBackButton(),
      flexibleSpace: Container(
        height: double.infinity,
        child: _Gallery(
          imgUrl: sight.url,
        ),
      ),
      backgroundColor: placeholderColor,
    );
  }
}

class _Gallery extends StatefulWidget {
  const _Gallery({
    Key key,
    @required this.imgUrl,
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
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              widget.imgUrl,
              fit: BoxFit.cover,
              loadingBuilder: (
                BuildContext context,
                Widget child,
                ImageChunkEvent loadingProgress,
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
    Key key,
    @required this.sight,
  }) : super(key: key);

  final sight;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardLabel(sight: sight),
                SizedBox(
                  height: 24.0,
                ),
                Text(
                  sight.details,
                  style: textRegular14.copyWith(
                    height: lineHeight1_3,
                    color: Theme.of(context).colorScheme.appTitleColor,
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                ActionButton(
                  iconName: AppIcons.go,
                  label: sightDetailsActionButtonLabel,
                  onPressed: () {
                    print("ActionButton pressed");
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),
                _CardMenu(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel({
    Key key,
    @required this.sight,
  }) : super(key: key);

  final sight;

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
        SizedBox(
          height: 2,
        ),
        Row(
          children: [
            Text(
              categories.firstWhere((el) => el.type == sight.type).name,
              style: textBold14.copyWith(
                height: lineHeight1_3,
                color: Theme.of(context).colorScheme.appSubtitleColor,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              "$sightDetailsOpenHours 09:00",
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
        Container(
          width: double.infinity,
          height: 1.0,
          color: inactiveColor,
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            _ExpandedButton(
              title: sightDetailsPlan,
              iconName: AppIcons.calendar,
            ),
            _ExpandedButton(
              title: sightDetailsAddToFavorites,
              // iconName: AppIcons.heart,
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
  final String title;
  final String iconName;
  final bool selected;

  const _ExpandedButton({
    Key key,
    @required this.title,
    @required this.iconName,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? Theme.of(context).colorScheme.appTitleColor : inactiveColor;
    return Expanded(
      child: FlatButton.icon(
        height: 40.0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {
          print("_ExpandedButton pressed");
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
