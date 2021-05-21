import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/filters_interactor.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/ui/screens/filters/filters_screen.dart';
import 'package:places/ui/screens/filters/filters_screen_wm.dart';
import 'package:provider/provider.dart';

/// Роут для FiltersScreen
class FiltersScreenRoute extends MaterialPageRoute<bool> {
  FiltersScreenRoute()
      : super(
          builder: (context) =>
              const FiltersScreen(wmBuilder: _widgetModelBuilder),
        );
}

WidgetModel _widgetModelBuilder(BuildContext context) => FiltersWidgetModel(
      context.read<WidgetModelDependencies>(),
      placeInteractor: context.read<PlaceInteractor>(),
      searchInteractor: context.read<SearchInteractor>(),
      filtersInteractor: context.read<FiltersInteractor>(),
      navigator: Navigator.of(context),
    );
