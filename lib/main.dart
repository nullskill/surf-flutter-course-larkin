import 'package:flutter/material.dart';

import 'package:places/ui/res/themes.dart';

// import 'package:places/ui/screens/visiting_screen.dart';
// import 'package:places/ui/screens/sight_details.dart';
// import 'package:places/ui/screens/sight_list_screen.dart';
import 'package:places/ui/screens/filters_screen/filters_screen.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      title: "My first App",
      // home: SightDetails(changeThemeMode: changeThemeMode),
      home: FiltersScreen(),
    );
  }

  void changeThemeMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }
}
