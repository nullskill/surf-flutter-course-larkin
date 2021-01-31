import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

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
import 'package:places/ui/widgets/link.dart';
import 'package:places/ui/widgets/message_box.dart';
import 'package:places/ui/widgets/settings_item.dart';
import 'package:places/ui/widgets/subtitle.dart';

/// Экран поиска интересного места.
class SightSearchScreen extends StatefulWidget {
  final SightSearchScreenHelper helper = SightSearchScreenHelper();

  @override
  _SightSearchScreenState createState() => _SightSearchScreenState();
}

class _SightSearchScreenState extends State<SightSearchScreen> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  final history = <String>[];
  StreamController<List<Sight>> streamController;
  StreamSubscription<List> streamSub;
  Timer debounce;
  String prevSearchText = "";
  bool isSearching = false;
  bool hasError = false;
  bool hasClearButton = false;

  @override
  void initState() {
    super.initState();

    streamController = StreamController.broadcast();

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
    removeSearchFocus();
    search();
  }

  void removeSearchFocus() {
    searchFocusNode.unfocus();
  }

  void search() async {
    if (debounce?.isActive ?? false) debounce.cancel();

    if (searchController.text == prevSearchText && !isSearching) {
      if (hasError) {
        // После ошибки нужна возможность заново отправить запрос по кнопке,
        // поэтому триггерим обновление стейта для ребилда виджета
        setState(() {});
      } else {
        return;
      }
    }

    if (searchController.text.isEmpty) {
      if (prevSearchText.isNotEmpty) {
        isSearching = false;
        streamSub?.cancel();
        streamController.sink.add(null);
      }
      return;
    }

    isSearching = true;
    print("isSearching: $isSearching");

    debounce = Timer(
      const Duration(
        milliseconds: SightSearchScreenHelper.debounceDelay,
      ),
      () {
        streamSub?.cancel();
        streamSub = widget.helper.getSightList(searchController.text).listen(
          (searchResult) {
            print("isSearching searchResult: $isSearching");
            isSearching = false;
            streamController.sink.add(searchResult);
            widget.helper.addToHistory(searchController.text, history);
          },
          onError: (error) {
            print("isSearching onError: $isSearching");
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
        searchFocusNode: searchFocusNode,
        onEditingComplete: onEditingComplete,
      ),
      body: StreamBuilder<List<Sight>>(
        stream: streamController.stream,
        builder: (context, snapshot) {
          // Проверять snapshot.connectionState для streamController.stream нет
          // смысла, т.к. он изначально имеет состояние waiting, а после первого
          // event и до конца жизни - active.
          print("StreamBuilder triggered!");
          hasError = snapshot.hasError;
          if (isSearching) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
            List<Sight> sights = snapshot.data;
            return GestureDetector(
              onTap: removeSearchFocus,
              child: ListView.separated(
                itemCount: sights?.length ?? 0,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return _ListTile(sight: sights[index]);
                },
              ),
            );
          } else if (snapshot.hasData) {
            return _MessageBox(
              onTap: removeSearchFocus,
            );
          } else if (snapshot.hasError) {
            return _MessageBox(
              hasError: true,
              onTap: removeSearchFocus,
            );
          } else {
            return history.isEmpty
                ? SizedBox()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16.0,
                            24.0,
                            16.0,
                            4.0,
                          ),
                          child: Subtitle(
                            subtitle: sightSearchHistoryTitle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              for (var item
                                  in widget.helper.getHistory(history))
                                SettingsItem(
                                  title: item,
                                  isGreyedOut: true,
                                  isLast: widget.helper.isLastInHistory(
                                    item,
                                    history,
                                  ),
                                  onTap: () {
                                    searchController.text = item;
                                    search();
                                  },
                                  trailing: GestureDetector(
                                    onTap: () {
                                      widget.helper.deleteFromHistory(
                                        item,
                                        history,
                                      );
                                      setState(() {});
                                    },
                                    child: SvgPicture.asset(
                                      AppIcons.delete,
                                      color: inactiveColor,
                                    ),
                                  ),
                                ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Link(
                                  label: sightSearchClearHistoryLabel,
                                  onTap: () {
                                    widget.helper.clearHistory(history);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
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

  static const pxl56 = 56.0;

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
        width: pxl56,
        height: pxl56,
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
    this.hasError = false,
    this.onTap,
  }) : super(key: key);

  final bool hasError;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap ?? null,
      child: MessageBox(
        title:
            hasError ? sightSearchHasErrorTitle : sightSearchNothingFoundTitle,
        iconName: hasError ? AppIcons.emptyError : AppIcons.emptySearch,
        message: hasError
            ? sightSearchHasErrorMessage
            : sightSearchNothingFoundMessage,
      ),
    );
  }
}
