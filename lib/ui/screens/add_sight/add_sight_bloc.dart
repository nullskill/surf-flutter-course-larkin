import 'dart:async';

import 'package:flutter/material.dart';
import 'package:places/bloc/base.dart';
import 'package:places/domain/category.dart';
import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/utils/consts.dart';

/// Перечисление координат
enum Coordinate { lat, lng }

/// Перечисление полей
// ignore: prefer-trailing-comma
enum Field { name, latitude, longitude, description }

/// Перечисление ивентов блока
enum AddSightScreenEvent { eventPointerAction }

/// Хранит список URL картинок места
final _imgUrls = <String>[];

class ImageCardPointerEvent implements BlocEvent<AddSightScreenEvent, String> {
  ImageCardPointerEvent({this.event, this.data});

  @override
  String data;

  @override
  AddSightScreenEvent event;
}

/// Класс логики экрана добавления нового места
class AddSightScreenBloc implements Bloc {
  AddSightScreenBloc() {
    init();
    _inputEventController.stream.listen(_mapEventToState);
  }

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

  final _inputEventController = StreamController<ImageCardPointerEvent>();
  final _outputImgUrlsStateController = StreamController<List<String>>();
  final _outputBoxShadowStateController = StreamController<List<BoxShadow>>();

  StreamSink<ImageCardPointerEvent> get inputEventSink =>
      _inputEventController.sink;

  Stream<List<String>> get outputImgUrlsStateStream =>
      _outputImgUrlsStateController.stream;

  void _mapEventToState<T extends BlocEvent<AddSightScreenEvent, Object>>(
    T blocEvent,
  ) {
    if (blocEvent.event == AddSightScreenEvent.eventPointerAction) {
      // ignore: avoid_print
      print('${blocEvent.event}: ${blocEvent.data}');
    }
  }

  /// Инициализация Listener'ов
  void init() {
    for (final entry in focusNodes.entries) {
      entry.value.addListener(() => focusNodeListener(entry.key));
    }
    for (final entry in controllers.entries) {
      entry.value.addListener(controllerListener);
    }
  }

  /// Освобождение памяти
  @override
  void dispose() {
    for (final focusNode in focusNodes.values) {
      focusNode.dispose();
    }
    for (final controller in controllers.values) {
      controller.dispose();
    }

    _inputEventController.close();
    _outputImgUrlsStateController.close();
    _outputBoxShadowStateController.close();
  }

  /// Listener для FocusNode
  void focusNodeListener(Field field) {
    currentFocusNode = focusNodes[field];
  }

  /// Listener для TextEditingController
  void controllerListener() {
    bool _allDone = true;

    for (final controller in controllers.values) {
      if (controller.text.isEmpty) {
        _allDone = false;
        break;
      }
    }

    allDone = _allDone && selectedCategory != null;
  }

  /// Перемещает фокус на следующий TextFormField
  void moveFocus(BuildContext context) {
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
  void setSelectedCategory(Category selectedCategory) {
    this.selectedCategory = selectedCategory;
    if (selectedCategory != null) focusNodes[Field.name].requestFocus();
  }

  /// При тапе на карточке картинки
  void onPointerDownOnImageCard(String imgKey) {
    this.imgKey = imgKey;
    isPointerDownOnImageCard = true;
    isPointerMoveOnImageCard = false;
    isPointerUpOnImageCard = false;
  }

  /// При свайпе карточки картинки
  void onPointerMoveOnImageCard(String imgKey) {
    this.imgKey = imgKey;
    isPointerDownOnImageCard = false;
    isPointerMoveOnImageCard = true;
    isPointerUpOnImageCard = false;
  }

  /// При окончании свайпа карточки картинки
  void onPointerUpOnImageCard(String imgKey) {
    this.imgKey = imgKey;
    isPointerDownOnImageCard = false;
    isPointerMoveOnImageCard = false;
    isPointerUpOnImageCard = true;
  }

  /// Возвращает тень для карточки картинки,
  /// в зависимости от состояния свайпа
  List<BoxShadow> getBoxShadow(String imgKey) {
    if (this.imgKey != imgKey) return [];

    if (isPointerMoveOnImageCard) {
      return const [
        BoxShadow(
          // ignore: prefer-trailing-comma
          color: Color.fromRGBO(26, 26, 32, 0.16),
          blurRadius: 16,
          offset: Offset(0, 4), // changes position of shadow
        ),
      ];
    }

    if (isPointerDownOnImageCard) {
      return const [
        BoxShadow(
          // ignore: prefer-trailing-comma
          color: Color.fromRGBO(26, 26, 32, 0.16),
          blurRadius: 8,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ];
    }

    return [];
  }

  /// При добавлении карточки картинки
  void onAddImageCard() {
    _imgUrls.add((_imgUrls.length + 2).toString());
    inputEventSink.add(
      ImageCardPointerEvent(
        event: AddSightScreenEvent.eventPointerAction,
        data: '12',
      ),
    );
  }

  /// При удалении карточки картинки
  void onDeleteImageCard(String imgUrl) {
    _imgUrls.removeAt(_imgUrls.indexOf(imgUrl));
  }

  /// При нажатии на ActionButton
  void onActionButtonPressed(BuildContext context) {
    mocks.add(
      Sight(
        name: controllers[Field.name].text,
        lat: double.tryParse(controllers[Field.latitude].text),
        lng: double.tryParse(controllers[Field.longitude].text),
        url: tempImgUrl,
        details: controllers[Field.description].text,
        type: selectedCategory.type,
      ),
    );
    Navigator.pop(context);
  }

  /// Валидация введенной координаты
  static String validateCoordinate(String value, Coordinate coordinate) {
    final lat = RegExp(r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)$');
    final lng = RegExp(r'^[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$');

    if (value.isEmpty) return null;
    if (double.tryParse(value) == null) return addSightWrongEntry;
    if (coordinate == Coordinate.lat && !lat.hasMatch(value)) {
      return addSightWrongEntry;
    }
    if (coordinate == Coordinate.lng && !lng.hasMatch(value)) {
      return addSightWrongEntry;
    }

    return null;
  }
}
