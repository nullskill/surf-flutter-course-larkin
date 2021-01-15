import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:places/utils/theme_provider.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/widgets/app_back_button.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/settings_item.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SettingsAppBar(),
      body: _SettingsBody(),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 3,
      ),
    );
  }
}

class _SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  _SettingsAppBar({
    Key key,
  }) : super(key: key);

  final Size preferredSize = Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: AppBackButton(),
      title: Text(
        settingsAppBarTitle,
        style: textMedium18.copyWith(
          color: Theme.of(context).primaryColor,
          height: lineHeight1_3,
        ),
      ),
      centerTitle: true,
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({
    Key key,
  }) : super(key: key);

  static const pxl0_8 = .8;
  static const pxl24 = 24.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: pxl24),
        child: Column(
          children: [
            SettingsItem(
              title: settingsThemeSettingTitle,
              paddingValue: 10,
              trailing: Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => CupertinoSwitch(
                  value: notifier.darkTheme,
                  onChanged: (newValue) {
                    notifier.toggleTheme();
                  },
                ),
              ),
            ),
            Divider(
              height: pxl0_8,
            ),
            SettingsItem(
              title: settingsWatchTutorialTitle,
              trailing: GestureDetector(
                onTap: () {
                  print("Show tutorial pressed");
                },
                child: SvgPicture.asset(
                  AppIcons.info,
                  width: pxl24,
                  height: pxl24,
                  color: Theme.of(context).buttonColor,
                ),
              ),
            ),
            Divider(
              height: pxl0_8,
            ),
          ],
        ),
      ),
    );
  }
}
