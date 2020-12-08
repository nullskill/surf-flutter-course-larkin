import 'package:flutter/material.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/text_styles.dart';

class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
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
                Text(
                  sightListScreenText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textBold32.copyWith(
                    fontFamily: "Roboto",
                    color: titleColorPrimary,
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
          print("");
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
