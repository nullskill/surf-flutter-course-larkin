import 'package:flutter/material.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/res/strings/strings.dart';

import 'package:places/ui/widgets/app_search_bar.dart';
import 'package:places/ui/widgets/message_box.dart';

/// Экран поиска интересного места.
class SightSearchScreen extends StatefulWidget {
  @override
  _SightSearchScreenState createState() => _SightSearchScreenState();
}

class _SightSearchScreenState extends State<SightSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool hasClearButton = false;

  @override
  void initState() {
    super.initState();

    searchController.addListener(searchControllerListener);
  }

  void searchControllerListener() {
    setState(() {
      hasClearButton = searchController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppSearchBar(
        title: sightListAppBarTitle,
        autofocus: true,
        hasBackButton: true,
        hasClearButton: hasClearButton,
        searchController: searchController,
      ),
      body: MessageBox(
        title: nothingFoundTitle,
        iconName: AppIcons.search,
        message: nothingFoundMessage,
      ),
    );
  }
}
