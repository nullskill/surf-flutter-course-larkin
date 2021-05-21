import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/domain/categories.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/sight_details/sight_details_screen.dart';
import 'package:places/ui/screens/sight_search/sight_search_wm.dart';
import 'package:places/ui/widgets/app_back_button.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/app_modal_bottom_sheet.dart';
import 'package:places/ui/widgets/circular_progress.dart';
import 'package:places/ui/widgets/link.dart';
import 'package:places/ui/widgets/message_box.dart';
import 'package:places/ui/widgets/search_bar.dart';
import 'package:places/ui/widgets/settings_item.dart';
import 'package:places/ui/widgets/subtitle.dart';
import 'package:relation/relation.dart';

/// Экран поиска
class SightSearchScreen extends CoreMwwmWidget {
  const SightSearchScreen({
    @required WidgetModelBuilder wmBuilder,
    Key key,
  })  : assert(wmBuilder != null),
        super(widgetModelBuilder: wmBuilder, key: key);

  @override
  _SightSearchScreenState createState() => _SightSearchScreenState();
}

class _SightSearchScreenState extends WidgetState<SightSearchWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(wm: wm),
      body: StreamedStateBuilder<bool>(
          streamedState: wm.isSearchingState,
          builder: (context, isSearching) {
            return isSearching
                ? EntityStateBuilder<List<Sight>>(
                    streamedState: wm.foundSights,
                    child: (context, sights) {
                      return sights.isEmpty
                          ? _MessageBox(
                              onTap: wm.removeSearchFocusAction,
                            )
                          : _SearchResultsList(
                              sights: sights,
                              removeSearchFocus: wm.removeSearchFocusAction,
                            );
                    },
                    loadingChild: const _SearchIndicator(),
                    errorChild: _MessageBox(
                      hasError: true,
                      onTap: wm.removeSearchFocusAction,
                    ),
                  )
                : StreamedStateBuilder<List<String>>(
                    streamedState: wm.historyState,
                    builder: (context, history) {
                      return history.isEmpty
                          ? const SizedBox()
                          : _SearchHistoryList(
                              history: history,
                              onTapOnHistory: wm.historyTapAction,
                              onClearHistory: () =>
                                  wm.clearHistoryAction(context),
                              onDeleteFromHistory: wm.deleteFromHistoryAction,
                            );
                    });
          }),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    @required this.wm,
    Key key,
  }) : super(key: key);

  final SightSearchWidgetModel wm;

  @override
  Size get preferredSize => const Size.fromHeight(108.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const AppBackButton(),
      centerTitle: true,
      title: Text(
        sightListAppBarTitle,
        style: textMedium18.copyWith(
          color: Theme.of(context).primaryColor,
          height: lineHeight1_3,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(52.0),
        child: StreamedStateBuilder<bool>(
            streamedState: wm.hasClearButtonState,
            builder: (context, hasClearButton) {
              return SearchBar(
                autofocus: true,
                hasClearButton: hasClearButton,
                searchController: wm.searchEditingAction.controller,
                searchFocusNode: wm.searchFocusNode,
                onEditingComplete: wm.searchEditingCompleteAction,
              );
            }),
      ),
    );
  }
}

class _SearchIndicator extends StatelessWidget {
  const _SearchIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: CircularProgress(
          primaryColor: secondaryColor2,
          secondaryColor: Theme.of(context).backgroundColor,
        ),
      ),
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({
    @required this.sights,
    @required this.removeSearchFocus,
    Key key,
  }) : super(key: key);

  final List<Sight> sights;
  final void Function() removeSearchFocus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: removeSearchFocus,
      child: ListView.separated(
        itemCount: sights?.length ?? 0,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final Sight sight = sights[index];
          return _ListTile(sight: sight);
        },
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    @required this.sight,
    Key key,
  }) : super(key: key);

  final Sight sight;

  Future<void> showSightDetails(BuildContext context) async {
    await showAppModalBottomSheet<SightDetailsScreen>(
      context: context,
      builder: (_) => SightDetailsScreen(sight: sight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => showSightDetails(context),
      leading: SizedBox(
        width: 56.0,
        height: 56.0,
        child: ClipRRect(
          borderRadius: allBorderRadius12,
          child: CachedNetworkImage(
            imageUrl: sight.urls.first,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppIcons.placeholder),
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
              );
            },
            fadeInDuration: const Duration(milliseconds: 350),
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
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: MessageBox(
        title: hasError ? errorTitle : sightSearchNothingFoundTitle,
        iconName: hasError ? AppIcons.emptyError : AppIcons.emptySearch,
        message: hasError ? errorMessage : sightSearchNothingFoundMessage,
      ),
    );
  }
}

class _SearchHistoryList extends StatelessWidget {
  const _SearchHistoryList({
    @required this.history,
    @required this.onTapOnHistory,
    @required this.onDeleteFromHistory,
    @required this.onClearHistory,
    Key key,
  }) : super(key: key);

  final List<String> history;
  final Function onTapOnHistory;
  final Function onDeleteFromHistory;
  final void Function() onClearHistory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 4.0),
          child: Subtitle(
            subtitle: sightSearchHistoryTitle,
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              for (var item in history)
                SettingsItem(
                  title: item,
                  isGreyedOut: true,
                  isLast: history.last == item,
                  onTap: () => onTapOnHistory(item),
                  trailing: GestureDetector(
                    onTap: () => onDeleteFromHistory(item),
                    child: SvgPicture.asset(
                      AppIcons.delete,
                      color: inactiveColor,
                    ),
                  ),
                ),
              _ClearHistoryLink(onTap: onClearHistory),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClearHistoryLink extends StatelessWidget {
  const _ClearHistoryLink({
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Link(
        label: sightSearchClearHistoryLabel,
        onTap: onTap,
      ),
    );
  }
}
