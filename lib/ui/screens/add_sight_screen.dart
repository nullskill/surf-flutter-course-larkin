import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/settings_item.dart';

class AddSightScreen extends StatelessWidget {
  static const pxl8 = 8.0;
  static const pxl16 = 16.0;
  static const pxl24 = 24.0;
  static const pxl56 = 56.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AddSightAppBar(),
      body: _AddSightBody(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: pxl16,
          vertical: pxl8,
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
          vertical: 10.0,
        ),
        child: FlatButton(
          onPressed: () {
            print("Cancel button pressed");
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
  }) : super(key: key);

  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeLatitude = FocusNode();
  final FocusNode focusNodeLongitude = FocusNode();

  void moveFocus() {
    if (focusNodeName.hasFocus) {
      focusNodeLatitude.requestFocus();
    } else if (focusNodeLatitude.hasFocus) {
      focusNodeLongitude.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AddSightScreen.pxl16,
          vertical: AddSightScreen.pxl24,
        ),
        child: Column(
          children: [
            _AddSightSubtitle(
              subtitle: addSightCategoryTitle,
            ),
            SettingsItem(
              title: addSightNoCategoryTitle,
              isGreyedOut: true,
              onTap: () {
                print("category selection tapped");
              },
              trailing: SvgPicture.asset(
                AppIcons.view,
                width: AddSightScreen.pxl24,
                height: AddSightScreen.pxl24,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Divider(
              height: .8,
            ),
            _AddSightTextField(
              title: addSightNameTitle,
              focusNode: focusNodeName,
              moveFocus: moveFocus,
            ),
            Row(
              children: [
                Expanded(
                  child: _AddSightTextField(
                    title: addSightLatitudeTitle,
                    focusNode: focusNodeLatitude,
                    moveFocus: moveFocus,
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: _AddSightTextField(
                    title: addSightLongitudeTitle,
                    focusNode: focusNodeLongitude,
                    moveFocus: moveFocus,
                  ),
                ),
              ],
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
    @required this.focusNode,
    @required this.moveFocus,
  }) : super(key: key);

  final String title;
  final FocusNode focusNode;
  final Function moveFocus;

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
          child: TextField(
            focusNode: focusNode,
            onEditingComplete: () {
              moveFocus();
            },
            style: textRegular16.copyWith(
              color: Theme.of(context).primaryColor,
              height: lineHeight1_25,
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
