import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/ui/screens/visiting/visiting_screen.dart';
import 'package:places/ui/screens/visiting/visiting_wm.dart';
import 'package:provider/provider.dart';

/// Роут для VisitingScreen
class VisitingScreenRoute extends MaterialPageRoute<VisitingScreen> {
  VisitingScreenRoute()
      : super(
          builder: (context) =>
              const VisitingScreen(wmBuilder: _widgetModelBuilder),
        );
}

WidgetModel _widgetModelBuilder(BuildContext context) => VisitingWidgetModel(
      context.read<WidgetModelDependencies>(),
      placeInteractor: context.read<PlaceInteractor>(),
    );
