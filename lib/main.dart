import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screens/onboarding_screen.dart';
import 'package:places/ui/screens/settings_screen.dart';
import 'package:places/ui/screens/sight_list/sight_list_screen.dart';
import 'package:places/ui/screens/splash_screen.dart';
import 'package:places/ui/screens/visiting/visiting_screen.dart';
import 'package:places/util/consts.dart';
import 'package:places/util/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !isReleaseMode,
      builder: (_) => App(),
    ),
  );
}

// ignore: use_key_in_widget_constructors
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: DevicePreview.locale(context), // Add the locale here
            builder: DevicePreview.appBuilder,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: notifier.darkTheme ? ThemeMode.dark : ThemeMode.light,
            title: appTitle,
            routes: _routesMap,
          );
        },
      ),
    );
  }
}

final _routesMap = <String, Widget Function(BuildContext)>{
  AppRoutes.home: (_) => SplashScreen(),
  AppRoutes.start: (_) => SightListScreen(),
  AppRoutes.map: (_) => const Scaffold(),
  AppRoutes.visiting: (_) => VisitingScreen(),
  AppRoutes.settings: (_) => const SettingsScreen(),
  AppRoutes.onboarding: (_) => OnboardingScreen(),
};
