import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/widgets/app_back_button.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/settings_item.dart';
import 'package:provider/provider.dart';

/// Экран настроек
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _SettingsAppBar(),
      body: _SettingsBody(),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 3,
      ),
    );
  }
}

class _SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SettingsAppBar({
    Key key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const AppBackButton(),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            Consumer<SettingsInteractor>(
              builder: (
                context,
                notifier,
                child,
              ) =>
                  SettingsItem(
                title: settingsThemeSettingTitle,
                paddingValue: 10,
                onTap: () => _onChanged(notifier),
                trailing: CupertinoSwitch(
                  value: notifier.isDarkTheme,
                  onChanged: (_) => _onChanged(notifier),
                ),
              ),
            ),
            SettingsItem(
              title: settingsWatchTutorialTitle,
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.onboarding);
              },
              trailing: GestureDetector(
                onTap: () {
                  // TODO: Make tutorial info show
                },
                child: SvgPicture.asset(
                  AppIcons.info,
                  width: 24.0,
                  height: 24.0,
                  color: Theme.of(context).buttonColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onChanged(SettingsInteractor notifier) {
    notifier.toggleTheme();
  }
}
