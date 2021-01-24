import 'package:flutter/material.dart';

import 'package:places/ui/res/strings/strings.dart';

import 'package:places/ui/widgets/app_search_bar.dart';

/// Экран поиска интересного места.
class SightSearchScreen extends StatefulWidget {
  @override
  _SightSearchScreenState createState() => _SightSearchScreenState();
}

class _SightSearchScreenState extends State<SightSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppSearchBar(
        title: sightListAppBarTitle,
        onTap: () {
          print("search tapped");
        },
      ),
    );
  }
}
