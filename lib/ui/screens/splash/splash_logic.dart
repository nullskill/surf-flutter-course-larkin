import 'package:flutter/material.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/utils/app_init.dart';

/// Миксин для логики сплеш-экрана
mixin SplashScreenLogic<SplashScreen extends StatefulWidget>
    on State<SplashScreen> {
  AppInitialization _appInit;
  Future<bool> _isInitialized;

  @override
  void initState() {
    super.initState();

    _isInitialized = _initializeApp();
    _navigateToNext();
  }

  Future<bool> _initializeApp() async {
    _appInit = await AppInitialization();
    return Future(() => true);
  }

  void _navigateToNext() async {
    await Future.delayed(
      Duration(seconds: 2),
    );
    if (await _isInitialized) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        _appInit.firstRun ? AppRoutes.onboarding : AppRoutes.start,
        (_) => false,
      );
    }
  }
}
