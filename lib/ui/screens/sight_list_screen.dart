import 'package:flutter/material.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';

import 'package:places/mocks.dart';

import 'package:places/ui/widgets/sight_card.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';

/// Экран отображения списка карточек интересных мест.
class SightListScreen extends StatefulWidget {
  final Function changeThemeMode;
  // Don't like this but since we haven't covered state architecture yet...
  SightListScreen({@required this.changeThemeMode});

  @override
  _SightListScreenState createState() =>
      _SightListScreenState(changeThemeMode: changeThemeMode);
}

class _SightListScreenState extends State<SightListScreen> {
  final Function changeThemeMode;
  // Don't like this but since we haven't covered state architecture yet...
  _SightListScreenState({@required this.changeThemeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SightListScreenAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _CardColumn(),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          changeThemeMode();
        },
        label: Text(
          "Switch Theme",
        ),
      ),
    );
  }
}

class _SightListScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Size preferredSize = Size.fromHeight(152);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Text(
            sightListScreenText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textBold32.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}

class _CardColumn extends StatelessWidget {
  const _CardColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var sight in mocks) ...[
          SightCard(sight: sight),
          SizedBox(
            height: 16,
          ),
        ],
      ],
    );
  }
}
