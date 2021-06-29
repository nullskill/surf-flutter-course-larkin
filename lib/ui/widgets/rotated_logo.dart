import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/colors.dart';

/// Виджет для отображения вращающегося лого
class RotatedLogo extends StatefulWidget {
  const RotatedLogo({
    @required this.size,
    this.lapDuration = 1600,
    Key key,
  }) : super(key: key);

  static const easeInCurve = Interval(.003, 1.0, curve: Curves.easeIn);
  static const easeOutCurve = Interval(.003, 1.0, curve: Curves.easeOut);

  final double size;
  final int lapDuration;

  @override
  _RotatedLogo createState() => _RotatedLogo();
}

class _RotatedLogo extends State<RotatedLogo>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.lapDuration),
    )..repeat();

    animation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 0.5)
              .chain(CurveTween(curve: RotatedLogo.easeInCurve)),
          weight: 50.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 0.5)
              .chain(CurveTween(curve: RotatedLogo.easeOutCurve)),
          weight: 50.0),
    ]).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns:
          // animation,
          Tween<double>(begin: 1.0, end: 0.0).animate(
              CurvedAnimation(parent: controller, curve: Curves.easeInOut)),
      child: Center(
        child: SvgPicture.asset(
          AppIcons.logo,
          width: widget.size,
          height: widget.size,
          color: whiteColor,
        ),
      ),
    );
  }
}
