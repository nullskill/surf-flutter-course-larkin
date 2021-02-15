import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _OnboardingAppBar(),
      body: PageView(
        children: [
          _Frame(
            title: "Добро пожаловать\nв Путеводитель",
            iconName: AppIcons.frame1,
            message: "Ищи новые локации и сохраняй\nсамые любимые.",
          ),
          _Frame(
            title: "Добро пожаловать\nв Путеводитель",
            iconName: AppIcons.frame1,
            message: "Ищи новые локации и сохраняй\nсамые любимые.",
          ),
          _Frame(
            title: "Добро пожаловать\nв Путеводитель",
            iconName: AppIcons.frame1,
            message: "Ищи новые локации и сохраняй\nсамые любимые.",
          ),
        ],
      ),
    );
  }
}

class _OnboardingAppBar extends StatelessWidget implements PreferredSizeWidget {
  _OnboardingAppBar({
    Key key,
  }) : super(key: key);

  final Size preferredSize = Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Center(
          child: _SkipButton(),
        ),
      ],
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        // TODO: Добавить обработчик нажатия
      },
      child: Text(
        onboardingSkipButtonLabel,
        style: textMedium16.copyWith(
          color: Theme.of(context).buttonColor,
          height: lineHeight1_25,
        ),
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({
    Key key,
    @required this.title,
    @required this.iconName,
    @required this.message,
  }) : super(key: key);

  final String title, iconName, message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconName,
            width: 104.0,
            height: 104.0,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 40.0,
          ),
          Text(
            title,
            style: textBold24.copyWith(
              color: Theme.of(context).primaryColor,
              height: lineHeight1_2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 253.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: textRegular14.copyWith(
                    color: secondaryColor2,
                    height: lineHeight1_3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
