import 'dart:async';
import 'package:flutter/material.dart';

import 'package:places/domain/sight.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/screens/sight_search_screen/sight_search_screen_helper.dart';

import 'package:places/ui/widgets/app_search_bar.dart';
import 'package:places/ui/widgets/message_box.dart';

/// Экран поиска интересного места.
class SightSearchScreen extends StatefulWidget {
  static const milliseconds = 3000;

  final SightSearchScreenHelper helper = SightSearchScreenHelper();

  @override
  _SightSearchScreenState createState() => _SightSearchScreenState();
}

class _SightSearchScreenState extends State<SightSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchText, prevSearchText;
  Timer debounce;
  bool hasClearButton = false;

  @override
  void initState() {
    super.initState();

    searchController.addListener(searchControllerListener);
  }

  void searchControllerListener() {
    if (debounce?.isActive ?? false) debounce.cancel();

    if (searchText == searchController.text) return;

    setState(
      () {
        hasClearButton = searchController.text.isNotEmpty;

        debounce = Timer(
          const Duration(
            milliseconds: SightSearchScreen.milliseconds,
          ),
          () {
            prevSearchText = searchText;
            searchText = searchController.text;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    debounce?.cancel();

    super.dispose();
  }

  void onEditingComplete() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // print("build: $searchText");
    return Scaffold(
      appBar: AppSearchBar(
        title: sightListAppBarTitle,
        autofocus: true,
        hasBackButton: true,
        hasClearButton: hasClearButton,
        searchController: searchController,
        onEditingComplete: onEditingComplete,
      ),
      body: StreamBuilder<List<Sight>>(
        stream: widget.helper.getSightList(searchText),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasError || !snapshot.hasData) return _MessageBox();

              List<Sight> sights = snapshot.data;
              return ListView.separated(
                itemCount: sights?.length ?? 0,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(sights[index].name),
                  );
                },
              );
            default:
              return _MessageBox();
          }
        },
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  const _MessageBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MessageBox(
      title: nothingFoundTitle,
      iconName: AppIcons.search,
      message: nothingFoundMessage,
    );
  }
}
