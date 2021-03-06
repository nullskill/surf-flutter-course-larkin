import 'package:flutter/material.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screens/onboarding_screen.dart';
import 'package:places/ui/screens/settings_screen.dart';
import 'package:places/ui/screens/sight_list/sight_list_screen.dart';
import 'package:places/ui/screens/splash/splash_screen.dart';
import 'package:places/ui/screens/visiting/visiting_screen.dart';
import 'package:places/utils/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (
          context,
          ThemeNotifier notifier,
          child,
        ) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: notifier.darkTheme ? ThemeMode.dark : ThemeMode.light,
            title: appTitle,
            routes: {
              AppRoutes.home: (_) => SplashScreen(),
              AppRoutes.start: (_) => SightListScreen(),
              AppRoutes.map: (_) => Scaffold(),
              AppRoutes.visiting: (_) => VisitingScreen(),
              AppRoutes.settings: (_) => SettingsScreen(),
              AppRoutes.onboarding: (_) => OnboardingScreen(),
            },
          );
        },
      ),
    );
  }
}
