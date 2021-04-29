import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/ui/screens/add_sight/add_sight_screen.dart';
import 'package:places/ui/screens/add_sight/add_sight_wm.dart';
import 'package:provider/provider.dart';

/// Роут для AddSightScreen
class AddSightScreenRoute extends MaterialPageRoute<AddSightScreen> {
  AddSightScreenRoute()
      : super(
          builder: (context) =>
              const AddSightScreen(wmBuilder: _widgetModelBuilder),
        );
}

WidgetModel _widgetModelBuilder(BuildContext context) => AddSightWidgetModel(
      context.read<WidgetModelDependencies>(),
      placeInteractor: context.read<PlaceInteractor>(),
      navigator: Navigator.of(context),
    );
