import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/ui/screens/sight_search/sight_search_screen.dart';
import 'package:places/ui/screens/sight_search/sight_search_wm.dart';
import 'package:provider/provider.dart';

/// Роут для SightSearchScreen
class SightSearchScreenRoute extends MaterialPageRoute<SightSearchScreen> {
  SightSearchScreenRoute()
      : super(
    builder: (context) =>
    const SightSearchScreen(wmBuilder: _widgetModelBuilder),
  );
}

WidgetModel _widgetModelBuilder(BuildContext context) => SightSearchWidgetModel(
  context.read<WidgetModelDependencies>(),
  searchInteractor: context.read<SearchInteractor>(),
  navigator: Navigator.of(context),
);