import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/mocks.dart';
import 'package:places/domain/sight.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/app_color_scheme.dart';
import 'package:places/ui/res/assets.dart';

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
  static const pxl8 = 8.0, pxl16 = 16.0, pxl24 = 24.0;
  int _filteredCardsNumber = 0;
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
        _filteredCardsNumber = 0;
      });

  void toggleCategory(Category category) => setState(() {
        category.toggle();
        _filterCards();
      });

  void _resetRangeValues() {
    _currentRangeValues = RangeValues(
      AppRangeSliderHelper.initialMinValue,
      AppRangeSliderHelper.initialMaxValue,
    );
  }

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
    _filteredCardsNumber = filteredCards.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _FiltersAppBar(),
      body: _FiltersBody(currentRangeValues: _currentRangeValues),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: pxl16,
          vertical: pxl8,
        ),
        child: ActionButton(
          label: "$filtersActionButtonLabel ($_filteredCardsNumber)",
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
        filtersClearButtonLabel,
        style: textMedium16.copyWith(
          color: Theme.of(context).buttonColor,
          height: lineHeight1_25,
        ),
      ),
    );
  }
}

class _FiltersBody extends StatelessWidget {
  const _FiltersBody({
    Key key,
    @required RangeValues currentRangeValues,
  })  : _currentRangeValues = currentRangeValues,
        super(key: key);

  final RangeValues _currentRangeValues;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _FiltersScreenState.pxl16,
          vertical: _FiltersScreenState.pxl24,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                filtersCategoriesTitle.toUpperCase(),
                style: textRegular12.copyWith(
                  color: inactiveColor,
                  height: lineHeight1_3,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                _FiltersScreenState.pxl8,
                _FiltersScreenState.pxl24,
                _FiltersScreenState.pxl8,
                56,
              ),
              child: _Categories(),
            ),
            AppRangeSlider(currentRangeValues: _currentRangeValues),
          ],
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

  static const pxl32 = 32.0, pxl96 = 96.0;

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
                borderRadius: BorderRadius.circular(pxl32),
                child: CircleAvatar(
                  radius: _Category.pxl32,
                  backgroundColor:
                      Theme.of(context).buttonColor.withOpacity(.16),
                  child: SvgPicture.asset(
                    category.iconName,
                    width: pxl32,
                    height: pxl32,
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
          width: pxl96,
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

  static const pxl16 = 16.0, zero = 0.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: zero,
      right: zero,
      child: CircleAvatar(
        radius: 8,
        backgroundColor: Theme.of(context).primaryColor,
        child: SvgPicture.asset(
          AppIcons.tick,
          width: pxl16,
          height: pxl16,
          color: Theme.of(context).canvasColor,
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
        const Size.fromWidth(_Category.pxl96),
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
