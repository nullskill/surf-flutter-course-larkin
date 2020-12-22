import 'package:flutter/material.dart';

import 'package:places/ui/screens/visiting_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My first App",
      home: VisitingScreen(),
    );
  }
}
