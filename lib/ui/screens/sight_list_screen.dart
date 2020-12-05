import 'package:flutter/material.dart';

import 'package:places/utils/consts.dart';

class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(sightListScreenAppBarTitle),
      ),
      body: Center(
        child: const Text(sightListScreenBody),
      ),
      drawer: Container(
        width: 250,
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(sightListScreenDrawer),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Scaffold FAB");
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
          child: const Text(sightListScreenBottomNavigationBar),
        ),
      ),
    );
  }
}
