import 'dart:async';
import 'package:flutter/material.dart';

import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/screens/sight_search_screen/sight_search_screen_helper.dart';
import 'package:places/ui/screens/sight_details_screen.dart';

import 'package:places/ui/widgets/app_search_bar.dart';
import 'package:places/ui/widgets/message_box.dart';

/// Экран поиска интересного места.
class SightSearchScreen extends StatefulWidget {
  final SightSearchScreenHelper helper = SightSearchScreenHelper();

  @override
  _SightSearchScreenState createState() => _SightSearchScreenState();
}

class _SightSearchScreenState extends State<SightSearchScreen> {
  final searchController = TextEditingController();
  StreamController<List<Sight>> streamController;
  StreamSubscription<List> streamSub;
  Timer debounce;
  String prevSearchText = "";
  bool isSearching = false;
  bool hasClearButton = false;

  @override
  void initState() {
    super.initState();

    streamController = StreamController();

    searchController.addListener(searchControllerListener);
  }

  void searchControllerListener() {
    if (prevSearchText != searchController.text) {
      setState(() {
        hasClearButton = searchController.text.isNotEmpty;
      });
      search();
      prevSearchText = searchController.text;
    }
  }

  @override
  void dispose() {
    debounce?.cancel();
    streamSub?.cancel();
    searchController.dispose();
    streamController.close();

    super.dispose();
  }

  void onEditingComplete() {
    FocusScope.of(context).unfocus();
    search();
  }

  void search() async {
    if (debounce?.isActive ?? false) debounce.cancel();

    if (searchController.text == prevSearchText && !isSearching) return;

    if (searchController.text.isEmpty) {
      if (prevSearchText.isNotEmpty) {
        isSearching = false;
        streamSub?.cancel();
        streamController.sink.add(null);
      }
      return;
    }

    isSearching = true;

    debounce = Timer(
      const Duration(
        milliseconds: SightSearchScreenHelper.debounceDelay,
      ),
      () {
        streamSub?.cancel();
        streamSub = widget.helper.getSightList(searchController.text).listen(
          (searchResult) {
            isSearching = false;
            streamController.sink.add(searchResult);
          },
          onError: (error) {
            isSearching = false;
            streamController.addError(error);
          },
        );
      },
    );
  }

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
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
        stream: streamController.stream,
        builder: (context, snapshot) {
          // Проверять snapshot.connectionState для streamController.stream нет
          // смысла, т.к. он изначально имеет состояние waiting, а после первого
          // event и до конца жизни - active.
          if (isSearching) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
            List<Sight> sights = snapshot.data;
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView.separated(
                itemCount: sights?.length ?? 0,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return _ListTile(sight: sights[index]);
                },
              ),
            );
          } else if (snapshot.hasError) {
            return _MessageBox();
          } else {
            return _MessageBox();
          }
        },
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    Key key,
    @required this.sight,
  }) : super(key: key);

  final Sight sight;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SightDetailsScreen(sight: sight),
          ),
        );
      },
      leading: Container(
        width: 56.0,
        height: 56.0,
        decoration: BoxDecoration(
          color: placeholderColor,
          borderRadius: allBorderRadius12,
          image: DecorationImage(
            image: NetworkImage(sight.url),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        sight.name,
        style: textMedium16.copyWith(
          color: Theme.of(context).primaryColor,
          height: lineHeight1_25,
        ),
      ),
      subtitle: Text(
        categories.firstWhere((el) => el.type == sight.type).name,
        style: textRegular14.copyWith(
          color: secondaryColor2,
          height: lineHeight1_3,
        ),
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MessageBox(
        title: nothingFoundTitle,
        iconName: AppIcons.search,
        message: nothingFoundMessage,
      ),
    );
  }
}
