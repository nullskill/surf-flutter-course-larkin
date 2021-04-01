import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/domain/categories.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/sight_details_screen.dart';
import 'package:places/ui/widgets/app_modal_bottom_sheet.dart';
import 'package:places/ui/widgets/sight_card/sight_card_helper.dart';

/// Виджет карточки интересного места.
class SightCard extends StatefulWidget {
  const SightCard({
    @required this.sight,
    this.onRemoveCard,
    this.addToFavorites,
    Key key,
  }) : super(key: key);

  final Sight sight;
  final void Function() onRemoveCard;
  final void Function() addToFavorites;

  @override
  _SightCardState createState() => _SightCardState();
}

class _SightCardState extends State<SightCard> {
  final PlaceInteractor placeInteractor = PlaceInteractor();
  SightCardHelper helper;

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    helper = SightCardHelper(sight: widget.sight);
  }

  /// Добавление в избранное
  void addToFavorites() {
    setState(() {
      widget.addToFavorites();
    });
  }

  /// Показать модальный bottom sheet с детальной инфой
  Future<void> showSightDetails(BuildContext context) async {
    final Sight sight = await placeInteractor.getSightDetails(widget.sight.id);
    await showAppModalBottomSheet<SightDetailsScreen>(
      context: context,
      builder: (_) => SightDetailsScreen(
        sight: sight,
        isFavoriteSight: () => placeInteractor.isFavoriteSight(sight),
        addToFavorites: () => placeInteractor.toggleFavoriteSight(sight),
      ),
    );
  }

  /// Диалог выбора времени
  Future<void> selectTime(BuildContext context) async {
    TimeOfDay pickedTime;

    if (Platform.isIOS) {
      pickedTime = await showModalBottomSheet(
        context: context,
        builder: (_) {
          return _CupertinoTimerPicker(selectedTime: selectedTime);
        },
      );
    } else {
      pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
    }

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: helper.getAspectRatio(context),
      child: ClipRRect(
        borderRadius: allBorderRadius16,
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Stack(
            children: [
              Column(
                children: [
                  _CardTop(sight: widget.sight),
                  _CardBottom(sight: widget.sight, helper: helper),
                ],
              ),
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => showSightDetails(context),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: _CardIcon(
                  iconName: helper.isMainListCard
                      ? placeInteractor.isFavoriteSight(widget.sight)
                          ? AppIcons.heartFull
                          : AppIcons.heart
                      : AppIcons.close,
                  onTap: helper.isMainListCard
                      ? addToFavorites
                      : widget.onRemoveCard,
                ),
              ),
              //Показываем различные иконки, в зависимости от типа карточки
              helper.isVisitingCard
                  ? Positioned(
                      top: 16,
                      right: 56,
                      child: _CardIcon(
                        iconName: helper.isFavoriteCard
                            ? AppIcons.calendar
                            : AppIcons.share,
                        onTap: () => selectTime(context),
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
          _CardImage(imgUrl: sight.urls.first),
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

class _CupertinoTimerPicker extends StatefulWidget {
  const _CupertinoTimerPicker({
    @required this.selectedTime,
    Key key,
  }) : super(key: key);

  final TimeOfDay selectedTime;

  @override
  _CupertinoTimerPickerState createState() => _CupertinoTimerPickerState();
}

class _CupertinoTimerPickerState extends State<_CupertinoTimerPicker> {
  Duration _pickedTime;

  @override
  void initState() {
    super.initState();
    _pickedTime = Duration(
      hours: widget.selectedTime.hour,
      minutes: widget.selectedTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  sightCardTimePickerCancelLabel,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ),
              CupertinoButton(
                onPressed: () => Navigator.pop(
                  context,
                  TimeOfDay(
                    hour: _pickedTime.inHours,
                    minute: _pickedTime.inMinutes - _pickedTime.inHours * 60,
                  ),
                ),
                child: Text(
                  sightCardTimePickerSubmitLabel,
                  style: TextStyle(
                    color: Theme.of(context).buttonColor,
                  ),
                ),
              ),
            ],
          ),
          CupertinoTimerPicker(
            initialTimerDuration: _pickedTime,
            mode: CupertinoTimerPickerMode.hm,
            onTimerDurationChanged: (newTime) {
              setState(() {
                _pickedTime = newTime;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _CardBottom extends StatelessWidget {
  const _CardBottom({
    @required this.sight,
    @required this.helper,
    Key key,
  }) : super(key: key);

  final Sight sight;
  final SightCardHelper helper;

  @override
  Widget build(BuildContext context) {
    final openHours = helper.getOpenHours();
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
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: textMedium16.copyWith(
                height: lineHeight1_25,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 2.0),
            _getDescriptionText(context, sight, helper),
            const SizedBox(height: 2.0),
            openHours == ''
                ? const SizedBox.shrink()
                : Text(
                    openHours,
                    style: textRegular14.copyWith(
                      height: lineHeight1_3,
                      color: secondaryColor2,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

Widget _getDescriptionText<T extends Sight>(
  BuildContext context,
  T sight,
  SightCardHelper helper,
) {
  final int maxLines = helper.getMaxLines(context);

  if (helper.isVisitingCard) {
    return Text(
      helper.getVisitingDate(),
      style: textRegular14.copyWith(
        height: lineHeight1_3,
        color: helper.isFavoriteCard
            ? Theme.of(context).buttonColor
            : secondaryColor2,
      ),
    );
  }
  return AutoSizeText(
    sight.details,
    minFontSize: 14,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: textRegular14.copyWith(
      // height: lineHeight1_3, // don't auto size with line height!
      color: secondaryColor2,
    ),
  );
}
