import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:places/data/model/location.dart';
import 'package:places/domain/sight.dart';

Future<void> openMapsSheet(
  BuildContext context,
  Location location,
  Sight sight,
  void Function() addToVisited,
) async {
  final availableMaps = await MapLauncher.installedMaps;

  await showModalBottomSheet<void>(
    context: context,
    builder: (_) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            children: <Widget>[
              for (final map in availableMaps)
                ListTile(
                  onTap: () {
                    final destination = Coords(sight.lat, sight.lng);

                    map
                      ..showMarker(
                        coords: destination,
                        title: sight.name,
                      )
                      ..showDirections(destination: destination);

                    addToVisited();
                  },
                  title: Text(map.mapName),
                  leading: SvgPicture.asset(
                    map.icon,
                    height: 30.0,
                    width: 30.0,
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
