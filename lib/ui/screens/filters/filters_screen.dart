import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/domain/category.dart';
import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/res/app_color_scheme.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/filters/filters_screen_helper.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/app_back_button.dart';
import 'package:places/ui/widgets/app_range_slider/app_range_slider.dart';
import 'package:places/ui/widgets/app_range_slider/app_range_slider_helper.dart';
import 'package:places/ui/widgets/subtitle.dart';

/// Экран фильтров
class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();

  static _FiltersScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_FiltersScreenState>();
}

class _FiltersScreenState extends State<FiltersScreen> {
  int _filteredCardsNumber = 0;
  List<Sight> _filteredCards;
  List<Category> _categories;
  RangeValues _currentRangeValues;

  get getCategories => _categories;

  @override
  void initState() {
    super.initState();
    for (var category in categories) category.reset();
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
    _filteredCards = mocks
        .where((el) =>
            selectedTypes.contains(el.type) &&
            FiltersScreenHelper.arePointsNear(
              checkPoint: el,
              centerPoint: FiltersScreenHelper.centerPoint,
              minValue: _currentRangeValues.start,
              maxValue: _currentRangeValues.end,
            ))
        .toList();
    _filteredCardsNumber = _filteredCards.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _FiltersAppBar(),
      body: _FiltersBody(currentRangeValues: _currentRangeValues),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          16.0,
          8.0,
          16.0,
          MediaQuery.of(context).padding.bottom + 8.0,
        ),
        child: ActionButton(
          label: "$filtersActionButtonLabel ($_filteredCardsNumber)",
          isDisabled: _filteredCardsNumber == 0,
          onPressed: () {
            filteredMocks.clear();
            filteredMocks.addAll(_filteredCards);

            Navigator.pop(context);
          },
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
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 24.0,
      ),
      children: [
        Subtitle(
          subtitle: filtersCategoriesTitle,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            8.0,
            24.0,
            8.0,
            56,
          ),
          child: _Categories(),
        ),
        AppRangeSlider(currentRangeValues: _currentRangeValues),
      ],
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
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
                borderRadius: BorderRadius.circular(32.0),
                child: CircleAvatar(
                  radius: 32.0,
                  backgroundColor:
                      Theme.of(context).buttonColor.withOpacity(.16),
                  child: SvgPicture.asset(
                    category.iconName,
                    width: 32.0,
                    height: 32.0,
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
          width: 96.0,
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

  static const zero = 0.0;

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
          width: 16.0,
          height: 16.0,
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
        const Size.fromWidth(96.0),
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
