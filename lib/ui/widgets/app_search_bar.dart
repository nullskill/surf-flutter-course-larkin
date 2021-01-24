import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/res/assets.dart';

/// Виджет AppSearchBar предоставляет AppBar вместе с полем для поиска
class AppSearchBar extends StatelessWidget implements PreferredSizeWidget {
  static const pxl16 = 16.0;

  final Size preferredSize = Size.fromHeight(116);
  final String title;
  final bool readOnly;
  final Function onTap;

  AppSearchBar({
    Key key,
    @required this.title,
    this.readOnly = false,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + pxl16,
              bottom: pxl16,
            ),
            child: Text(
              title,
              style: textMedium18.copyWith(
                color: Theme.of(context).primaryColor,
                height: lineHeight1_3,
              ),
            ),
          ),
          _SearchBar(
            readOnly: readOnly,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    Key key,
    @required this.readOnly,
    @required this.onTap,
  }) : super(key: key);

  static const pxl8 = 8.0, pxl12 = 12.0, pxl40 = 40.0;

  final bool readOnly;
  final Function onTap;

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6.0,
        horizontal: 16.0,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: BaseProps.inputDecorationTheme.copyWith(
            filled: true,
            fillColor: Theme.of(context).backgroundColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: allBorderRadius12,
              borderSide: const BorderSide(
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: allBorderRadius12,
              borderSide: const BorderSide(
                style: BorderStyle.none,
              ),
            ),
          ),
        ),
        child: TextField(
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            isDense: true,
            hintText: searchBarHintText,
            hintStyle: textRegular16.copyWith(
              color: inactiveColor,
              height: lineHeight1_25,
            ),
            prefixIconConstraints: BoxConstraints(
              maxHeight: pxl40,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: pxl8,
                horizontal: pxl12,
              ),
              child: SvgPicture.asset(
                AppIcons.search,
                color: inactiveColor,
              ),
            ),
            suffixIconConstraints: BoxConstraints(
              maxHeight: pxl40,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: pxl8,
                horizontal: pxl12,
              ),
              child: readOnly
                  ? SvgPicture.asset(
                      AppIcons.filter,
                      color: Theme.of(context).buttonColor,
                    )
                  : SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
