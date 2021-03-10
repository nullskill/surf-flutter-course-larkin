import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:places/domain/category.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/add_sight/add_sight_bloc.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/clear_button.dart';
import 'package:places/ui/widgets/link.dart';
import 'package:places/ui/widgets/settings_item.dart';
import 'package:places/ui/widgets/subtitle.dart';

/// Экран добавления нового места.
class AddSightScreen extends StatelessWidget {
  AddSightScreen({Key key}) : super(key: key);

  final AddSightScreenBloc _bloc = AddSightScreenBloc();

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AddSightAppBar(bloc: _bloc),
          _AddSightBody(bloc: _bloc),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          16.0,
          8.0,
          16.0,
          MediaQuery.of(context).padding.bottom + 8.0,
        ),
        child: ActionButton(
          label: addSightActionButtonLabel,
          isDisabled: !_bloc.allDone,
          onPressed: () => _bloc.onActionButtonPressed(context),
        ),
      ),
    );
  }
}

class _AddSightAppBar extends StatelessWidget {
  const _AddSightAppBar({
    @required this.bloc,
    Key key,
  }) : super(key: key);

  final AddSightScreenBloc bloc;

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            cancelButtonLabel,
            softWrap: false,
            style: textMedium16.copyWith(
              color: secondaryColor2,
              height: lineHeight1_25,
            ),
          ),
        ),
      ),
      leadingWidth: 90.0,
      title: Text(
        addSightAppBarTitle,
        style: textMedium18.copyWith(
          color: Theme.of(context).primaryColor,
          height: lineHeight1_3,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(96.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: StreamBuilder<List<String>>(
            initialData: bloc.imgUrls,
            stream: bloc.outputImgStateStream,
            builder: (context, snapshot) {
              final imgUrls = snapshot.data;
              return _ImageCards(
                bloc: bloc,
                imgUrls: imgUrls,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ImageCards extends StatelessWidget {
  const _ImageCards({
    @required this.bloc,
    @required this.imgUrls,
    Key key,
  }) : super(key: key);

  final AddSightScreenBloc bloc;
  final List<String> imgUrls;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.only(
          top: 24.0,
          left: 16.0,
          right: 8.0,
        ),
        children: [
          _AddImageCard(
            // TODO: В дальнейшем, после прохождения 16.1 сделать реализацию
            onAddImageCard: () => bloc.onAddImageCardDummy(context),
          ),
          for (final imgUrl in imgUrls)
            _ImageCard(
              imgUrl: imgUrl,
              bloc: bloc,
            ),
        ],
      ),
    );
  }
}

class _AddImageCard extends StatelessWidget {
  const _AddImageCard({
    @required this.onAddImageCard,
    Key key,
  }) : super(key: key);

  static const _cardSize = 72.0;
  final void Function() onAddImageCard;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: allBorderRadius12,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onAddImageCard,
        child: Container(
          width: _cardSize,
          height: _cardSize,
          decoration: BoxDecoration(
            // color: Theme.of(context).canvasColor,
            borderRadius: allBorderRadius12,
            border: Border.fromBorderSide(
              Theme.of(context).inputDecorationTheme.focusedBorder.borderSide,
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              AppIcons.plus,
              width: 48.0,
              height: 48.0,
              color: Theme.of(context).buttonColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({
    @required this.imgUrl,
    @required this.bloc,
    Key key,
  }) : super(key: key);

  static const _cardSize = 72.0;
  final String imgUrl;
  final AddSightScreenBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(imgUrl),
      direction: DismissDirection.up,
      onDismissed: (_) => bloc.onDeleteImageCard(imgUrl),
      child: Listener(
        onPointerDown: (_) => bloc.onPointerDownOnImageCard(imgUrl),
        onPointerMove: (_) => bloc.onPointerMoveOnImageCard(imgUrl),
        onPointerUp: (_) => bloc.onPointerUpOnImageCard(imgUrl),
        child: StreamBuilder<bool>(
          // TODO: kind of a hack... needs to rethink about it later!
          stream: bloc.outputImgShadowStateStream,
          builder: (context, snapshot) {
            return Container(
              width: _cardSize,
              height: _cardSize,
              margin: const EdgeInsets.only(left: 16.0),
              decoration: BoxDecoration(
                color: placeholderColor,
                borderRadius: allBorderRadius12,
                boxShadow: bloc.getBoxShadow(imgUrl),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClearButton(
                    isDeletion: true,
                    onTap: () => bloc.onDeleteImageCard(imgUrl),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AddSightBody extends StatelessWidget {
  const _AddSightBody({
    @required this.bloc,
    Key key,
  }) : super(key: key);

  final AddSightScreenBloc bloc;

  bool hasClearButton(Field field) =>
      bloc.currentFocusNode == bloc.focusNodes[field] &&
      bloc.controllers[field].text.isNotEmpty;

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Subtitle(subtitle: addSightCategoryTitle),
                StreamBuilder<Category>(
                  initialData: bloc.selectedCategory,
                  stream: bloc.outputCategoryStateStream,
                  builder: (context, snapshot) {
                    final category = snapshot.data;
                    return SettingsItem(
                      title: category?.name ?? addSightNoCategoryTitle,
                      isGreyedOut: bloc.selectedCategory == null,
                      onTap: () => bloc.selectCategory(context),
                      trailing: SvgPicture.asset(
                        AppIcons.view,
                        width: 24.0,
                        height: 24.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  },
                ),
                _AddSightTextField(
                  title: addSightNameTitle,
                  hasClearButton: hasClearButton(Field.name),
                  controller: bloc.controllers[Field.name],
                  focusNode: bloc.focusNodes[Field.name],
                  moveFocus: () => bloc.moveFocus(context),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _AddSightTextField(
                        title: addSightLatitudeTitle,
                        hasClearButton: hasClearButton(Field.latitude),
                        controller: bloc.controllers[Field.latitude],
                        focusNode: bloc.focusNodes[Field.latitude],
                        moveFocus: () => bloc.moveFocus(context),
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        validator: (value) =>
                            AddSightScreenBloc.validateCoordinate(
                          value,
                          Coordinate.lat,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: _AddSightTextField(
                        title: addSightLongitudeTitle,
                        hasClearButton: hasClearButton(Field.longitude),
                        controller: bloc.controllers[Field.longitude],
                        focusNode: bloc.focusNodes[Field.longitude],
                        moveFocus: () => bloc.moveFocus(context),
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        validator: (value) =>
                            AddSightScreenBloc.validateCoordinate(
                          value,
                          Coordinate.lng,
                        ),
                      ),
                    ),
                  ],
                ),
                Link(
                  label: addSightSelectOnMapLabel,
                  onTap: () {
                    // ignore: avoid_print
                    print('Select on map tapped');
                  },
                ),
                _AddSightTextField(
                  title: addSightDescriptionTitle,
                  hintText: addSightDescriptionHintText,
                  maxLines: 4,
                  isLastField: true,
                  hasClearButton: hasClearButton(Field.description),
                  controller: bloc.controllers[Field.description],
                  focusNode: bloc.focusNodes[Field.description],
                  moveFocus: () => bloc.moveFocus(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddSightTextField extends StatelessWidget {
  const _AddSightTextField({
    @required this.title,
    @required this.controller,
    @required this.focusNode,
    @required this.moveFocus,
    this.maxLines,
    this.hintText,
    this.isLastField = false,
    this.hasClearButton = false,
    this.keyboardType,
    this.validator,
    Key key,
  }) : super(key: key);

  final int maxLines;
  final String title;
  final String hintText;
  final bool isLastField;
  final bool hasClearButton;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function() moveFocus;
  final String Function(String) validator;

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Subtitle(subtitle: title),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: TextFormField(
            autovalidateMode: validator != null
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: validator,
            scrollPadding: const EdgeInsets.all(100.0),
            maxLines: maxLines ?? 1,
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            textCapitalization: TextCapitalization.sentences,
            textInputAction:
                isLastField ? TextInputAction.done : TextInputAction.next,
            onEditingComplete: moveFocus,
            cursorColor: Theme.of(context).primaryColor,
            cursorHeight: 24.0,
            cursorWidth: 1,
            style: textRegular16.copyWith(
              color: Theme.of(context).primaryColor,
              height: lineHeight1_25,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: controller.text.isEmpty
                  ? Theme.of(context).inputDecorationTheme.border
                  : Theme.of(context).inputDecorationTheme.enabledBorder,
              suffixIcon: !hasClearButton
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClearButton(
                        onTap: () {
                          controller.clear();
                        },
                      ),
                    ),
              suffixIconConstraints: const BoxConstraints(
                maxHeight: 40.0,
                maxWidth: 40.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
