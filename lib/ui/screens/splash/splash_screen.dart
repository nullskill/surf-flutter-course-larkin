import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/screens/splash/splash_logic.dart';

/// Сплеш-экран
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SplashScreenLogic {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LightMode.greenColor,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              LightMode.yellowColor.withOpacity(.6),
              LightMode.yellowColor.withOpacity(.1),
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            AppIcons.logo,
            width: 160.0,
            height: 160.0,
            color: whiteColor,
          ),
        ),
      ),
    );
  }
}
