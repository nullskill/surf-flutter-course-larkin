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
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/link.dart';
import 'package:places/ui/widgets/message_box.dart';
import 'package:places/ui/widgets/settings_item.dart';
import 'package:places/ui/widgets/subtitle.dart';

/// Экран поиска интересного места.
class SightSearchScreen extends StatefulWidget {
  @override
  _SightSearchScreenState createState() => _SightSearchScreenState();
}

class _SightSearchScreenState extends State<SightSearchScreen>
    with SightSearchScreenHelper {
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
          hasError = snapshot.hasError;
          if (isSearching) {
            return _SearchIndicator();
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
                              for (var item in history)
                                SettingsItem(
                                  title: item,
                                  isGreyedOut: true,
                                  isLast: isLastInHistory(item),
                                  onTap: () {
                                    searchController.text = item;
                                    search();
                                  },
                                  trailing: GestureDetector(
                                    onTap: () {
                                      deleteFromHistory(item);
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
                                    clearHistory();
                                    setState(() {});
                                    FocusScope.of(context)
                                        .requestFocus(searchFocusNode);
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
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
      ),
    );
  }
}

class _SearchIndicator extends StatelessWidget {
  const _SearchIndicator({
    Key key,
  }) : super(key: key);

  static const pxl40 = 40.0;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SizedBox(
          width: pxl40,
          height: pxl40,
          child: CircularProgressIndicator(
            strokeWidth: 6.0,
            backgroundColor: Theme.of(context).backgroundColor,
            valueColor: new AlwaysStoppedAnimation<Color>(secondaryColor2),
          ),
        ),
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
