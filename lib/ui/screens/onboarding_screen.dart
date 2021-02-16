import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/domain/tutorial_frame.dart';
import 'package:places/domain/tutorial_frames.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _OnboardingAppBar(),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (int value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemCount: tutorialFrames.length,
              itemBuilder: (BuildContext context, int index) {
                TutorialFrame frame = tutorialFrames[index];
                return _Frame(
                  iconName: frame.iconName,
                  title: frame.title,
                  message: frame.message,
                  length: tutorialFrames.length,
                  index: index,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              tutorialFrames.length,
              (index) =>
                  _FrameIndicator(currentPage: currentPage, index: index),
            ),
          ),
          SizedBox(
            height: 88,
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
    @required this.index,
    @required this.length,
  }) : super(key: key);

  final String title, iconName, message;
  final int index, length;

  @override
  // ignore: long-method
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
            width: 244,
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

class _FrameIndicator extends StatelessWidget {
  const _FrameIndicator({
    Key key,
    @required this.index,
    @required this.currentPage,
  }) : super(key: key);

  final int index, currentPage;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index
            ? Theme.of(context).buttonColor
            : inactiveColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
