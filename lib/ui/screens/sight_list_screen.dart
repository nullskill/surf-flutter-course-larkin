import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/mocks.dart';

import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/screens/add_sight_screen.dart';

import 'package:places/ui/widgets/sight_card.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/app_floating_action_button.dart';

/// Экран отображения списка карточек интересных мест.
class SightListScreen extends StatefulWidget {
  static const pxl16 = 16.0;
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) {
    // print("needUpdate $needUpdate");
    return Scaffold(
      appBar: _SightListScreenAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SightListScreen.pxl16),
          child: _CardColumn(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AppFloatingActionButton(
        icon: SvgPicture.asset(
          AppIcons.plus,
          color: whiteColor,
        ),
        label: Text(
          sightListFabLabel.toUpperCase(),
          style: textBold14.copyWith(
            color: whiteColor,
            height: lineHeight1_3,
          ),
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSightScreen(),
            ),
          );
          setState(() {});
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
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
            left: SightListScreen.pxl16,
            right: SightListScreen.pxl16,
            bottom: SightListScreen.pxl16,
          ),
          child: Text(
            sightListAppBarTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textBold32.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
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
            height: SightListScreen.pxl16,
          ),
        ],
      ],
    );
  }
}
