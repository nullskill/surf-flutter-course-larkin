import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/domain/sight.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/screens/add_sight/add_sight_screen_helper.dart';
import 'package:places/ui/screens/select_category_screen.dart';

import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/clear_button.dart';
import 'package:places/ui/widgets/settings_item.dart';
import 'package:places/ui/widgets/link.dart';
import 'package:places/ui/widgets/subtitle.dart';

/// Экран добавления нового места.
class AddSightScreen extends StatefulWidget {
  @override
  _AddSightScreenState createState() => _AddSightScreenState();
}

class _AddSightScreenState extends State<AddSightScreen>
    with AddSightScreenHelper {
  @override
  // ignore: long-method
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
            onAddImageCard: onAddImageCard,
          ),
          _AddSightBody(
            imgUrls: imgUrls,
            controllers: controllers,
            focusNodes: focusNodes,
            currentFocusNode: currentFocusNode,
            selectedCategory: selectedCategory,
            setSelectedCategory: setSelectedCategory,
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
          onPressed: onActionButtonPressed,
        ),
      ),
    );
  }
}

class _AddSightAppBar extends StatelessWidget {
  const _AddSightAppBar({
    Key key,
    @required this.imgUrls,
    @required this.onDeleteImageCard,
    @required this.onPointerDownOnImageCard,
    @required this.onPointerMoveOnImageCard,
    @required this.onPointerUpOnImageCard,
    @required this.getBoxShadow,
    @required this.onAddImageCard,
  }) : super(key: key);

  final List<String> imgUrls;
  final Function onDeleteImageCard;
  final Function onPointerDownOnImageCard;
  final Function onPointerMoveOnImageCard;
  final Function onPointerUpOnImageCard;
  final Function getBoxShadow;
  final Function onAddImageCard;

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      elevation: 0,
      toolbarHeight: 56.0,
      leading: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            addSightCancelButtonLabel,
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
        preferredSize: Size.fromHeight(96.0),
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
    Key key,
    @required this.imgUrls,
    @required this.onDeleteImageCard,
    @required this.onPointerDownOnImageCard,
    @required this.onPointerMoveOnImageCard,
    @required this.onPointerUpOnImageCard,
    @required this.getBoxShadow,
    @required this.onAddImageCard,
  }) : super(key: key);

  final List<String> imgUrls;
  final Function onDeleteImageCard;
  final Function onPointerDownOnImageCard;
  final Function onPointerMoveOnImageCard;
  final Function onPointerUpOnImageCard;
  final Function getBoxShadow;
  final Function onAddImageCard;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: const EdgeInsets.only(
        top: 24.0,
        left: 16.0,
        right: 8.0,
      ),
      child: Row(
        children: [
          _AddImageCard(
            onAddImageCard: onAddImageCard,
          ),
          for (var imgUrl in imgUrls)
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
    Key key,
    @required this.onAddImageCard,
  }) : super(key: key);

  static const _cardSize = 72.0;
  final Function onAddImageCard;

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
    Key key,
    @required this.imgUrl,
    @required this.onDeleteImageCard,
    @required this.onPointerDownOnImageCard,
    @required this.onPointerMoveOnImageCard,
    @required this.onPointerUpOnImageCard,
    @required this.getBoxShadow,
  }) : super(key: key);

  static const _cardSize = 72.0;
  final String imgUrl;
  final Function onDeleteImageCard;
  final Function onPointerDownOnImageCard;
  final Function onPointerMoveOnImageCard;
  final Function onPointerUpOnImageCard;
  final Function getBoxShadow;

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
  _AddSightBody({
    Key key,
    @required this.imgUrls,
    @required this.controllers,
    @required this.focusNodes,
    @required this.currentFocusNode,
    @required this.moveFocus,
    @required this.setSelectedCategory,
    @required this.onDeleteImageCard,
    this.selectedCategory,
  }) : super(key: key);

  final List<String> imgUrls;
  final Map<String, TextEditingController> controllers;
  final Map<String, FocusNode> focusNodes;
  final FocusNode currentFocusNode;
  final Category selectedCategory;
  final Function setSelectedCategory;
  final Function moveFocus;
  final Function onDeleteImageCard;

  bool hasClearButton(fieldName) =>
      currentFocusNode == focusNodes[fieldName] &&
      controllers[fieldName].text.isNotEmpty;

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _ImageCards(
          //   imgUrls: imgUrls,
          //   onDeleteImageCard: onDeleteImageCard,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Subtitle(subtitle: addSightCategoryTitle),
                SettingsItem(
                  title: selectedCategory?.name ?? addSightNoCategoryTitle,
                  isGreyedOut: selectedCategory == null,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectCategoryScreen(
                          selectedCategory: selectedCategory,
                        ),
                      ),
                    );
                    if (result != null) setSelectedCategory(result);
                  },
                  trailing: SvgPicture.asset(
                    AppIcons.view,
                    width: 24.0,
                    height: 24.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                _AddSightTextField(
                  title: addSightNameTitle,
                  hasClearButton: hasClearButton("name"),
                  controller: controllers["name"],
                  focusNode: focusNodes["name"],
                  moveFocus: moveFocus,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _AddSightTextField(
                        title: addSightLatitudeTitle,
                        hasClearButton: hasClearButton("latitude"),
                        controller: controllers["latitude"],
                        focusNode: focusNodes["latitude"],
                        moveFocus: moveFocus,
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        validator: (String value) =>
                            AddSightScreenHelper.validateCoordinate(
                          value,
                          Coordinates.lat,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      child: _AddSightTextField(
                        title: addSightLongitudeTitle,
                        hasClearButton: hasClearButton("longitude"),
                        controller: controllers["longitude"],
                        focusNode: focusNodes["longitude"],
                        moveFocus: moveFocus,
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        validator: (String value) =>
                            AddSightScreenHelper.validateCoordinate(
                          value,
                          Coordinates.lng,
                        ),
                      ),
                    ),
                  ],
                ),
                Link(
                  label: addSightSelectOnMapLabel,
                  onTap: () {
                    print("Select on map tapped");
                  },
                ),
                _AddSightTextField(
                  title: addSightDescriptionTitle,
                  hintText: addSightDescriptionHintText,
                  maxLines: 4,
                  isLastField: true,
                  hasClearButton: hasClearButton("description"),
                  controller: controllers["description"],
                  focusNode: focusNodes["description"],
                  moveFocus: moveFocus,
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
    Key key,
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
  }) : super(key: key);

  final int maxLines;
  final String title;
  final String hintText;
  final bool isLastField;
  final bool hasClearButton;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function moveFocus;
  final Function validator;

  @override
  // ignore: long-method
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
              suffixIconConstraints: BoxConstraints(
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
