import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/domain/category.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/app_back_button.dart';
import 'package:places/ui/widgets/settings_item.dart';

/// Экран выбора категории.
class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({Key key, this.selectedCategory})
      : super(key: key);

  final Category selectedCategory;

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
      appBar: const _SelectCategoryAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 24.0,
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
                      ? const SizedBox(height: 24.0)
                      : SvgPicture.asset(
                          AppIcons.tick,
                          width: 24.0,
                          height: 24.0,
                          color: Theme.of(context).buttonColor,
                        ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          16.0,
          8.0,
          16.0,
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
  const _SelectCategoryAppBar({
    Key key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const AppBackButton(),
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
