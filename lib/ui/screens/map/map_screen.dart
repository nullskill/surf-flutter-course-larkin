import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/data/model/location.dart';
import 'package:places/ui/res/app_color_scheme.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/map/map_wm.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/app_floating_action_button.dart';
import 'package:relation/relation.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Экран карты интересных мест
class MapScreen extends CoreMwwmWidget {
  const MapScreen({
    @required WidgetModelBuilder wmBuilder,
    Key key,
  })  : assert(wmBuilder != null),
        super(widgetModelBuilder: wmBuilder, key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends WidgetState<MapWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: [
        YandexMap(
          onMapCreated: (controller) => wm.initMap(controller),
        ),
        Center(
          child: EntityStateBuilder<Location>(
            streamedState: wm.locationState,
            child: (_, location) {
              return Column(
                children: [
                  Text(location.name),
                  Text(
                    'Широта: ${location?.lat ?? ''},'
                    '\nДолгота: ${location?.lng ?? ''}',
                  ),
                ],
              );
            },
          ),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionColumn(wm: wm),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 1),
    );
  }
}

class FloatingActionColumn extends StatelessWidget {
  const FloatingActionColumn({
    @required this.wm,
    Key key,
  }) : super(key: key);

  final MapWidgetModel wm;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: MapActionButton(
                iconName: AppIcons.refresh,
                onPressed: () {},
              ),
            ),
            AppFloatingActionButton(
              icon: SvgPicture.asset(AppIcons.plus, color: whiteColor),
              label: Text(
                sightListFabLabel.toUpperCase(),
                style: textBold14.copyWith(
                  color: whiteColor,
                  height: lineHeight1_3,
                ),
              ),
              onPressed: wm.addSightButtonTapAction,
              // onPressed: wm.addSightButtonTapAction,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: MapActionButton(
                isBigIcon: true,
                iconName: AppIcons.geolocation,
                onPressed: wm.getLocationTapAction,
              ),
            ),
          ],
        ),
        Row(
          children: const [
            SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}

class MapActionButton extends StatelessWidget {
  const MapActionButton({
    @required this.iconName,
    @required this.onPressed,
    this.isBigIcon = false,
    Key key,
  }) : super(key: key);

  final bool isBigIcon;
  final String iconName;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: allBorderRadius100,
        color: Theme.of(context).colorScheme.appMapButtonColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(0.0, 4.0),
            blurRadius: 4.0,
            color: blackColor.withOpacity(.25),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: allBorderRadius100,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: 48,
            width: 48,
            child: Center(
              child: SvgPicture.asset(
                iconName,
                width: isBigIcon ? 32.0 : 28.0,
                height: isBigIcon ? 32.0 : 28.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
