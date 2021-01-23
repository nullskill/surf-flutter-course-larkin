import 'package:flutter/material.dart';

import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/themes.dart';

/// Виджет SearchBar предоставляет поле для поиска
class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    this.readOnly = false,
    @required this.onTap,
  }) : super(key: key);

  final bool readOnly;
  final Function onTap;

  @override
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
        ),
      ),
    );
  }
}
