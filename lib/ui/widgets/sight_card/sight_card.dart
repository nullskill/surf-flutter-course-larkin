import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/domain/categories.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/sight_details/sight_details_screen.dart';
import 'package:places/ui/widgets/app_modal_bottom_sheet.dart';
import 'package:places/ui/widgets/sight_card/sight_card_wm.dart';
import 'package:relation/relation.dart';
import 'package:sized_context/sized_context.dart';

/// Виджет карточки интересного места.
class SightCard extends CoreMwwmWidget {
  SightCard({
    @required this.sight,
    Key key,
  }) : super(
          widgetModelBuilder: (context) => createSightCardWm(context, sight),
          key: key,
        );

  final Sight sight;

  @override
  _SightCardState createState() => _SightCardState();
}

class _SightCardState extends WidgetState<SightCardWidgetModel> {
  TimeOfDay selectedTime = TimeOfDay.now();

  /// Показать модальный bottom sheet с детальной инфой
  Future<void> showSightDetails(BuildContext context, Sight sight) async {
    await showAppModalBottomSheet<SightDetailsScreen>(
      context: context,
      builder: (_) => SightDetailsScreen(sight: sight),
    );
    await wm.checkIsFavoriteSightAction();
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
    return StreamedStateBuilder<SightData>(
      streamedState: wm.sightState,
      builder: (context, state) {
        return AspectRatio(
          aspectRatio: _getAspectRatio(
            context,
            isSightCard: state.isSightCard,
          ),
          child: ClipRRect(
            borderRadius: allBorderRadius16,
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Stack(
                children: [
                  Column(
                    children: [
                      _CardTop(sight: state.sight),
                      _CardBottom(sightData: state),
                    ],
                  ),
                  Positioned.fill(
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () => showSightDetails(context, state.sight),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: state.isSightCard
                        ? StreamedStateBuilder<bool>(
                            streamedState: wm.isFavoriteSightState,
                            builder: (context, isFavoriteSight) {
                              return AnimatedCrossFade(
                                duration: const Duration(milliseconds: 250),
                                firstCurve: Curves.easeIn,
                                firstChild: _CardIcon(
                                    iconName: AppIcons.heart,
                                    onTap: wm.toggleFavoriteSightAction),
                                secondCurve: Curves.easeOut,
                                secondChild: _CardIcon(
                                    iconName: AppIcons.heartFull,
                                    onTap: wm.toggleFavoriteSightAction),
                                crossFadeState: isFavoriteSight
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                              );
                            })
                        : _CardIcon(
                            iconName: AppIcons.close,
                            onTap: state.isFavoriteCard
                                ? wm.removeFavoriteSightAction
                                : wm.removeVisitedSightAction,
                          ),
                  ),
                  //Показываем различные иконки, в зависимости от типа карточки
                  state.isVisitingCard
                      ? Positioned(
                          top: 16,
                          right: 56,
                          child: _CardIcon(
                            iconName: state.isFavoriteCard
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
      },
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
          Image.asset(
            AppIcons.placeholder,
          ),
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
    return CachedNetworkImage(
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      imageUrl: imgUrl,
      fadeInDuration: const Duration(milliseconds: 350),
      fit: BoxFit.cover,
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
    @required this.sightData,
    Key key,
  }) : super(key: key);

  final SightData sightData;

  @override
  Widget build(BuildContext context) {
    final openHours = _getOpenHours(sightData);
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
              sightData.sight.name,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: textMedium16.copyWith(
                height: lineHeight1_25,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 2.0),
            _getDescriptionText(context, sightData),
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

/// Получить соотношение ширины и высоты карточки
double _getAspectRatio(BuildContext context, {bool isSightCard}) {
  if (isSightCard) {
    if (context.diagonalInches > 7) {
      if (context.widthPx > 500) {
        return 21 / 9;
      } else {
        return 2;
      }
    }
    if (context.diagonalInches > 5) {
      if (context.heightPx > 700) {
        return 3 / 2;
      } else {
        return 5 / 3;
      }
    }
    return 4 / 3;
  } else {
    if (context.diagonalInches > 7) {
      return 5 / 2;
    }
    if (context.diagonalInches > 5) {
      return 16 / 9;
    }
    return 4 / 3;
  }
}

/// Получить виджет с описанием
Widget _getDescriptionText(BuildContext context, SightData sightData) {
  final int maxLines = _getMaxLines(context);

  if (sightData.isVisitingCard) {
    return Text(
      _getVisitingDate(sightData),
      style: textRegular14.copyWith(
        height: lineHeight1_3,
        color: sightData.isFavoriteCard
            ? Theme.of(context).buttonColor
            : secondaryColor2,
      ),
    );
  }
  return AutoSizeText(
    sightData.sight.details,
    minFontSize: 14,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: textRegular14.copyWith(
      // height: lineHeight1_3, // don't auto size with line height!
      color: secondaryColor2,
    ),
  );
}

/// Получить максимальное число строк описания
int _getMaxLines(BuildContext context) {
  if (context.diagonalInches > 7) {
    return 5;
  }
  if (context.diagonalInches > 4) {
    return 4;
  }
  if (context.diagonalInches > 3) {
    return 3;
  }
  return 2;
}

/// Получить дату посещения
String _getVisitingDate(SightData sightData) {
  if (sightData.isFavoriteCard) {
    return '$sightCardPlanned ${DateFormat.yMMMd().format(sightData.plannedDate)}';
  }
  return '$sightCardVisited ${DateFormat.yMMMd().format(sightData.visitedDate)}';
}

/// Получить часы открытия
String _getOpenHours(SightData sightData) {
  if (sightData.isVisitingCard) {
    return '$sightDetailsOpenHours ${DateFormat.Hm().format(sightData.openHour)}';
  }
  return '';
}
