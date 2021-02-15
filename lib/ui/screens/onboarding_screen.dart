import 'package:flutter/material.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _OnboardingAppBar(),
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
