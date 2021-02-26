import 'package:flutter/material.dart';
import 'package:places/ui/screens/sight_list/sight_list_screen.dart';

/// Миксин для логики сплеш-экрана
mixin SplashScreenLogic<SplashScreen extends StatefulWidget>
    on State<SplashScreen> {
  Future<bool> _isInitialized;

  @override
  void initState() {
    super.initState();

    _isInitialized = _initializeApp();
    _navigateToNext();
  }

  Future<bool> _initializeApp() {
    return Future(() => true);
  }

  void _navigateToNext() async {
    await Future.delayed(
      Duration(seconds: 2),
    );

    if (await _isInitialized) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SightListScreen(),
        ),
      );
    }
  }
}
