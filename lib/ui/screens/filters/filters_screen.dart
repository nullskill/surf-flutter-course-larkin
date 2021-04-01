import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/domain/category.dart';
import 'package:places/ui/res/app_color_scheme.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/app_back_button.dart';
import 'package:places/ui/widgets/app_range_slider/app_range_slider.dart';
import 'package:places/ui/widgets/subtitle.dart';
import 'package:sized_context/sized_context.dart';

/// Экран фильтров
class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key key}) : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  RangeValues rangeValues;
  PlaceInteractor placeInteractor;
  SearchInteractor searchInteractor;

  @override
  void initState() {
    super.initState();
    placeInteractor = PlaceInteractor();
    searchInteractor = SearchInteractor();
    rangeValues = RangeValues(
      searchInteractor.selectedMinRadius,
      searchInteractor.selectedMaxRadius,
    );
  }

  /// Установка выбранного диапазона радиуса
  /// и фильтрация интересных мест
  void setRangeValues(RangeValues newValues) {
    setState(() {
      rangeValues = newValues;
      searchInteractor.setRadius(rangeValues);
      placeInteractor.getSights();
      searchInteractor.filterSights();
    });
  }

  /// Сброс всех настроек
  void resetAllSettings() => setState(() {
        searchInteractor.resetCategories();
        resetRangeValues();
      });

  /// Изменение признака выбранности категории
  /// и фильтрация интересных мест
  void toggleCategory(Category category) => setState(() {
        category.toggle();
        placeInteractor.getSights();
        searchInteractor.filterSights();
      });

  /// Сброс выбранного диапазона радиуса
  void resetRangeValues() {
    rangeValues = const RangeValues(
      SearchInteractor.minRadius,
      SearchInteractor.maxRadius,
    );
    searchInteractor.setRadius(rangeValues);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _FiltersAppBar(resetAllSettings: resetAllSettings),
      body: _FiltersBody(
        currentRangeValues: rangeValues,
        categories: searchInteractor.getCategories,
        toggleCategory: toggleCategory,
        setRangeValues: setRangeValues,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          16.0,
          8.0,
          16.0,
          context.mq.padding.bottom + 8.0,
        ),
        child: ActionButton(
          label:
              '$filtersActionButtonLabel (${searchInteractor.filteredNumber})',
          isDisabled: searchInteractor.filteredNumber == 0,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

class _FiltersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _FiltersAppBar({
    @required this.resetAllSettings,
    Key key,
  }) : super(key: key);

  final void Function() resetAllSettings;

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const AppBackButton(),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: _ClearButton(resetAllSettings: resetAllSettings),
        ),
      ],
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({
    @required this.resetAllSettings,
    Key key,
  }) : super(key: key);

  final void Function() resetAllSettings;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: resetAllSettings,
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
    @required this.categories,
    @required this.currentRangeValues,
    @required this.toggleCategory,
    @required this.setRangeValues,
    Key key,
  }) : super(key: key);

  final List<Category> categories;
  final RangeValues currentRangeValues;
  final void Function(Category) toggleCategory;
  final void Function(RangeValues) setRangeValues;

  @override
  Widget build(BuildContext context) {
    final _horizontalPadding = context.diagonalInches < 5 ? 0.0 : 8.0;
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 24.0,
      ),
      children: [
        const Subtitle(
          subtitle: filtersCategoriesTitle,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            _horizontalPadding,
            24.0,
            _horizontalPadding,
            56,
          ),
          child: _Categories(
            categories: categories,
            toggleCategory: toggleCategory,
          ),
        ),
        AppRangeSlider(
          currentRangeValues: currentRangeValues,
          setRangeValues: setRangeValues,
        ),
      ],
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories({
    @required this.categories,
    @required this.toggleCategory,
    Key key,
  }) : super(key: key);

  final List<Category> categories;
  final void Function(Category) toggleCategory;

  @override
  Widget build(BuildContext context) {
    return context.diagonalInches < 5
        ? SizedBox(
            height: 100.0,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final Category category = categories[index];
                return _Category(
                  category: category,
                  toggleCategory: () => toggleCategory(category),
                );
              },
            ),
          )
        : GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            controller: ScrollController(keepScrollOffset: false),
            children: [
              for (var category in categories)
                _Category(
                  category: category,
                  toggleCategory: () => toggleCategory(category),
                ),
            ],
          );
  }
}

class _Category extends StatelessWidget {
  const _Category({
    @required this.category,
    @required this.toggleCategory,
    Key key,
  }) : super(key: key);

  final Category category;
  final void Function() toggleCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(32.0),
                onTap: toggleCategory,
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
              ),
            ),
            category.selected ? const _CategoryTick() : const SizedBox.shrink(),
          ],
        ),
        const SizedBox(width: 96.0, height: 12),
        _CategoryLabel(label: category.name),
      ],
    );
  }
}

class _CategoryTick extends StatelessWidget {
  const _CategoryTick({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
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
    @required this.label,
    Key key,
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
