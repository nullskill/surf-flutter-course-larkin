import 'package:flutter/material.dart';
import 'package:places/data/interactor/onboarding_interactor.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/widgets/rotated_logo.dart';
import 'package:provider/provider.dart';

/// Сплеш-экран
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future<void>.delayed(const Duration(seconds: 4));
    await Navigator.of(context).pushNamedAndRemoveUntil(
      context.read<OnboardingInteractor>().isFirstRun
          ? AppRoutes.onboarding
          : AppRoutes.start,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: LightMode.greenColor,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              LightMode.yellowColor.withOpacity(.6),
              LightMode.yellowColor.withOpacity(.1),
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: const RotatedLogo(size: 160.0),
      ),
    );
  }
}
