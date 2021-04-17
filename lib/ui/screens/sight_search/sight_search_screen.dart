import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/domain/categories.dart';
import 'package:places/domain/sight.dart';
import 'package:places/redux/action/sight_search_action.dart';
import 'package:places/redux/action/sight_search_history_action.dart';
import 'package:places/redux/state/app_state.dart';
import 'package:places/redux/state/sight_search_state.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/sight_details_screen.dart';
import 'package:places/ui/widgets/app_back_button.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/app_modal_bottom_sheet.dart';
import 'package:places/ui/widgets/circular_progress.dart';
import 'package:places/ui/widgets/link.dart';
import 'package:places/ui/widgets/message_box.dart';
import 'package:places/ui/widgets/search_bar.dart';
import 'package:places/ui/widgets/settings_item.dart';
import 'package:places/ui/widgets/subtitle.dart';

class SightSearchScreen extends StatefulWidget {
  const SightSearchScreen({Key key}) : super(key: key);

  @override
  _SightSearchScreenState createState() => _SightSearchScreenState();
}

class _SightSearchScreenState extends State<SightSearchScreen> {
  static const debounceDelay = 2000;

  TextEditingController searchController;
  FocusNode searchFocusNode;
  Timer debounce;
  String prevSearchText = '';
  bool hasClearButton = false;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    searchController.addListener(searchControllerListener);
  }

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();

    super.dispose();
  }

  /// Listener изменений [searchController]
  void searchControllerListener() {
    if (prevSearchText != searchController.text) {
      setState(() {
        hasClearButton = searchController.text.isNotEmpty;
      });
      search();
      prevSearchText = searchController.text;
    }
  }

  /// При окончании редактирования поля поиска
  void onEditingComplete() {
    removeSearchFocus();
    search();
  }

  /// Добавление элемента истории
  void addToHistory(String item) {
    if (item.isNotEmpty) {
      StoreProvider.of<AppState>(context).dispatch(AddToHistoryAction(item));
    }
  }

  /// При тапе на элементе истории
  void onTapOnHistory(String item) {
    searchController.text = item;
    search();
  }

  /// При удалении элемента истории
  void onDeleteFromHistory(String item) {
    StoreProvider.of<AppState>(context).dispatch(DeleteFromHistoryAction(item));
  }

  /// При очистке истории
  void onClearHistory() {
    StoreProvider.of<AppState>(context).dispatch(ClearHistoryAction());
    FocusScope.of(context).requestFocus(searchFocusNode);
  }

  /// Для снятия фокуса с поля поиска
  void removeSearchFocus() {
    searchFocusNode.unfocus();
  }

  /// Диспатчит начало поиска
  void dispatchSearchAction() {
    StoreProvider.of<AppState>(context)
        .dispatch(StartSearchAction(searchController.text));
    addToHistory(searchController.text);
  }

  /// Осуществляет поиск
  Future<void> search() async {
    if (debounce?.isActive ?? false) debounce.cancel();

    debounce = Timer(
      Duration(milliseconds: searchController.text.isEmpty ? 0 : debounceDelay),
      dispatchSearchAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(
        hasClearButton: hasClearButton,
        searchController: searchController,
        searchFocusNode: searchFocusNode,
        onEditingComplete: onEditingComplete,
      ),
      body: StoreConnector<AppState, SightSearchState>(
        converter: (store) => store.state.sightSearchState,
        builder: (context, vm) {
          if (vm is SearchLoadingState) {
            return const _SearchIndicator();
          } else if (vm is SearchDataState) {
            if (vm.hasError) {
              return _MessageBox(
                hasError: true,
                onTap: removeSearchFocus,
              );
            }
            if (vm.foundSights.isEmpty) {
              return _MessageBox(
                onTap: removeSearchFocus,
              );
            }
            return _SearchResultsList(
              sights: vm.foundSights,
              removeSearchFocus: removeSearchFocus,
            );
          } else if (vm is SearchInitialState) {
            final historyState = StoreProvider.of<AppState>(context)
                .state
                .sightSearchHistoryState;
            return historyState.isHistoryEmpty
                ? const SizedBox()
                : _SearchHistoryList(
                    history: historyState.reversedHistory,
                    isLastInHistory: historyState.isLastInHistory,
                    onTapOnHistory: onTapOnHistory,
                    onClearHistory: onClearHistory,
                    onDeleteFromHistory: onDeleteFromHistory,
                  );
          }

          throw ArgumentError('No view for state $vm');
        },
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    @required this.hasClearButton,
    @required this.searchController,
    @required this.searchFocusNode,
    @required this.onEditingComplete,
    Key key,
  }) : super(key: key);

  final bool hasClearButton;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final void Function() onEditingComplete;

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
        child: SearchBar(
          autofocus: true,
          hasClearButton: hasClearButton,
          searchController: searchController,
          searchFocusNode: searchFocusNode,
          onEditingComplete: onEditingComplete,
        ),
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
          size: 40.0,
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
      leading: Container(
        width: 56.0,
        height: 56.0,
        decoration: BoxDecoration(
          color: placeholderColor,
          borderRadius: allBorderRadius12,
          image: DecorationImage(
            image: NetworkImage(sight.urls.first),
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
    @required this.isLastInHistory,
    @required this.onTapOnHistory,
    @required this.onDeleteFromHistory,
    @required this.onClearHistory,
    Key key,
  }) : super(key: key);

  final List<String> history;
  final bool Function(String) isLastInHistory;
  final Function onTapOnHistory;
  final Function onDeleteFromHistory;
  final void Function() onClearHistory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          // ignore: prefer-trailing-comma
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
                  isLast: isLastInHistory(item),
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
