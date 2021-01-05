import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/mocks.dart';

import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/app_color_scheme.dart';

import 'package:places/ui/widgets/app_back_button.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/app_range_slider/app_range_slider.dart';

class FiltersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        actions: [
          Center(
            child: _ClearButton(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  filtersScreenCategoriesTitle.toUpperCase(),
                  style: textRegular12.copyWith(
                    color: inactiveColor,
                    height: 1.3,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 24, 8, 56),
                child: _Categories(),
              ),
              AppRangeSlider(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: ActionButton(
          label: filtersScreenActionButtonLabel,
        ),
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        print("_ClearButton pressed");
      },
      child: Text(
        filtersScreenClearButtonLabel,
        style: textMedium16.copyWith(
          color: Theme.of(context).buttonColor,
          height: 1.25,
        ),
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 40,
      alignment: WrapAlignment.spaceEvenly,
      children: [
        for (var sight in mocks) ...[
          _Category(
            name: sight.type,
            iconName: AppIcons.hotel,
            hasTick: true,
          ),
        ],
      ],
    );
  }
}

class _Category extends StatelessWidget {
  const _Category({
    Key key,
    @required this.name,
    @required this.iconName,
    @required this.hasTick,
  }) : super(key: key);

  static const maxAvatarWidth = 32.0, maxItemWidth = 96.0;

  final String name;
  final String iconName;
  final bool hasTick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: maxAvatarWidth,
              backgroundColor: Theme.of(context).buttonColor.withOpacity(.16),
              child: SvgPicture.asset(
                iconName,
                width: maxAvatarWidth,
                height: maxAvatarWidth,
                color: Theme.of(context).buttonColor,
              ),
            ),
            hasTick ? _Tick() : SizedBox(),
          ],
        ),
        SizedBox(
          width: maxItemWidth,
          height: 12,
        ),
        ConstrainedBox(
          constraints: BoxConstraints.loose(
            const Size.fromWidth(maxItemWidth),
          ),
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textRegular12.copyWith(
              color: Theme.of(context).colorScheme.appTitleColor,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _Tick extends StatelessWidget {
  const _Tick({
    Key key,
  }) : super(key: key);

  static const iconSize = 16.0, zero = 0.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: zero,
      right: zero,
      child: CircleAvatar(
        radius: 8,
        child: SvgPicture.asset(
          AppIcons.tick,
          width: iconSize,
          height: iconSize,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
