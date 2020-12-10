import 'package:flutter/material.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/screens/sight_card.dart';

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
                  style: textBold32,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: CardColumn(),
        ),
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
    );
  }
}

class CardColumn extends StatelessWidget {
  const CardColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = [];

    for (var sight in mocks) {
      cards.add(
        SizedBox(
          height: 16,
        ),
      );
      cards.add(SightCard(sight: sight));
    }
    cards.add(
      SizedBox(
        height: 16,
      ),
    );

    return Column(
      children: cards,
    );
  }
}
