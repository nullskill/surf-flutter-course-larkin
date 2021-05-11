import 'package:flutter/material.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/widgets/rotated_logo.dart';
import 'package:places/util/app_init.dart';

/// Сплеш-экран
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppInitialization _appInit;
  Future<bool> _isInitialized;

  @override
  void initState() {
    super.initState();

    _isInitialized = _initializeApp();
    _navigateToNext();
  }

  Future<bool> _initializeApp() async {
    _appInit = AppInitialization();
    return Future(() => true);
  }

  Future<void> _navigateToNext() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    if (await _isInitialized) {
      await Navigator.of(context).pushNamedAndRemoveUntil(
        _appInit.isFirstRun ? AppRoutes.onboarding : AppRoutes.start,
        (_) => false,
      );
    }
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
