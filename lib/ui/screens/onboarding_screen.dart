import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/data/interactor/onboarding_interactor.dart';
import 'package:places/domain/tutorial_frame.dart';
import 'package:places/domain/tutorial_frames.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:provider/provider.dart';

/// Экран, обучающий работе с приложением
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;

  void onPageChanged(int value) {
    setState(() {
      currentPage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLastFrame = currentPage == tutorialFrames.length - 1;

    return Scaffold(
      appBar: _OnboardingAppBar(isLastFrame: isLastFrame),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: onPageChanged,
              itemCount: tutorialFrames.length,
              itemBuilder: (context, index) {
                final TutorialFrame frame = tutorialFrames[index];
                return _Frame(
                  isActiveFrame: currentPage == index,
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
              (index) => _FrameIndicator(isActiveFrame: currentPage == index),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _BottomNavigationBar(isLastFrame: isLastFrame),
    );
  }
}

class _OnboardingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _OnboardingAppBar({
    @required this.isLastFrame,
    Key key,
  }) : super(key: key);

  final bool isLastFrame;

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        Center(
          child: AnimatedOpacity(
            opacity: isLastFrame ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: _SkipButton(isLastFrame: isLastFrame),
          ),
        ),
      ],
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({
    @required this.isLastFrame,
    Key key,
  }) : super(key: key);

  final bool isLastFrame;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLastFrame ? null : () => _startApp(context),
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

class _Frame extends StatefulWidget {
  const _Frame({
    @required this.isActiveFrame,
    @required this.title,
    @required this.iconName,
    @required this.message,
    @required this.index,
    @required this.length,
    Key key,
  }) : super(key: key);

  final bool isActiveFrame;
  final String title, iconName, message;
  final int index, length;

  @override
  _FrameState createState() => _FrameState();
}

class _FrameState extends State<_Frame> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> opacity;
  Animation<double> width;
  Animation<double> height;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );

    width = Tween<double>(begin: 0.0, end: 104.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );

    height = Tween<double>(begin: 0.0, end: 104.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );
    playAnimation();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_Frame oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActiveFrame != oldWidget.isActiveFrame) {
      if (widget.isActiveFrame) {
        playAnimation();
      } else {
        reverseAnimation();
      }
    }
  }

  Future<void> playAnimation() async {
    await Future<void>.delayed(const Duration(milliseconds: 2));
    try {
      await controller.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  Future<void> reverseAnimation() async {
    try {
      await controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Opacity(
                opacity: opacity.value,
                child: SvgPicture.asset(
                  widget.iconName,
                  width: width.value,
                  height: height.value,
                  color: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
          const SizedBox(height: 40.0),
          Text(
            widget.title,
            style: textBold24.copyWith(
              color: Theme.of(context).primaryColor,
              height: lineHeight1_2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 244,
            child: Column(
              children: [
                Text(
                  widget.message,
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
    @required this.isActiveFrame,
    Key key,
  }) : super(key: key);

  final bool isActiveFrame;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: isActiveFrame ? 20 : 6,
      decoration: BoxDecoration(
        color: isActiveFrame ? Theme.of(context).buttonColor : inactiveColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    Key key,
    this.isLastFrame,
  }) : super(key: key);

  final bool isLastFrame;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.0,
        8.0,
        16.0,
        MediaQuery.of(context).padding.bottom + 8.0,
      ),
      child: AnimatedOpacity(
        opacity: isLastFrame ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: ActionButton(
          label: startActionButtonLabel,
          onPressed: !isLastFrame ? null : () => _startApp(context),
        ),
      ),
    );
  }
}

void _startApp(BuildContext context) {
  context.read<OnboardingInteractor>().tutorialFinished();
  Navigator.of(context).pushNamedAndRemoveUntil(
    AppRoutes.start,
    (_) => false,
  );
}
