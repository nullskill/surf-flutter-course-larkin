import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/location_interactor.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/ui/screens/map/map_screen.dart';
import 'package:places/ui/screens/map/map_wm.dart';
import 'package:provider/provider.dart';

/// Роут для MapScreen
class MapScreenRoute extends MaterialPageRoute<MapScreen> {
  MapScreenRoute()
      : super(
          builder: (context) => const MapScreen(wmBuilder: _widgetModelBuilder),
        );
}

WidgetModel _widgetModelBuilder(BuildContext context) => MapWidgetModel(
      context.read<WidgetModelDependencies>(),
      locationInteractor: context.read<LocationInteractor>(),
      settingsInteractor: context.read<SettingsInteractor>(),
      navigator: Navigator.of(context),
    );
