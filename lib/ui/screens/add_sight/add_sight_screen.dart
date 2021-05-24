import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/domain/category.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/add_sight/add_sight_wm.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/clear_button.dart';
import 'package:places/ui/widgets/link.dart';
import 'package:places/ui/widgets/settings_item.dart';
import 'package:places/ui/widgets/subtitle.dart';
import 'package:relation/relation.dart';

/// Экран добавления нового места.
class AddSightScreen extends CoreMwwmWidget {
  const AddSightScreen({
    @required WidgetModelBuilder wmBuilder,
    Key key,
  })  : assert(wmBuilder != null),
        super(widgetModelBuilder: wmBuilder, key: key);

  @override
  _AddSightScreenState createState() => _AddSightScreenState();
}

class _AddSightScreenState extends WidgetState<AddSightWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AddSightAppBar(wm: wm),
          _AddSightBody(wm: wm),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          16.0,
          8.0,
          16.0,
          MediaQuery.of(context).padding.bottom + 8.0,
        ),
        child: StreamedStateBuilder<bool>(
            streamedState: wm.isAllDoneState,
            builder: (context, isAllDone) {
              return ActionButton(
                label: addSightActionButtonLabel,
                isDisabled: !isAllDone,
                onPressed: wm.actionButtonAction,
              );
            }),
      ),
    );
  }
}

class _AddSightAppBar extends StatelessWidget {
  const _AddSightAppBar({
    @required this.wm,
    Key key,
  }) : super(key: key);

  final AddSightWidgetModel wm;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: TextButton(
          onPressed: wm.backButtonAction,
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
          child: _ImageCards(wm: wm),
        ),
      ),
    );
  }
}

class _ImageCards extends StatelessWidget {
  const _ImageCards({
    @required this.wm,
    Key key,
  }) : super(key: key);

  final AddSightWidgetModel wm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.0,
      child: StreamedStateBuilder<List<String>>(
          streamedState: wm.imagesState,
          builder: (context, images) {
            return ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.only(
                top: 24.0,
                left: 16.0,
                right: 8.0,
              ),
              children: [
                _AddImageCard(
                  key: const ValueKey('+'),
                  onAddImageCard: () => wm.addImageAction(context),
                ),
                for (final image in images)
                  _ImageCard(
                    key: ValueKey(image),
                    image: File(image),
                    imageIdx: images.indexOf(image),
                    wm: wm,
                  ),
              ],
            );
          }),
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
      key: key,
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

class _ImageCard extends StatefulWidget {
  const _ImageCard({
    @required this.image,
    @required this.imageIdx,
    @required this.wm,
    Key key,
  }) : super(key: key);

  static const _cardSize = 72.0;
  final File image;
  final int imageIdx;
  final AddSightWidgetModel wm;

  @override
  _ImageCardState createState() => _ImageCardState();
}

class _ImageCardState extends State<_ImageCard> {
  bool isPointerDownOnImg;
  bool isPointerMoveOnImg;

  @override
  void initState() {
    super.initState();

    isPointerDownOnImg = false;
    isPointerMoveOnImg = false;
  }

  /// При тапе на карточке картинки
  void onPointerDownOnImageCard() {
    isPointerDownOnImg = true;
    isPointerMoveOnImg = false;
    setState(() {});
  }

  /// При свайпе карточки картинки
  void onPointerMoveOnImageCard() {
    isPointerDownOnImg = false;
    isPointerMoveOnImg = true;
    setState(() {});
  }

  /// При окончании свайпа карточки картинки
  void onPointerUpOnImageCard() {
    isPointerDownOnImg = false;
    isPointerMoveOnImg = false;
    setState(() {});
  }

  /// Возвращает тень для карточки картинки,
  /// в зависимости от состояния свайпа
  List<BoxShadow> getBoxShadow() {
    if (isPointerMoveOnImg) {
      return const [
        BoxShadow(
          color: Color.fromRGBO(26, 26, 32, 0.16),
          blurRadius: 16,
          offset: Offset(0, 4), // changes position of shadow
        ),
      ];
    }

    if (isPointerDownOnImg) {
      return const [
        BoxShadow(
          color: Color.fromRGBO(26, 26, 32, 0.16),
          blurRadius: 8,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: widget.key,
      direction: DismissDirection.up,
      onDismissed: (_) => widget.wm.removeImageAction(widget.imageIdx),
      child: Listener(
        onPointerDown: (_) => onPointerDownOnImageCard(),
        onPointerMove: (_) => onPointerMoveOnImageCard(),
        onPointerUp: (_) => onPointerUpOnImageCard(),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: allBorderRadius12,
              color: placeholderColor,
              boxShadow: getBoxShadow(),
            ),
            child: ClipRRect(
              borderRadius: allBorderRadius12,
              child: SizedBox(
                width: _ImageCard._cardSize,
                height: _ImageCard._cardSize,
                child: Stack(children: [
                  Positioned.fill(
                    child: Image.file(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClearButton(
                        isDeletion: true,
                        onTap: () =>
                            widget.wm.removeImageAction(widget.imageIdx),
                      ),
                    ),
                  ),
                ]),
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
    @required this.wm,
    Key key,
  }) : super(key: key);

  final AddSightWidgetModel wm;

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
            child: Form(
              key: wm.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Subtitle(subtitle: addSightCategoryTitle),
                  StreamedStateBuilder<Category>(
                      streamedState: wm.selectedCategoryState,
                      builder: (context, category) {
                        return SettingsItem(
                          title: category?.name ?? addSightNoCategoryTitle,
                          isGreyedOut: category == null,
                          onTap: () => wm.selectCategoryAction(context),
                          trailing: SvgPicture.asset(
                            AppIcons.view,
                            width: 24.0,
                            height: 24.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      }),
                  _AddSightTextField(
                    wm: wm,
                    state: wm.nameFieldState,
                    title: addSightNameTitle,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _AddSightTextField(
                          wm: wm,
                          state: wm.latitudeFieldState,
                          title: addSightLatitudeTitle,
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: _AddSightTextField(
                          wm: wm,
                          state: wm.longitudeFieldState,
                          title: addSightLongitudeTitle,
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Link(
                    label: addSightSelectOnMapLabel,
                    onTap: () {
                      // TODO: Make selection on map
                    },
                  ),
                  _AddSightTextField(
                    wm: wm,
                    state: wm.descriptionFieldState,
                    title: addSightDescriptionTitle,
                    hintText: addSightDescriptionHintText,
                    maxLines: 4,
                    isLastField: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddSightTextField extends StatelessWidget {
  const _AddSightTextField({
    @required this.wm,
    @required this.state,
    @required this.title,
    this.hintText,
    this.maxLines,
    this.keyboardType,
    this.isLastField = false,
    Key key,
  }) : super(key: key);

  final String title;
  final String hintText;
  final int maxLines;
  final bool isLastField;
  final TextInputType keyboardType;
  final AddSightWidgetModel wm;
  final StreamedState<FieldData> state;

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
          child: StreamedStateBuilder<FieldData>(
              streamedState: state,
              builder: (context, field) {
                return TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: field.validator,
                  scrollPadding: const EdgeInsets.all(100.0),
                  maxLines: maxLines ?? 1,
                  controller: field.action.controller,
                  focusNode: field.focusNode,
                  keyboardType: keyboardType,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction:
                      isLastField ? TextInputAction.done : TextInputAction.next,
                  cursorColor: Theme.of(context).primaryColor,
                  cursorHeight: 24.0,
                  cursorWidth: 1,
                  style: textRegular16.copyWith(
                    color: Theme.of(context).primaryColor,
                    height: lineHeight1_25,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    enabledBorder: !field.hasText
                        ? Theme.of(context).inputDecorationTheme.border
                        : Theme.of(context).inputDecorationTheme.enabledBorder,
                    suffixIcon: field.hasClearButton
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClearButton(
                              onTap: field.action.controller.clear,
                            ),
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(
                      maxHeight: 40.0,
                      maxWidth: 40.0,
                    ),
                  ),
                  onEditingComplete: () => wm.moveFocusAction(context),
                );
              }),
        ),
      ],
    );
  }
}
