import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:places/utils/theme_provider.dart';
import 'package:places/ui/res/themes.dart';

import 'package:places/ui/screens/visiting/visiting_screen.dart';

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
            title: "Places",
            home: VisitingScreen(),
          );
        },
      ),
    );
  }
}
