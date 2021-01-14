import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/assets.dart';

/// Виджет карточки интересного места.
class SightCard extends StatelessWidget {
  final Sight sight;

  const SightCard({Key key, this.sight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: ClipRRect(
        borderRadius: allBorderRadius16,
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Stack(
            children: [
              Column(
                children: [
                  _CardTop(sight: sight),
                  _CardBottom(sight: sight),
                ],
              ),
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      print('Card tapped');
                    },
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: _CardIcon(
                  iconName: sight.runtimeType == Sight
                      ? AppIcons.heart
                      : AppIcons.close,
                ),
              ),
              //Показываем различные иконки, в зависимости от типа карточки
              [FavoriteSight, VisitedSight].contains(sight.runtimeType)
                  ? Positioned(
                      top: 16,
                      right: 56,
                      child: _CardIcon(
                        iconName: sight.runtimeType == FavoriteSight
                            ? AppIcons.calendar
                            : AppIcons.share,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardTop extends StatelessWidget {
  const _CardTop({
    Key key,
    @required this.sight,
  }) : super(key: key);

  final Sight sight;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: placeholderColor,
      width: double.infinity,
      height: 96.0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _CardImage(imgUrl: sight.url),
          Positioned(
            top: 16,
            left: 16,
            child: Text(
              categories.firstWhere((el) => el.type == sight.type).name,
              style: textBold14.copyWith(color: whiteColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({
    Key key,
    @required this.imgUrl,
  }) : super(key: key);

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imgUrl,
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
  }
}

class _CardIcon extends StatelessWidget {
  const _CardIcon({
    Key key,
    @required this.iconName,
  }) : super(key: key);

  final String iconName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Card icon pressed");
      },
      child: SvgPicture.asset(
        iconName,
        width: 24,
        height: 24,
        color: whiteColor,
      ),
    );
  }
}

class _CardBottom extends StatelessWidget {
  const _CardBottom({
    Key key,
    @required this.sight,
  }) : super(key: key);

  static const pxl16 = 16.0;
  final Sight sight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: pxl16,
        left: pxl16,
        right: pxl16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sight.name,
            style: textMedium16.copyWith(
              height: 1.25,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          _getDescriptionText(sight, Theme.of(context).buttonColor),
          SizedBox(
            height: 2,
          ),
          _getOpenHoursText(sight),
        ],
      ),
    );
  }
}

Widget _getDescriptionText(final sight, final Color descriptionColor) {
  switch (sight.runtimeType) {
    case FavoriteSight:
      return Text(
        "$sightCardPlanned ${DateFormat.yMMMd().format(sight.plannedDate)}",
        style: textRegular14.copyWith(
          height: 1.3,
          color: descriptionColor,
        ),
      );
      break;
    case VisitedSight:
      return Text(
        "$sightCardVisited ${DateFormat.yMMMd().format(sight.visitedDate)}",
        style: textRegular14.copyWith(
          height: 1.3,
          color: secondaryColor2,
        ),
      );
      break;
    default:
      return Text(
        sight.details,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: textRegular14.copyWith(
          height: 1.3,
          color: secondaryColor2,
        ),
      );
  }
}

Widget _getOpenHoursText(var sight) {
  switch (sight.runtimeType) {
    case FavoriteSight:
    case VisitedSight:
      return Text(
        "$sightDetailsOpenHours ${DateFormat.Hm().format(sight.openHour)}",
        style: textRegular14.copyWith(
          height: 1.3,
          color: secondaryColor2,
        ),
      );
      break;
    default:
      return Text("");
  }
}
