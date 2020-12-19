import 'package:flutter/material.dart';

class VisitingScreen extends StatefulWidget {
  @override
  _VisitingScreenState createState() => _VisitingScreenState();
}

class _VisitingScreenState extends State<VisitingScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            Center(
              child: Text("Tab 1 Content"),
            ),
            Center(
              child: Text("Tab 2 Content"),
            ),
          ],
        ),
      ),
    );
  }
}
