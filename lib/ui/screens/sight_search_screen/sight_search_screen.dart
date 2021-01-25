import 'package:flutter/material.dart';

import 'package:places/domain/sight.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/screens/sight_search_screen/sight_search_screen_helper.dart';

import 'package:places/ui/widgets/app_search_bar.dart';
import 'package:places/ui/widgets/message_box.dart';

/// Экран поиска интересного места.
class SightSearchScreen extends StatefulWidget {
  final SightSearchScreenHelper helper = SightSearchScreenHelper();

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
      body: StreamBuilder<List<Sight>>(
        stream: widget.helper.getSightList(searchController.text),
        builder: (context, snapshot) {
          List<Sight> sights = snapshot.data;
          return ListView.separated(
            itemCount: sights.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(sights[index].name),
              );
            },
          );
        },
      ),
      // MessageBox(
      //   title: nothingFoundTitle,
      //   iconName: AppIcons.search,
      //   message: nothingFoundMessage,
      // ),
    );
  }
}
