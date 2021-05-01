import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/ui/screens/sight_list/sight_list_screen.dart';
import 'package:places/ui/screens/sight_list/sight_list_wm.dart';
import 'package:provider/provider.dart';

/// Роут для SightListScreen
class SightListScreenRoute extends MaterialPageRoute<SightListScreen> {
  SightListScreenRoute()
      : super(
          builder: (context) =>
              const SightListScreen(wmBuilder: _widgetModelBuilder),
        );
}

WidgetModel _widgetModelBuilder(BuildContext context) => SightListWidgetModel(
      context.read<WidgetModelDependencies>(),
      placeInteractor: context.read<PlaceInteractor>(),
      searchInteractor: context.read<SearchInteractor>(),
      navigator: Navigator.of(context),
    );
