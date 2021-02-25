import 'package:flutter/material.dart';
import 'package:places/ui/screens/sight_list/sight_list_screen.dart';

/// Миксин для логики сплеш-экрана
mixin SplashScreenLogic<SplashScreen extends StatefulWidget>
    on State<SplashScreen> {
  Future<bool> _isInitialized;

  @override
  void initState() {
    _navigateToNext();

    super.initState();
  }

  void _navigateToNext() async {
    _isInitialized = await Future.delayed(
      Duration(seconds: 2),
      () => _initializeApp(),
    );

    if (await _isInitialized) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SightListScreen(),
        ),
      );
    }
  }

  Future<bool> _initializeApp() {
    return Future(() => true);
  }
}
