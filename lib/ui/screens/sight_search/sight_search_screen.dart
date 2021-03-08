import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/sight_details_screen.dart';
import 'package:places/ui/widgets/app_back_button.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/circular_progress.dart';
import 'package:places/ui/widgets/link.dart';
import 'package:places/ui/widgets/message_box.dart';
import 'package:places/ui/widgets/search_bar.dart';
import 'package:places/ui/widgets/settings_item.dart';
import 'package:places/ui/widgets/subtitle.dart';

/// Хранит историю поиска
final _history = <String>[];

// ignore: use_key_in_widget_constructors
class SightSearchScreen extends StatefulWidget {
  @override
  _SightSearchScreenState createState() => _SightSearchScreenState();
}

class _SightSearchScreenState extends State<SightSearchScreen> {
  static const searchDelay = 200;
  static const debounceDelay = 3000;
  static const maxHistoryLength = 5;

  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  StreamController<List<Sight>> streamController;
  StreamSubscription<List> streamSub;
  Timer debounce;
  String prevSearchText = '';
  bool isSearching = false;
  bool hasError = false;
  bool hasClearButton = false;
  int requestCounter = 0;

  List<String> get history => _history.reversed
      .toList()
      .sublist(0, min(maxHistoryLength, _history.length));

  bool get isHistoryEmpty => _history.isEmpty;

  @override
  void initState() {
    super.initState();

    streamController = StreamController.broadcast();
    searchController.addListener(searchControllerListener);
  }

  @override
  void dispose() {
    debounce?.cancel();
    streamSub?.cancel();
    searchController.dispose();
    streamController.close();

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

  /// При тапе на элементе истории
  void onTapOnHistory(String item) {
    searchController.text = item;
    search();
  }

  /// При удалении элемента истории
  void onDeleteFromHistory(String item) {
    deleteFromHistory(item);
    setState(() {});
  }

  /// При очистке истории
  void onClearHistory() {
    clearHistory();
    setState(() {});
    FocusScope.of(context).requestFocus(searchFocusNode);
  }

  /// Для снятия фокуса с поля поиска
  void removeSearchFocus() {
    searchFocusNode.unfocus();
  }

  /// Осуществляет поиск через подписку на стрим getSightList через заданный
  /// интервал [debounceDelay], отменяя при необходимости текущий. Результат
  /// поиска проваливается в [streamController] и попадает в [StreamBuilder]
  Future<void> search() async {
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
        await streamSub?.cancel();
        streamController.sink.add(null);
      }
      return;
    }

    isSearching = true;

    debounce = Timer(
      const Duration(
        milliseconds: debounceDelay,
      ),
      () {
        streamSub?.cancel();
        streamSub = getSightList(searchController.text).listen(
          (searchResult) {
            isSearching = false;
            streamController.sink.add(searchResult);
            addToHistory(searchController.text);
          },
          // ignore: avoid_types_on_closure_parameters
          onError: (Exception error) {
            isSearching = false;
            streamController.addError(error);
          },
        );
      },
    );
  }

  /// Генератор для поиска карточек ближайших интересных мест,
  /// содержащих в названии, либо в описании искомую строку
  Stream<List<Sight>> getSightList(String searchString) async* {
    final _searchString = searchString.trim().toLowerCase();

    await Future<void>.delayed(const Duration(milliseconds: searchDelay));

    yield [
      ...getFilteredMocks().where((el) =>
          el.name.toLowerCase().contains(_searchString) ||
          el.details.toLowerCase().contains(_searchString)),
    ];

    requestCounter++;
    if (requestCounter % 3 == 0) throw Exception();
  }

  /// Возвращает true, если элемент последний
  bool isLastInHistory(String item) {
    return history.last == item;
  }

  /// Добавляет элемент в историю
  void addToHistory(String item) {
    deleteFromHistory(item);
    _history.add(item);
    if (_history.length > maxHistoryLength) _history.removeAt(0);
  }

  /// Удаляет элемент из истории
  void deleteFromHistory(String item) {
    final index = _history.indexOf(item);

    if (!index.isNegative) _history.removeAt(index);
  }

  /// Очищает историю
  void clearHistory() {
    _history.clear();
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
      body: StreamBuilder<List<Sight>>(
        stream: streamController.stream,
        builder: (context, snapshot) {
          // Проверять snapshot.connectionState для streamController.stream нет
          // смысла, т.к. он изначально имеет состояние waiting, а после первого
          // event и до конца жизни - active.
          hasError = snapshot.hasError;
          if (isSearching) {
            return const _SearchIndicator();
          } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return _SearchResultsList(
              sights: snapshot.data,
              removeSearchFocus: removeSearchFocus,
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
                ? const SizedBox()
                : _SearchHistoryList(
                    history: history,
                    isLastInHistory: isLastInHistory,
                    onTapOnHistory: onTapOnHistory,
                    onClearHistory: onClearHistory,
                    onDeleteFromHistory: onDeleteFromHistory,
                  );
          }
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
          return _ListTile(sight: sights[index]);
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<SightDetailsScreen>(
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
