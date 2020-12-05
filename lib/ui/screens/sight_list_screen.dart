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
      backgroundColor: sightListScreenBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        toolbarHeight: 136.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 120.0),
                  child: RichText(
                    maxLines: 2,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto",
                        color: sightListScreenTitleColor,
                      ),
                      children: [
                        TextSpan(
                          text: "C",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                          children: [
                            TextSpan(
                              text: "писок",
                              style: TextStyle(
                                color: sightListScreenTitleColor,
                              ),
                            ),
                          ],
                        ),
                        TextSpan(
                          text: "\nи",
                          style: TextStyle(
                            color: Colors.amberAccent,
                          ),
                          children: [
                            TextSpan(
                              text: "нтересных мест",
                              style: TextStyle(
                                color: sightListScreenTitleColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: const Text(sightListScreenBody),
      ),
      drawer: Container(
        width: 250.0,
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
