import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/domain/sight.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/screens/add_sight_screen/add_sight_screen_helper.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AddSightAppBar(),
      body: _AddSightBody(
        controllers: controllers,
        focusNodes: focusNodes,
        currentFocusNode: currentFocusNode,
        selectedCategory: selectedCategory,
        setSelectedCategory: setSelectedCategory,
        moveFocus: moveFocus,
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

class _AddSightAppBar extends StatelessWidget implements PreferredSizeWidget {
  _AddSightAppBar({
    Key key,
  }) : super(key: key);

  final Size preferredSize = Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}

class _AddSightBody extends StatelessWidget {
  _AddSightBody({
    Key key,
    @required this.controllers,
    @required this.focusNodes,
    @required this.currentFocusNode,
    @required this.moveFocus,
    @required this.setSelectedCategory,
    this.selectedCategory,
  }) : super(key: key);

  final Map<String, TextEditingController> controllers;
  final Map<String, FocusNode> focusNodes;
  final FocusNode currentFocusNode;
  final Category selectedCategory;
  final Function setSelectedCategory;
  final Function moveFocus;

  bool hasClearButton(fieldName) =>
      currentFocusNode == focusNodes[fieldName] &&
      controllers[fieldName].text.isNotEmpty;

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _ImageCards(),
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

class _ImageCards extends StatelessWidget {
  const _ImageCards({
    Key key,
  }) : super(key: key);

  static const _cardsSpacing = 16.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 24.0,
          right: 8.0,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _ImageCard(),
              SizedBox(width: _cardsSpacing),
              _ImageCard(),
              SizedBox(width: _cardsSpacing),
              _ImageCard(),
              SizedBox(width: _cardsSpacing),
              _ImageCard(),
              SizedBox(width: _cardsSpacing),
              _ImageCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({
    Key key,
  }) : super(key: key);

  static const _cardSize = 72.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _cardSize,
      height: _cardSize,
      decoration: BoxDecoration(
        color: placeholderColor,
        borderRadius: allBorderRadius12,
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
            onEditingComplete: () {
              moveFocus();
            },
            cursorColor: Theme.of(context).primaryColor,
            cursorHeight: 24.0,
            cursorWidth: 1,
            style: textRegular16.copyWith(
              color: Theme.of(context).primaryColor,
              height: lineHeight1_25,
            ),
            decoration: InputDecoration(
              hintText: hintText,
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
