import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/ui/res/border_radiuses.dart';
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
  const _AddSightBody({
    Key key,
  }) : super(key: key);

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
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                addSightCategoryTitle.toUpperCase(),
                style: textRegular12.copyWith(
                  color: inactiveColor,
                  height: lineHeight1_3,
                ),
              ),
            ),
            SettingsItem(
              title: addSightNoCategoryTitle,
              isGreyedOut: true,
              onTap: () {
                print("category selection tapped");
              },
              trailing: SvgPicture.asset(
                AppIcons.view,
                width: 24,
                height: 24,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Divider(
              height: .8,
            ),
          ],
        ),
      ),
    );
  }
}
