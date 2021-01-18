import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/domain/sight.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/screens/select_category_screen.dart';

import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/settings_item.dart';

/// Экран добавления интересного места.
class AddSightScreen extends StatefulWidget {
  static const pxl8 = 8.0,
      pxl10 = 10.0,
      pxl16 = 16.0,
      pxl24 = 24.0,
      pxl56 = 56.0;

  @override
  _AddSightScreenState createState() => _AddSightScreenState();
}

class _AddSightScreenState extends State<AddSightScreen> {
  final controllers = <String, TextEditingController>{
    "name": TextEditingController(),
    "latitude": TextEditingController(),
    "longitude": TextEditingController(),
    "description": TextEditingController(),
  };

  final focusNodes = <String, FocusNode>{
    "name": FocusNode(),
    "latitude": FocusNode(),
    "longitude": FocusNode(),
    "description": FocusNode(),
  };

  FocusNode currentFocusNode;
  Category selectedCategory;

  @override
  void initState() {
    super.initState();

    for (var entry in focusNodes.entries)
      entry.value.addListener(() => focusNodeListener(entry.key));
    for (var entry in controllers.entries)
      entry.value.addListener(() => controllerListener(entry.key));
  }

  @override
  void dispose() {
    for (var focusNode in focusNodes.values) focusNode.dispose();
    for (var controller in focusNodes.values) controller.dispose();

    super.dispose();
  }

  void focusNodeListener(String focusNodeName) {
    setState(() {
      currentFocusNode = focusNodes[focusNodeName];
    });
  }

  void controllerListener(String controllerName) {
    setState(() {});
  }

  void moveFocus() {
    if (focusNodes["name"].hasFocus) {
      focusNodes["latitude"].requestFocus();
    } else if (focusNodes["latitude"].hasFocus) {
      focusNodes["longitude"].requestFocus();
    } else if (focusNodes["longitude"].hasFocus) {
      focusNodes["description"].requestFocus();
    }
  }

  void setSelectedCategory(selectedCategory) {
    setState(() {
      this.selectedCategory = selectedCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AddSightAppBar(),
      body: _AddSightBody(
        controllers: controllers,
        focusNodes: focusNodes,
        currentFocusNode: currentFocusNode,
        moveFocus: moveFocus,
        selectedCategory: selectedCategory,
        setSelectedCategory: setSelectedCategory,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AddSightScreen.pxl16,
          vertical: AddSightScreen.pxl8,
        ),
        child: ActionButton(
          label: addSightActionButtonLabel,
          isDisabled: true,
          // isDisabled: false,
        ),
      ),
    );
  }
}

class _AddSightAppBar extends StatelessWidget implements PreferredSizeWidget {
  _AddSightAppBar({
    Key key,
  }) : super(key: key);

  final Size preferredSize = Size.fromHeight(AddSightScreen.pxl56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AddSightScreen.pxl10,
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
    this.selectedCategory,
    @required this.setSelectedCategory,
  }) : super(key: key);

  final Map<String, TextEditingController> controllers;
  final Map<String, FocusNode> focusNodes;
  final FocusNode currentFocusNode;
  final Function moveFocus;
  final Category selectedCategory;
  final Function setSelectedCategory;

  bool hasClearButton(fieldName) =>
      currentFocusNode == focusNodes[fieldName] &&
      controllers[fieldName].text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AddSightScreen.pxl16,
          vertical: AddSightScreen.pxl24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AddSightSubtitle(
              subtitle: addSightCategoryTitle,
            ),
            SettingsItem(
              title: selectedCategory?.name ?? addSightNoCategoryTitle,
              isGreyedOut: true,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectCategoryScreen(
                        selectedCategory: selectedCategory),
                  ),
                );
                result != null && setSelectedCategory(result);
              },
              trailing: SvgPicture.asset(
                AppIcons.view,
                width: AddSightScreen.pxl24,
                height: AddSightScreen.pxl24,
                color: Theme.of(context).primaryColor,
              ),
            ),
            _AddSightTextField(
              title: addSightNameTitle,
              controller: controllers["name"],
              focusNode: focusNodes["name"],
              moveFocus: moveFocus,
              hasClearButton: hasClearButton("name"),
            ),
            Row(
              children: [
                Expanded(
                  child: _AddSightTextField(
                    title: addSightLatitudeTitle,
                    controller: controllers["latitude"],
                    focusNode: focusNodes["latitude"],
                    moveFocus: moveFocus,
                    hasClearButton: hasClearButton("latitude"),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: AddSightScreen.pxl16,
                ),
                Expanded(
                  child: _AddSightTextField(
                    title: addSightLongitudeTitle,
                    controller: controllers["longitude"],
                    focusNode: focusNodes["longitude"],
                    moveFocus: moveFocus,
                    hasClearButton: hasClearButton("longitude"),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 13.0),
              child: GestureDetector(
                onTap: () {
                  print("Select on map tapped");
                },
                child: Text(
                  addSightSelectOnMapTitle,
                  style: textMedium16.copyWith(
                    color: Theme.of(context).buttonColor,
                    height: lineHeight1_25,
                  ),
                ),
              ),
            ),
            _AddSightTextField(
              title: addSightDescriptionTitle,
              hintText: addSightDescriptionHintText,
              maxLines: 4,
              controller: controllers["description"],
              focusNode: focusNodes["description"],
              moveFocus: moveFocus,
              hasClearButton: hasClearButton("description"),
            ),
          ],
        ),
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
    this.keyboardType,
    this.hasClearButton = false,
  }) : super(key: key);

  static const pxl40 = 40.0;

  final String title;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function moveFocus;
  final int maxLines;
  final String hintText;
  final TextInputType keyboardType;
  final bool hasClearButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AddSightScreen.pxl24),
          child: _AddSightSubtitle(
            subtitle: title,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: TextFormField(
            scrollPadding: const EdgeInsets.all(100.0),
            maxLines: maxLines ?? 1,
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            onEditingComplete: () {
              moveFocus();
            },
            cursorColor: Theme.of(context).primaryColor,
            cursorHeight: AddSightScreen.pxl24,
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
                      padding: const EdgeInsets.all(AddSightScreen.pxl10),
                      child: GestureDetector(
                        onTap: () {
                          controller.clear();
                        },
                        child: SvgPicture.asset(
                          AppIcons.clear,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
              suffixIconConstraints: BoxConstraints(
                maxHeight: pxl40,
                maxWidth: pxl40,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddSightSubtitle extends StatelessWidget {
  const _AddSightSubtitle({
    Key key,
    @required this.subtitle,
  }) : super(key: key);

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        subtitle.toUpperCase(),
        style: textRegular12.copyWith(
          color: inactiveColor,
          height: lineHeight1_3,
        ),
      ),
    );
  }
}
