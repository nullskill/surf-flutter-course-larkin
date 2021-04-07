import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/domain/category.dart';
import 'package:places/domain/sight.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/select_category_screen.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/clear_button.dart';
import 'package:places/ui/widgets/link.dart';
import 'package:places/ui/widgets/select_picture_dialog.dart';
import 'package:places/ui/widgets/settings_item.dart';
import 'package:places/ui/widgets/subtitle.dart';
import 'package:places/util/consts.dart';
import 'package:provider/provider.dart';

/// Перечисление координат
enum Coordinate { lat, lng }

/// Перечисление полей
enum Field { name, latitude, longitude, description }

/// Хранит список URL картинок места
final _imgUrls = <String>[];

/// Экран добавления нового места.
class AddSightScreen extends StatefulWidget {
  const AddSightScreen({Key key}) : super(key: key);

  @override
  _AddSightScreenState createState() => _AddSightScreenState();
}

class _AddSightScreenState extends State<AddSightScreen> {
  List<String> get imgUrls => _imgUrls;

  final controllers = <Field, TextEditingController>{
    Field.name: TextEditingController(),
    Field.latitude: TextEditingController(),
    Field.longitude: TextEditingController(),
    Field.description: TextEditingController(),
  };

  final focusNodes = <Field, FocusNode>{
    Field.name: FocusNode(),
    Field.latitude: FocusNode(),
    Field.longitude: FocusNode(),
    Field.description: FocusNode(),
  };

  String imgKey;
  FocusNode currentFocusNode;
  Category selectedCategory;
  bool isPointerDownOnImg = false;
  bool isPointerMoveOnImg = false;
  bool isPointerUpOnImg = false;
  bool allDone = false;

  /// Валидация введенной координаты
  static String validateCoordinate(String value, Coordinate coordinate) {
    final lat = RegExp(r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)$');
    final lng = RegExp(r'^[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$');

    if (value.isEmpty) return null;
    if (double.tryParse(value) == null) return addSightWrongEntry;
    if (coordinate == Coordinate.lat && !lat.hasMatch(value)) {
      return addSightWrongEntry;
    }
    if (coordinate == Coordinate.lng && !lng.hasMatch(value)) {
      return addSightWrongEntry;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    for (final entry in focusNodes.entries) {
      entry.value.addListener(() => focusNodeListener(entry.key));
    }
    for (final entry in controllers.entries) {
      entry.value.addListener(controllerListener);
    }
  }

  @override
  void dispose() {
    for (final focusNode in focusNodes.values) {
      focusNode.dispose();
    }
    for (final controller in controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  /// Listener для FocusNode
  void focusNodeListener(Field field) {
    setState(() {
      currentFocusNode = focusNodes[field];
    });
  }

  /// Listener для TextEditingController
  void controllerListener() {
    bool _allDone = true;

    for (final controller in controllers.values) {
      if (controller.text.isEmpty) {
        _allDone = false;
        break;
      }
    }

    setState(() {
      allDone = _allDone && selectedCategory != null;
    });
  }

  /// Перемещает фокус на следующий TextFormField
  void moveFocus(BuildContext context) {
    if (focusNodes[Field.name].hasFocus) {
      focusNodes[Field.latitude].requestFocus();
    } else if (focusNodes[Field.latitude].hasFocus) {
      focusNodes[Field.longitude].requestFocus();
    } else if (focusNodes[Field.longitude].hasFocus) {
      focusNodes[Field.description].requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  /// Открывает выбор категории
  Future<void> selectCategory(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<Category>(
        builder: (context) => SelectCategoryScreen(
          selectedCategory: selectedCategory,
        ),
      ),
    );
    if (result != null) setSelectedCategory(result);
  }

  /// Устанавливает выбранную категорию в качестве текущей
  void setSelectedCategory(Category selectedCategory) {
    setState(() {
      this.selectedCategory = selectedCategory;
    });
    if (selectedCategory != null) focusNodes[Field.name].requestFocus();
  }

  /// При тапе на карточке картинки
  void onPointerDownOnImageCard(String imgKey) {
    setState(() {
      this.imgKey = imgKey;
      isPointerDownOnImg = true;
      isPointerMoveOnImg = false;
      isPointerUpOnImg = false;
    });
  }

  /// При свайпе карточки картинки
  void onPointerMoveOnImageCard(String imgKey) {
    setState(() {
      this.imgKey = imgKey;
      isPointerDownOnImg = false;
      isPointerMoveOnImg = true;
      isPointerUpOnImg = false;
    });
  }

  /// При окончании свайпа карточки картинки
  void onPointerUpOnImageCard(String imgKey) {
    setState(() {
      this.imgKey = imgKey;
      isPointerDownOnImg = false;
      isPointerMoveOnImg = false;
      isPointerUpOnImg = true;
    });
  }

  /// Возвращает тень для карточки картинки,
  /// в зависимости от состояния свайпа
  List<BoxShadow> getBoxShadow(String imgKey) {
    if (this.imgKey != imgKey) return [];

    if (isPointerMoveOnImg) {
      return const [
        BoxShadow(
          // ignore: prefer-trailing-comma
          color: Color.fromRGBO(26, 26, 32, 0.16),
          blurRadius: 16,
          offset: Offset(0, 4), // changes position of shadow
        ),
      ];
    }

    if (isPointerDownOnImg) {
      return const [
        BoxShadow(
          // ignore: prefer-trailing-comma
          color: Color.fromRGBO(26, 26, 32, 0.16),
          blurRadius: 8,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ];
    }

    return [];
  }

  /// При добавлении карточки картинки
  void onAddImageCard() {
    setState(() {
      _imgUrls.add((_imgUrls.length + 2).toString());
    });
  }

  /// При добавлении карточки картинки (временная заглушка)
  Future<void> onAddImageCardDummy(BuildContext context) async {
    // TODO: В дальнейшем, после прохождения 16.1 сделать реализацию
    const barrierLabel = 'barrierLabel';
    await showGeneralDialog(
      barrierLabel: barrierLabel,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 250),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return const SelectPictureDialog();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(anim1),
          child: child,
        );
      },
    );
  }

  /// При удалении карточки картинки
  void onDeleteImageCard(String imgUrl) {
    setState(() {
      _imgUrls.removeAt(_imgUrls.indexOf(imgUrl));
    });
  }

  /// При нажатии на ActionButton
  void onActionButtonPressed(BuildContext context) {
    context.read<PlaceInteractor>().addNewSight(
          Sight(
            name: controllers[Field.name].text,
            lat: double.tryParse(controllers[Field.latitude].text),
            lng: double.tryParse(controllers[Field.longitude].text),
            urls: [tempImgUrl],
            details: controllers[Field.description].text,
            type: selectedCategory.type,
          ),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AddSightAppBar(
            imgUrls: imgUrls,
            onDeleteImageCard: onDeleteImageCard,
            onPointerDownOnImageCard: onPointerDownOnImageCard,
            onPointerMoveOnImageCard: onPointerMoveOnImageCard,
            onPointerUpOnImageCard: onPointerUpOnImageCard,
            getBoxShadow: getBoxShadow,
            onAddImageCard: onAddImageCardDummy,
          ),
          _AddSightBody(
            imgUrls: imgUrls,
            controllers: controllers,
            focusNodes: focusNodes,
            currentFocusNode: currentFocusNode,
            selectedCategory: selectedCategory,
            selectCategory: selectCategory,
            moveFocus: moveFocus,
            onDeleteImageCard: onDeleteImageCard,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          16.0,
          8.0,
          16.0,
          MediaQuery.of(context).padding.bottom + 8.0,
        ),
        child: ActionButton(
          label: addSightActionButtonLabel,
          isDisabled: !allDone,
          onPressed: () => onActionButtonPressed(context),
        ),
      ),
    );
  }
}

class _AddSightAppBar extends StatelessWidget {
  const _AddSightAppBar({
    @required this.imgUrls,
    @required this.onDeleteImageCard,
    @required this.onPointerDownOnImageCard,
    @required this.onPointerMoveOnImageCard,
    @required this.onPointerUpOnImageCard,
    @required this.getBoxShadow,
    @required this.onAddImageCard,
    Key key,
  }) : super(key: key);

  final List<String> imgUrls;
  final void Function(String) onDeleteImageCard;
  final void Function(String) onPointerDownOnImageCard;
  final void Function(String) onPointerMoveOnImageCard;
  final void Function(String) onPointerUpOnImageCard;
  final List<BoxShadow> Function(String) getBoxShadow;
  final void Function(BuildContext) onAddImageCard;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            cancelButtonLabel,
            softWrap: false,
            style: textMedium16.copyWith(
              color: secondaryColor2,
              height: lineHeight1_25,
            ),
          ),
        ),
      ),
      leadingWidth: 90.0,
      title: Text(
        addSightAppBarTitle,
        style: textMedium18.copyWith(
          color: Theme.of(context).primaryColor,
          height: lineHeight1_3,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(96.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: _ImageCards(
            imgUrls: imgUrls,
            onDeleteImageCard: onDeleteImageCard,
            onPointerDownOnImageCard: onPointerDownOnImageCard,
            onPointerMoveOnImageCard: onPointerMoveOnImageCard,
            onPointerUpOnImageCard: onPointerUpOnImageCard,
            getBoxShadow: getBoxShadow,
            onAddImageCard: onAddImageCard,
          ),
        ),
      ),
    );
  }
}

class _ImageCards extends StatelessWidget {
  const _ImageCards({
    @required this.imgUrls,
    @required this.onDeleteImageCard,
    @required this.onPointerDownOnImageCard,
    @required this.onPointerMoveOnImageCard,
    @required this.onPointerUpOnImageCard,
    @required this.getBoxShadow,
    @required this.onAddImageCard,
    Key key,
  }) : super(key: key);

  final List<String> imgUrls;
  final void Function(String) onDeleteImageCard;
  final void Function(String) onPointerDownOnImageCard;
  final void Function(String) onPointerMoveOnImageCard;
  final void Function(String) onPointerUpOnImageCard;
  final List<BoxShadow> Function(String) getBoxShadow;
  final void Function(BuildContext) onAddImageCard;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.only(
          top: 24.0,
          left: 16.0,
          right: 8.0,
        ),
        children: [
          _AddImageCard(
            // TODO: В дальнейшем, после прохождения 16.1 сделать реализацию
            onAddImageCard: () => onAddImageCard(context),
          ),
          for (final imgUrl in imgUrls)
            _ImageCard(
              imgUrl: imgUrl,
              onDeleteImageCard: onDeleteImageCard,
              onPointerDownOnImageCard: onPointerDownOnImageCard,
              onPointerMoveOnImageCard: onPointerMoveOnImageCard,
              onPointerUpOnImageCard: onPointerUpOnImageCard,
              getBoxShadow: getBoxShadow,
            ),
        ],
      ),
    );
  }
}

class _AddImageCard extends StatelessWidget {
  const _AddImageCard({
    @required this.onAddImageCard,
    Key key,
  }) : super(key: key);

  static const _cardSize = 72.0;
  final void Function() onAddImageCard;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: allBorderRadius12,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onAddImageCard,
        child: Container(
          width: _cardSize,
          height: _cardSize,
          decoration: BoxDecoration(
            // color: Theme.of(context).canvasColor,
            borderRadius: allBorderRadius12,
            border: Border.fromBorderSide(
              Theme.of(context).inputDecorationTheme.focusedBorder.borderSide,
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              AppIcons.plus,
              width: 48.0,
              height: 48.0,
              color: Theme.of(context).buttonColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({
    @required this.imgUrl,
    @required this.onDeleteImageCard,
    @required this.onPointerDownOnImageCard,
    @required this.onPointerMoveOnImageCard,
    @required this.onPointerUpOnImageCard,
    @required this.getBoxShadow,
    Key key,
  }) : super(key: key);

  static const _cardSize = 72.0;
  final String imgUrl;
  final void Function(String) onDeleteImageCard;
  final void Function(String) onPointerDownOnImageCard;
  final void Function(String) onPointerMoveOnImageCard;
  final void Function(String) onPointerUpOnImageCard;
  final List<BoxShadow> Function(String) getBoxShadow;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(imgUrl),
      direction: DismissDirection.up,
      onDismissed: (_) => onDeleteImageCard(imgUrl),
      child: Listener(
        onPointerDown: (_) => onPointerDownOnImageCard(imgUrl),
        onPointerMove: (_) => onPointerMoveOnImageCard(imgUrl),
        onPointerUp: (_) => onPointerUpOnImageCard(imgUrl),
        child: Container(
          width: _cardSize,
          height: _cardSize,
          margin: const EdgeInsets.only(left: 16.0),
          decoration: BoxDecoration(
            color: placeholderColor,
            borderRadius: allBorderRadius12,
            boxShadow: getBoxShadow(imgUrl),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClearButton(
                isDeletion: true,
                onTap: () => onDeleteImageCard(imgUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddSightBody extends StatelessWidget {
  const _AddSightBody({
    @required this.imgUrls,
    @required this.controllers,
    @required this.focusNodes,
    @required this.currentFocusNode,
    @required this.moveFocus,
    @required this.selectCategory,
    @required this.onDeleteImageCard,
    this.selectedCategory,
    Key key,
  }) : super(key: key);

  final List<String> imgUrls;
  final Map<Field, TextEditingController> controllers;
  final Map<Field, FocusNode> focusNodes;
  final FocusNode currentFocusNode;
  final Category selectedCategory;
  final void Function(BuildContext) selectCategory;
  final void Function(BuildContext) moveFocus;
  final void Function(String) onDeleteImageCard;

  bool hasClearButton(Field field) =>
      currentFocusNode == focusNodes[field] &&
      controllers[field].text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Subtitle(subtitle: addSightCategoryTitle),
                SettingsItem(
                  title: selectedCategory?.name ?? addSightNoCategoryTitle,
                  isGreyedOut: selectedCategory == null,
                  onTap: () => selectCategory(context),
                  trailing: SvgPicture.asset(
                    AppIcons.view,
                    width: 24.0,
                    height: 24.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                _AddSightTextField(
                  title: addSightNameTitle,
                  hasClearButton: hasClearButton(Field.name),
                  controller: controllers[Field.name],
                  focusNode: focusNodes[Field.name],
                  moveFocus: () => moveFocus(context),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _AddSightTextField(
                        title: addSightLatitudeTitle,
                        hasClearButton: hasClearButton(Field.latitude),
                        controller: controllers[Field.latitude],
                        focusNode: focusNodes[Field.latitude],
                        moveFocus: () => moveFocus(context),
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        validator: (value) =>
                            _AddSightScreenState.validateCoordinate(
                          value,
                          Coordinate.lat,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: _AddSightTextField(
                        title: addSightLongitudeTitle,
                        hasClearButton: hasClearButton(Field.longitude),
                        controller: controllers[Field.longitude],
                        focusNode: focusNodes[Field.longitude],
                        moveFocus: () => moveFocus(context),
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        validator: (value) =>
                            _AddSightScreenState.validateCoordinate(
                          value,
                          Coordinate.lng,
                        ),
                      ),
                    ),
                  ],
                ),
                Link(
                  label: addSightSelectOnMapLabel,
                  onTap: () {
                    // TODO: Make select on map
                  },
                ),
                _AddSightTextField(
                  title: addSightDescriptionTitle,
                  hintText: addSightDescriptionHintText,
                  maxLines: 4,
                  isLastField: true,
                  hasClearButton: hasClearButton(Field.description),
                  controller: controllers[Field.description],
                  focusNode: focusNodes[Field.description],
                  moveFocus: () => moveFocus(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddSightTextField extends StatelessWidget {
  const _AddSightTextField({
    @required this.title,
    @required this.controller,
    @required this.focusNode,
    @required this.moveFocus,
    this.maxLines,
    this.hintText,
    this.isLastField = false,
    this.hasClearButton = false,
    this.keyboardType,
    this.validator,
    Key key,
  }) : super(key: key);

  final int maxLines;
  final String title;
  final String hintText;
  final bool isLastField;
  final bool hasClearButton;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function() moveFocus;
  final String Function(String) validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Subtitle(subtitle: title),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: TextFormField(
            autovalidateMode: validator != null
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: validator,
            scrollPadding: const EdgeInsets.all(100.0),
            maxLines: maxLines ?? 1,
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            textCapitalization: TextCapitalization.sentences,
            textInputAction:
                isLastField ? TextInputAction.done : TextInputAction.next,
            onEditingComplete: moveFocus,
            cursorColor: Theme.of(context).primaryColor,
            cursorHeight: 24.0,
            cursorWidth: 1,
            style: textRegular16.copyWith(
              color: Theme.of(context).primaryColor,
              height: lineHeight1_25,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: controller.text.isEmpty
                  ? Theme.of(context).inputDecorationTheme.border
                  : Theme.of(context).inputDecorationTheme.enabledBorder,
              suffixIcon: !hasClearButton
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClearButton(
                        onTap: () {
                          controller.clear();
                        },
                      ),
                    ),
              suffixIconConstraints: const BoxConstraints(
                maxHeight: 40.0,
                maxWidth: 40.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
