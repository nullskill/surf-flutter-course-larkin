import 'package:flutter/material.dart';

import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';

/// Перечисление типов координат
enum Coordinates { lat, lng }

/// Хранит список URL картинок места
final _imgUrls = <String>[
  "1",
  "2",
  "3",
];

/// Вспомогательный миксин для экрана добавления нового места
mixin AddSightScreenHelper<AddSightScreen extends StatefulWidget>
    on State<AddSightScreen> {
  final controllers = <String, TextEditingController>{
    "name": TextEditingController(),
    "latitude": TextEditingController(),
    "longitude": TextEditingController(),
    "description": TextEditingController(),
  };

  final focusNodes = <String, FocusNode>{
    "name": FocusNode(),
    "latitude": FocusNode(),
    "longitude": FocusNode(),
    "description": FocusNode(),
  };

  FocusNode currentFocusNode;
  Category selectedCategory;
  bool allDone = false;

  List<String> get imgUrls => _imgUrls;

  /// Валидация введенной координаты
  static String validateCoordinate(String value, Coordinates coordinate) {
    const wrong = "Неправильный ввод";
    final lat = RegExp(r"^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)$");
    final lng = RegExp(r"^[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$");

    if (value.isEmpty) return null;
    if (double.tryParse(value) == null) return wrong;
    if (coordinate == Coordinates.lat && !lat.hasMatch(value)) return wrong;
    if (coordinate == Coordinates.lng && !lng.hasMatch(value)) return wrong;

    return null;
  }

  @override
  void initState() {
    super.initState();

    for (var entry in focusNodes.entries)
      entry.value.addListener(() => focusNodeListener(entry.key));
    for (var entry in controllers.entries)
      entry.value.addListener(() => controllerListener(entry.key));
  }

  @override
  void dispose() {
    for (var focusNode in focusNodes.values) focusNode.dispose();
    for (var controller in controllers.values) controller.dispose();

    super.dispose();
  }

  /// Listener для FocusNode
  void focusNodeListener(String focusNodeName) {
    setState(() {
      currentFocusNode = focusNodes[focusNodeName];
    });
  }

  /// Listener для TextEditingController
  void controllerListener(String controllerName) {
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
    if (focusNodes["name"].hasFocus) {
      focusNodes["latitude"].requestFocus();
    } else if (focusNodes["latitude"].hasFocus) {
      focusNodes["longitude"].requestFocus();
    } else if (focusNodes["longitude"].hasFocus) {
      focusNodes["description"].requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  /// Устанавливает выбранную категорию в качестве текущей
  void setSelectedCategory(selectedCategory) {
    setState(() {
      this.selectedCategory = selectedCategory;
    });
    if (selectedCategory != null) focusNodes["name"].requestFocus();
  }

  void onDeleteImageCard(imgUrl) {
    setState(() {
      _imgUrls.removeAt(_imgUrls.indexOf(imgUrl));
    });
  }

  /// При нажатии на ActionButton
  void onActionButtonPressed() {
    mocks.add(
      Sight(
        name: controllers["name"].text,
        lat: double.tryParse(controllers["latitude"].text),
        lng: double.tryParse(controllers["longitude"].text),
        url:
            "https://vogazeta.ru/uploads/full_size_1575545015-c59f0314cb936df655a6a19ca760f02c.jpg",
        details: controllers["description"].text,
        type: selectedCategory.type,
      ),
    );
    Navigator.pop(context);
  }
}
