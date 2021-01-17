import 'package:flutter/material.dart';
import 'package:places/ui/screens/sight_list_screen.dart';

import 'package:provider/provider.dart';

import 'package:places/utils/theme_provider.dart';
import 'package:places/ui/res/themes.dart';

// import 'package:places/ui/screens/visiting_screen.dart';
// import 'package:places/ui/screens/sight_details_screen.dart';
// import 'package:places/ui/screens/sight_list_screen.dart';
// import 'package:places/ui/screens/settings_screen.dart';
// import 'package:places/ui/screens/filters_screen/filters_screen.dart';
import 'package:places/ui/screens/add_sight_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          print(notifier.darkTheme);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: notifier.darkTheme ? ThemeMode.dark : ThemeMode.light,
            title: "Places",
            // home: SettingsScreen(),
            home: AddSightScreen(),
          );
        },
      ),
    );
  }
}
