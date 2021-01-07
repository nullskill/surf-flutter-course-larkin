import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/mocks.dart';
import 'package:places/domain/sight.dart';

import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/app_color_scheme.dart';

import 'package:places/ui/screens/filters_screen/filters_screen_helper.dart';

import 'package:places/ui/widgets/app_back_button.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/app_range_slider/app_range_slider_helper.dart';
import 'package:places/ui/widgets/app_range_slider/app_range_slider.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();

  static _FiltersScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_FiltersScreenState>();
}

class _FiltersScreenState extends State<FiltersScreen> {
  static const spacing8 = 8.0, spacing16 = 16.0, spacing24 = 24.0;
  int _numberOfFilteredCards = 0;
  List<Category> _categories;
  RangeValues _currentRangeValues;

  get getCategories => _categories;

  @override
  void initState() {
    super.initState();
    _categories = [...categories];
    _resetRangeValues();
  }

  void setRangeValues(RangeValues newValues) {
    setState(() {
      _currentRangeValues = newValues;
      _filterCards();
    });
  }

  void resetAllSettings() => setState(() {
        for (var category in _categories) category.selected = false;
        _resetRangeValues();
        _numberOfFilteredCards = 0;
      });

  void toggleCategory(Category category) => setState(() {
        category.toggle();
        _filterCards();
      });

  void _filterCards() {
    final selectedTypes = [
      for (var category in _categories)
        if (category.selected) category.type,
    ];
    final filteredCards = mocks.where((el) =>
        selectedTypes.contains(el.type) &&
        FiltersScreenHelper.arePointsNear(
          checkPoint: el,
          centerPoint: FiltersScreenHelper.centerPoint,
          minValue: _currentRangeValues.start,
          maxValue: _currentRangeValues.end,
        ));
    _numberOfFilteredCards = filteredCards.length;
  }

  void _resetRangeValues() {
    _currentRangeValues = RangeValues(
      AppRangeSliderHelper.initialMinValue,
      AppRangeSliderHelper.initialMaxValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _FiltersAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing24,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  filtersScreenCategoriesTitle.toUpperCase(),
                  style: textRegular12.copyWith(
                    color: inactiveColor,
                    height: lineHeight1_3,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  spacing8,
                  spacing24,
                  spacing8,
                  56,
                ),
                child: _Categories(),
              ),
              AppRangeSlider(currentRangeValues: _currentRangeValues),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing8,
        ),
        child: ActionButton(
          label: "$filtersScreenActionButtonLabel ($_numberOfFilteredCards)",
        ),
      ),
    );
  }
}

class _FiltersAppBar extends StatelessWidget implements PreferredSizeWidget {
  _FiltersAppBar({
    Key key,
  }) : super(key: key);

  final Size preferredSize = Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: AppBackButton(),
      actions: [
        Center(
          child: _ClearButton(),
        ),
      ],
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
        FiltersScreen.of(context).resetAllSettings();
      },
      child: Text(
        filtersScreenClearButtonLabel,
        style: textMedium16.copyWith(
          color: Theme.of(context).buttonColor,
          height: lineHeight1_25,
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
        for (var category in FiltersScreen.of(context).getCategories)
          _Category(
            category: category,
          ),
      ],
    );
  }
}

class _Category extends StatelessWidget {
  const _Category({
    Key key,
    @required this.category,
  }) : super(key: key);

  static const maxAvatarWidth = 32.0, maxItemWidth = 96.0;

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(_Category.maxAvatarWidth),
                child: CircleAvatar(
                  radius: _Category.maxAvatarWidth,
                  backgroundColor:
                      Theme.of(context).buttonColor.withOpacity(.16),
                  child: SvgPicture.asset(
                    category.iconName,
                    width: _Category.maxAvatarWidth,
                    height: _Category.maxAvatarWidth,
                    color: Theme.of(context).buttonColor,
                  ),
                ),
                onTap: () {
                  FiltersScreen.of(context).toggleCategory(category);
                },
              ),
            ),
            category.selected ? _CategoryTick() : SizedBox(),
          ],
        ),
        SizedBox(
          width: _Category.maxItemWidth,
          height: 12,
        ),
        _CategoryLabel(label: category.name),
      ],
    );
  }
}

class _CategoryTick extends StatelessWidget {
  const _CategoryTick({
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

class _CategoryLabel extends StatelessWidget {
  const _CategoryLabel({
    Key key,
    @required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(
        const Size.fromWidth(_Category.maxItemWidth),
      ),
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: textRegular12.copyWith(
          color: Theme.of(context).colorScheme.appTitleColor,
          height: lineHeight1_3,
        ),
      ),
    );
  }
}
