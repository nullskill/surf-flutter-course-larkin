import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';

import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/assets.dart';

import 'package:places/ui/widgets/app_back_button.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/settings_item.dart';

/// Экран выбора категории.
class SelectCategoryScreen extends StatefulWidget {
  static const pxl8 = 8.0, pxl16 = 16.0, pxl24 = 24.0;

  final Category selectedCategory;

  const SelectCategoryScreen({Key key, this.selectedCategory})
      : super(key: key);

  @override
  _SelectCategoryScreenState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  Category selectedCategory;

  @override
  void initState() {
    super.initState();

    selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SelectCategoryAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SelectCategoryScreen.pxl16,
            vertical: SelectCategoryScreen.pxl24,
          ),
          child: Column(
            children: [
              for (var category in categories)
                SettingsItem(
                  title: category.name,
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  trailing: selectedCategory != category
                      ? SizedBox(
                          height: SelectCategoryScreen.pxl24,
                        )
                      : SvgPicture.asset(
                          AppIcons.tick,
                          width: SelectCategoryScreen.pxl24,
                          height: SelectCategoryScreen.pxl24,
                          color: Theme.of(context).buttonColor,
                        ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          SelectCategoryScreen.pxl16,
          SelectCategoryScreen.pxl8,
          SelectCategoryScreen.pxl16,
          MediaQuery.of(context).padding.bottom + 8.0,
        ),
        child: ActionButton(
          label: selectCategoryActionButtonLabel,
          isDisabled: selectedCategory == null,
          onPressed: () => Navigator.pop(context, selectedCategory),
          // isDisabled: false,
        ),
      ),
    );
  }
}

class _SelectCategoryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  _SelectCategoryAppBar({
    Key key,
  }) : super(key: key);

  final Size preferredSize = Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: AppBackButton(),
      title: Text(
        selectCategoryAppBarTitle,
        style: textMedium18.copyWith(
          color: Theme.of(context).primaryColor,
          height: lineHeight1_3,
        ),
      ),
      centerTitle: true,
    );
  }
}
