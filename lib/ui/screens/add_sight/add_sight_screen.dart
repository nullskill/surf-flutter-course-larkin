import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/domain/category.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/border_radiuses.dart';
import 'package:places/ui/res/colors.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/text_styles.dart';
import 'package:places/ui/screens/add_sight/add_sight_wm.dart';
import 'package:places/ui/widgets/action_button.dart';
import 'package:places/ui/widgets/clear_button.dart';
import 'package:places/ui/widgets/link.dart';
import 'package:places/ui/widgets/settings_item.dart';
import 'package:places/ui/widgets/subtitle.dart';
import 'package:relation/relation.dart';

/// Экран добавления нового места.
class AddSightScreen extends CoreMwwmWidget {
  const AddSightScreen({
    WidgetModelBuilder wmBuilder,
    Key key,
  }) : super(
            widgetModelBuilder: wmBuilder ?? AddSightWidgetModel.builder,
            key: key);

  @override
  _AddSightScreenState createState() => _AddSightScreenState();
}

class _AddSightScreenState extends WidgetState<AddSightWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AddSightAppBar(wm: wm),
          _AddSightBody(
            wm: wm,
          ),
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
          isDisabled: !wm.allDone,
          onPressed: () => wm.onActionButtonPressed(context),
        ),
      ),
    );
  }
}

class _AddSightAppBar extends StatelessWidget {
  const _AddSightAppBar({
    @required this.wm,
    Key key,
  }) : super(key: key);

  final AddSightWidgetModel wm;

  @override
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
          child: _ImageCards(wm: wm),
        ),
      ),
    );
  }
}

class _ImageCards extends StatelessWidget {
  const _ImageCards({
    @required this.wm,
    Key key,
  }) : super(key: key);

  final AddSightWidgetModel wm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.0,
      child: StreamedStateBuilder<List<String>>(
          streamedState: wm.imgUrls,
          builder: (context, imgUrls) {
            return ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.only(
                top: 24.0,
                left: 16.0,
                right: 8.0,
              ),
              children: [
                _AddImageCard(
                  onAddImageCard: () => wm.selectImage(context),
                ),
                for (final imgUrl in imgUrls)
                  _ImageCard(imgUrl: imgUrl, wm: wm),
              ],
            );
          }),
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
    @required this.wm,
    Key key,
  }) : super(key: key);

  static const _cardSize = 72.0;
  final String imgUrl;
  final AddSightWidgetModel wm;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(imgUrl),
      direction: DismissDirection.up,
      onDismissed: (_) => wm.onDeleteImageCard(imgUrl),
      child: Listener(
        onPointerDown: (_) => wm.onPointerDownOnImageCard(imgUrl),
        onPointerMove: (_) => wm.onPointerMoveOnImageCard(imgUrl),
        onPointerUp: (_) => wm.onPointerUpOnImageCard(imgUrl),
        child: StreamedStateBuilder<String>(
            streamedState: wm.imgKey,
            builder: (context, snapshot) {
              return Container(
                width: _cardSize,
                height: _cardSize,
                margin: const EdgeInsets.only(left: 16.0),
                decoration: BoxDecoration(
                  color: placeholderColor,
                  borderRadius: allBorderRadius12,
                  boxShadow: wm.getBoxShadow(imgUrl),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClearButton(
                      isDeletion: true,
                      onTap: () => wm.onDeleteImageCard(imgUrl),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class _AddSightBody extends StatelessWidget {
  const _AddSightBody({
    @required this.wm,
    Key key,
  }) : super(key: key);

  final AddSightWidgetModel wm;

  @override
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
            child: Form(
              key: wm.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Subtitle(subtitle: addSightCategoryTitle),
                  StreamedStateBuilder<Category>(
                      streamedState: wm.selectedCategory,
                      builder: (context, category) {
                        return SettingsItem(
                          title: category?.name ?? addSightNoCategoryTitle,
                          isGreyedOut: wm.selectedCategory == null,
                          onTap: () => wm.selectCategory(context),
                          trailing: SvgPicture.asset(
                            AppIcons.view,
                            width: 24.0,
                            height: 24.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      }),
                  _AddSightTextField(
                    title: addSightNameTitle,
                    hasClearButton: wm.hasClearButton(
                      wm.nameFocusNode,
                      wm.nameController,
                    ),
                    controller: wm.nameController,
                    focusNode: wm.nameFocusNode,
                    moveFocus: () => wm.moveFocus(context),
                    validator: (value) =>
                        value.isEmpty ? addSightIsEmptyName : null,
                    onSaved: (value) => wm.sightForm.name = value,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _AddSightTextField(
                          title: addSightLatitudeTitle,
                          hasClearButton: wm.hasClearButton(
                            wm.latitudeFocusNode,
                            wm.latitudeController,
                          ),
                          controller: wm.latitudeController,
                          focusNode: wm.latitudeFocusNode,
                          moveFocus: () => wm.moveFocus(context),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                          validator: (value) => wm.validateCoordinate(
                            value,
                            Coordinate.lat,
                          ),
                          onSaved: (value) =>
                              wm.sightForm.lat = double.tryParse(value),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: _AddSightTextField(
                          title: addSightLongitudeTitle,
                          hasClearButton: wm.hasClearButton(
                            wm.longitudeFocusNode,
                            wm.longitudeController,
                          ),
                          controller: wm.longitudeController,
                          focusNode: wm.longitudeFocusNode,
                          moveFocus: () => wm.moveFocus(context),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                          validator: (value) => wm.validateCoordinate(
                            value,
                            Coordinate.lng,
                          ),
                          onSaved: (value) =>
                              wm.sightForm.lng = double.tryParse(value),
                        ),
                      ),
                    ],
                  ),
                  Link(
                    label: addSightSelectOnMapLabel,
                    onTap: () {
                      // TODO: Make selection on map
                    },
                  ),
                  _AddSightTextField(
                    title: addSightDescriptionTitle,
                    hintText: addSightDescriptionHintText,
                    maxLines: 4,
                    isLastField: true,
                    hasClearButton: wm.hasClearButton(
                      wm.descriptionFocusNode,
                      wm.descriptionController,
                    ),
                    controller: wm.descriptionController,
                    focusNode: wm.descriptionFocusNode,
                    moveFocus: () => wm.moveFocus(context),
                    validator: (value) =>
                        value.isEmpty ? addSightIsEmptyDescription : null,
                    onSaved: (value) => wm.sightForm.details = value,
                  ),
                ],
              ),
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
    @required this.onSaved,
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
  final void Function(String) onSaved;
  final String Function(String) validator;

  @override
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            scrollPadding: const EdgeInsets.all(100.0),
            maxLines: maxLines ?? 1,
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            textCapitalization: TextCapitalization.sentences,
            textInputAction:
                isLastField ? TextInputAction.done : TextInputAction.next,
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
            onEditingComplete: moveFocus,
            onSaved: onSaved,
          ),
        ),
      ],
    );
  }
}
