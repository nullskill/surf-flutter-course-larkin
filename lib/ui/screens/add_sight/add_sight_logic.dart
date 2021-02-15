import 'package:flutter/material.dart';
import 'package:places/domain/category.dart';
import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/res/strings/strings.dart';

/// Перечисление координат
enum Coordinate { lat, lng }

/// Перечисление полей
// ignore: prefer-trailing-comma
enum Field { name, latitude, longitude, description }

/// Хранит список URL картинок места
final _imgUrls = <String>[];

/// Миксин для логики экрана добавления нового места
mixin AddSightScreenLogic<AddSightScreen extends StatefulWidget>
    on State<AddSightScreen> {
  final controllers = <Field, TextEditingController>{
    Field.name: TextEditingController(),
    Field.latitude: TextEditingController(),
    Field.longitude: TextEditingController(),
    Field.description: TextEditingController(),
  };

  final focusNodes = <Field, FocusNode>{
    Field.name: FocusNode(),
    Field.latitude: FocusNode(),
    Field.longitude: FocusNode(),
    Field.description: FocusNode(),
  };

  FocusNode currentFocusNode;
  Category selectedCategory;
  bool allDone = false;

  List<String> get imgUrls => _imgUrls;

  String imgKey;
  bool isPointerDownOnImageCard = false;
  bool isPointerMoveOnImageCard = false;
  bool isPointerUpOnImageCard = false;

  /// При тапе на карточке картинки
  void onPointerDownOnImageCard(imgKey) {
    setState(() {
      this.imgKey = imgKey;
      isPointerDownOnImageCard = true;
      isPointerMoveOnImageCard = false;
      isPointerUpOnImageCard = false;
    });
  }

  /// При свайпе карточки картинки
  void onPointerMoveOnImageCard(imgKey) {
    setState(() {
      this.imgKey = imgKey;
      isPointerDownOnImageCard = false;
      isPointerMoveOnImageCard = true;
      isPointerUpOnImageCard = false;
    });
  }

  /// При окончании свайпа карточки картинки
  void onPointerUpOnImageCard(imgKey) {
    setState(() {
      this.imgKey = imgKey;
      isPointerDownOnImageCard = false;
      isPointerMoveOnImageCard = false;
      isPointerUpOnImageCard = true;
    });
  }

  /// Возвращает тень для карточки картинки,
  /// в зависимости от состояния свайпа
  List<BoxShadow> getBoxShadow(imgKey) {
    if (this.imgKey != imgKey) return [];

    if (isPointerMoveOnImageCard)
      return [
        BoxShadow(
          // ignore: prefer-trailing-comma
          color: Color.fromRGBO(26, 26, 32, 0.16),
          spreadRadius: 0,
          blurRadius: 16,
          offset: Offset(0, 4), // changes position of shadow
        ),
      ];

    if (isPointerDownOnImageCard)
      return [
        BoxShadow(
          // ignore: prefer-trailing-comma
          color: Color.fromRGBO(26, 26, 32, 0.16),
          spreadRadius: 0,
          blurRadius: 8,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ];

    return [];
  }

  /// При добавлении карточки картинки
  void onAddImageCard() {
    setState(() {
      _imgUrls.add((_imgUrls.length + 2).toString());
    });
  }

  /// При удалении карточки картинки
  void onDeleteImageCard(imgUrl) {
    setState(() {
      _imgUrls.removeAt(_imgUrls.indexOf(imgUrl));
    });
  }

  /// Валидация введенной координаты
  static String validateCoordinate(String value, Coordinate coordinate) {
    final lat = RegExp(r"^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)$");
    final lng = RegExp(r"^[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$");

    if (value.isEmpty) return null;
    if (double.tryParse(value) == null) return addSightWrongEntry;
    if (coordinate == Coordinate.lat && !lat.hasMatch(value))
      return addSightWrongEntry;
    if (coordinate == Coordinate.lng && !lng.hasMatch(value))
      return addSightWrongEntry;

    return null;
  }

  @override
  void initState() {
    super.initState();

    for (var entry in focusNodes.entries)
      entry.value.addListener(() => focusNodeListener(entry.key));
    for (var entry in controllers.entries)
      entry.value.addListener(() => controllerListener());
  }

  @override
  void dispose() {
    for (var focusNode in focusNodes.values) focusNode.dispose();
    for (var controller in controllers.values) controller.dispose();

    super.dispose();
  }

  /// Listener для FocusNode
  void focusNodeListener(Field field) {
    setState(() {
      currentFocusNode = focusNodes[field];
    });
  }

  /// Listener для TextEditingController
  void controllerListener() {
    bool _allDone = true;

    for (var controller in controllers.values)
      if (controller.text.isEmpty) {
        _allDone = false;
        break;
      }

    setState(() {
      allDone = _allDone && selectedCategory != null;
    });
  }

  /// Перемещает фокус на следующий TextFormField
  void moveFocus() {
    if (focusNodes[Field.name].hasFocus) {
      focusNodes[Field.latitude].requestFocus();
    } else if (focusNodes[Field.latitude].hasFocus) {
      focusNodes[Field.longitude].requestFocus();
    } else if (focusNodes[Field.longitude].hasFocus) {
      focusNodes[Field.description].requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  /// Устанавливает выбранную категорию в качестве текущей
  void setSelectedCategory(selectedCategory) {
    setState(() {
      this.selectedCategory = selectedCategory;
    });
    if (selectedCategory != null) focusNodes[Field.name].requestFocus();
  }

  /// При нажатии на ActionButton
  void onActionButtonPressed() {
    mocks.add(
      Sight(
        name: controllers[Field.name].text,
        lat: double.tryParse(controllers[Field.latitude].text),
        lng: double.tryParse(controllers[Field.longitude].text),
        url:
            "https://vogazeta.ru/uploads/full_size_1575545015-c59f0314cb936df655a6a19ca760f02c.jpg",
        details: controllers[Field.description].text,
        type: selectedCategory.type,
      ),
    );
    Navigator.pop(context);
  }
}
