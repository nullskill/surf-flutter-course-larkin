import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/add_sight/add_sight_screen.dart';
import 'package:places/ui/screens/filters/filters_screen.dart';
import 'package:places/ui/screens/sight_search/sight_search_screen.dart';
import 'package:places/ui/widgets/app_bottom_navigation_bar.dart';
import 'package:places/ui/widgets/app_floating_action_button.dart';
import 'package:places/ui/widgets/app_search_bar.dart';
import 'package:places/ui/widgets/sight_card.dart';

/// Экран отображения списка карточек интересных мест.
class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  List<Sight> _sights;

  @override
  void initState() {
    super.initState();

    _sights = mocks;
  }

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppSearchBar(
        title: sightListAppBarTitle,
        readOnly: true,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SightSearchScreen(),
            ),
          );
        },
        onFilter: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FiltersScreen(),
            ),
          );
          setState(() {
            _sights = getFilteredMocks();
          });
        },
      ),
      body: _CardColumn(
        sights: _sights,
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

class _CardColumn extends StatelessWidget {
  const _CardColumn({
    Key key,
    @required this.sights,
  }) : super(key: key);

  final List<Sight> sights;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: sights.length,
      itemBuilder: (context, index) {
        return SightCard(sight: sights[index]);
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 16.0,
        );
      },
      padding: const EdgeInsets.all(16.0),
    );
  }
}
