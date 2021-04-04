import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screens/error_screen.dart';
import 'package:places/ui/screens/onboarding_screen.dart';
import 'package:places/ui/screens/settings_screen.dart';
import 'package:places/ui/screens/sight_list/sight_list_screen.dart';
import 'package:places/ui/screens/splash_screen.dart';
import 'package:places/ui/screens/visiting/visiting_screen.dart';
import 'package:places/util/consts.dart';
import 'package:provider/provider.dart';

void main() {
  if (isReleaseMode) {
    debugPrint = (message, {wrapWidth}) {};
  }
  runApp(
    DevicePreview(
      enabled: !isReleaseMode,
      builder: (_) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsInteractor(),
      child: Consumer<SettingsInteractor>(
        builder: (context, notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: DevicePreview.locale(context),
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
  AppRoutes.home: (_) => const SplashScreen(),
  AppRoutes.start: (_) => const SightListScreen(),
  AppRoutes.map: (_) => const Scaffold(),
  AppRoutes.visiting: (_) => const VisitingScreen(),
  AppRoutes.settings: (_) => const SettingsScreen(),
  AppRoutes.onboarding: (_) => const OnboardingScreen(),
  AppRoutes.error: (_) => const ErrorScreen(),
};
