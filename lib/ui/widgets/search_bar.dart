import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:sized_context/sized_context.dart';

/// Виджет SearchBar предоставляет поле для поиска
class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    this.readOnly,
    this.autofocus,
    this.hasClearButton = false,
    this.onTap,
    this.onEditingComplete,
    this.onFilter,
    this.searchFocusNode,
    this.searchController,
  }) : super(key: key);

  final bool readOnly;
  final bool autofocus;
  final bool hasClearButton;
  final void Function() onTap;
  final void Function() onEditingComplete;
  final void Function() onFilter;
  final FocusNode searchFocusNode;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 6.0,
        horizontal: context.isLandscape ? 34.0 : 16.0,
      ),
      child: Stack(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
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
              readOnly: readOnly ?? false,
              autofocus: autofocus ?? false,
              onTap: onTap,
              onEditingComplete: onEditingComplete,
              focusNode: searchFocusNode,
              controller: searchController,
              cursorColor: Theme.of(context).primaryColor,
              cursorHeight: 24.0,
              cursorWidth: 1,
              style: textRegular16.copyWith(
                color: Theme.of(context).primaryColor,
                height: lineHeight1_5,
              ),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                hintText: searchBarHintText,
                hintStyle: textRegular16.copyWith(
                  color: inactiveColor,
                  height: lineHeight1_5,
                ),
                prefixIconConstraints: const BoxConstraints(
                  maxHeight: 40.0,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: SvgPicture.asset(
                    AppIcons.search,
                    color: inactiveColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8.0,
            right: 12.0,
            child: _SuffixIcon(
              readOnly: readOnly,
              hasClearButton: hasClearButton,
              onFilter: onFilter,
              onClear: () {
                searchController?.clear();
                searchFocusNode?.requestFocus();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SuffixIcon extends StatelessWidget {
  const _SuffixIcon({
    @required this.hasClearButton,
    this.readOnly,
    this.onFilter,
    this.onClear,
    Key key,
  }) : super(key: key);

  final bool readOnly;
  final bool hasClearButton;
  final void Function() onFilter;
  final void Function() onClear;

  @override
  Widget build(BuildContext context) {
    return readOnly ?? false
        ? TextButton(
            style: TextButton.styleFrom(
              minimumSize: const Size(24.0, 24.0),
              padding: EdgeInsets.zero,
              backgroundColor: transparentColor,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: allBorderRadius8),
            ),
            onPressed: onFilter,
            child: SvgPicture.asset(
              AppIcons.filter,
              color: Theme.of(context).buttonColor,
            ),
          )
        : hasClearButton
            ? GestureDetector(
                onTap: onClear,
                child: SvgPicture.asset(
                  AppIcons.clear,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : const SizedBox.shrink();
  }
}
