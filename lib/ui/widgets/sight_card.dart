import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:places/domain/base_visiting.dart';
import 'package:places/domain/favorite_sight.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/visited_sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/sight_details_screen.dart';
import 'package:places/ui/widgets/app_modal_bottom_sheet.dart';

/// Виджет карточки интересного места.
class SightCard extends StatelessWidget {
  const SightCard({
    @required this.sight,
    this.onRemoveCard,
    Key key,
  }) : super(key: key);

  final Sight sight;
  final void Function() onRemoveCard;

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: sight.runtimeType == Sight ? 3 / 2 : 2,
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
                    onTap: () => showAppModalBottomSheet<SightDetailsScreen>(
                      context: context,
                      builder: (context) => SightDetailsScreen(sight: sight),
                    ),
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
                  onTap: sight.runtimeType == Sight
                      ? () {
                          // TODO: Add callback body
                        }
                      : onRemoveCard,
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
                        onTap: () {
                          // TODO: Add callback body
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardTop extends StatelessWidget {
  const _CardTop({
    @required this.sight,
    Key key,
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
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  LightMode.primaryColor.withOpacity(.3),
                  secondaryColor.withOpacity(.08),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
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
    @required this.imgUrl,
    Key key,
  }) : super(key: key);

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imgUrl,
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
  }
}

class _CardIcon extends StatelessWidget {
  const _CardIcon({
    @required this.iconName,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final String iconName;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
    @required this.sight,
    Key key,
  }) : super(key: key);

  final Sight sight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sight.name,
              style: textMedium16.copyWith(
                height: lineHeight1_25,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 2.0),
            _getDescriptionText(sight, Theme.of(context).buttonColor),
            const SizedBox(height: 2.0),
            _getOpenHoursText(sight),
          ],
        ),
      ),
    );
  }
}

Widget _getDescriptionText<T extends Sight>(T sight, Color descriptionColor) {
  switch (sight.runtimeType) {
    case FavoriteSight:
      return Text(
        '$sightCardPlanned ${DateFormat.yMMMd().format((sight as FavoriteSight).plannedDate)}',
        style: textRegular14.copyWith(
          height: lineHeight1_3,
          color: descriptionColor,
        ),
      );
      break;
    case VisitedSight:
      return Text(
        '$sightCardVisited ${DateFormat.yMMMd().format((sight as VisitedSight).visitedDate)}',
        style: textRegular14.copyWith(
          height: lineHeight1_3,
          color: secondaryColor2,
        ),
      );
      break;
    default:
      return AutoSizeText(
        sight.details,
        minFontSize: 14,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: textRegular14.copyWith(
          // height: lineHeight1_3, // don't auto size with line height!
          color: secondaryColor2,
        ),
      );
  }
}

Widget _getOpenHoursText<T extends Sight>(T sight) {
  switch (sight.runtimeType) {
    case FavoriteSight:
    case VisitedSight:
      final vSight = sight as VisitingSight;
      return Text(
        '$sightDetailsOpenHours ${DateFormat.Hm().format(vSight.openHour)}',
        style: textRegular14.copyWith(
          height: lineHeight1_3,
          color: secondaryColor2,
        ),
      );
      break;
    default:
      return const Text('');
  }
}
