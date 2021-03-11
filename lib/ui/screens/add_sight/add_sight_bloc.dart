import 'dart:async';

import 'package:flutter/material.dart';
import 'package:places/bloc/base.dart';
import 'package:places/domain/category.dart';
import 'package:places/domain/sight.dart';
import 'package:places/mocks.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/screens/select_category_screen.dart';
import 'package:places/ui/widgets/select_picture_dialog.dart';
import 'package:places/utils/consts.dart';

/// Перечисление координат
enum Coordinate { lat, lng }

/// Перечисление полей
enum Field {
  name,
  latitude,
  longitude,
  description,
}

/// Перечисление ивентов картинок места
enum AddSightScreenImgEvent {
  addImgEvent,
  deleteImgEvent,
  pointerDownOnImgEvent,
  pointerMoveOnImgEvent,
  pointerUpOnImgEvent,
}

/// Перечисление ивентов категории
enum AddSightScreenCategoryEvent { changeCategoryEvent }

/// Хранит список URL картинок места
final _imgUrls = <String>[];

class _ImageCardEvent implements BlocEvent<AddSightScreenImgEvent, String> {
  _ImageCardEvent({this.event, this.data});

  @override
  String data;

  @override
  AddSightScreenImgEvent event;
}

class _CategoryEvent
    implements BlocEvent<AddSightScreenCategoryEvent, Category> {
  _CategoryEvent({this.event, this.data});

  @override
  Category data;

  @override
  AddSightScreenCategoryEvent event;
}

/// Класс логики экрана добавления нового места
class AddSightScreenBloc implements Bloc {
  AddSightScreenBloc() {
    init();
    _inputImgEventController.stream.listen(_mapImgEventToState);
    _inputCategoryEventController.stream.listen(_mapCategoryEventToState);
  }

  final _inputImgEventController = StreamController<_ImageCardEvent>();
  final _inputCategoryEventController = StreamController<_CategoryEvent>();
  final _outputImgStateController = StreamController<List<String>>.broadcast();
  final _outputImgShadowStateController = StreamController<bool>.broadcast();
  final _outputCategoryStateController = StreamController<Category>.broadcast();

  StreamSink<_ImageCardEvent> get inputImgEventSink =>
      _inputImgEventController.sink;

  StreamSink<_CategoryEvent> get inputCategoryEventSink =>
      _inputCategoryEventController.sink;

  Stream<List<String>> get outputImgStateStream =>
      _outputImgStateController.stream;

  Stream<bool> get outputImgShadowStateStream =>
      _outputImgShadowStateController.stream;

  Stream<Category> get outputCategoryStateStream =>
      _outputCategoryStateController.stream;

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
  bool isPointerDownOnImg = false;
  bool isPointerMoveOnImg = false;
  bool isPointerUpOnImg = false;

  void _mapImgEventToState<T extends BlocEvent<AddSightScreenImgEvent, String>>(
    T blocEvent,
  ) {
    switch (blocEvent.event) {
      case AddSightScreenImgEvent.addImgEvent:
        _imgUrls.add(blocEvent.data);
        _outputImgStateController.sink.add(_imgUrls);
        break;
      case AddSightScreenImgEvent.deleteImgEvent:
        _imgUrls.removeAt(_imgUrls.indexOf(blocEvent.data));
        _outputImgStateController.sink.add(_imgUrls);
        break;
      case AddSightScreenImgEvent.pointerDownOnImgEvent:
        imgKey = blocEvent.data;
        isPointerDownOnImg = true;
        isPointerMoveOnImg = false;
        isPointerUpOnImg = false;
        _outputImgShadowStateController.sink.add(true);
        break;
      case AddSightScreenImgEvent.pointerMoveOnImgEvent:
        imgKey = blocEvent.data;
        isPointerDownOnImg = false;
        isPointerMoveOnImg = true;
        isPointerUpOnImg = false;
        _outputImgShadowStateController.sink.add(true);
        break;
      case AddSightScreenImgEvent.pointerUpOnImgEvent:
        imgKey = blocEvent.data;
        isPointerDownOnImg = false;
        isPointerMoveOnImg = false;
        isPointerUpOnImg = true;
        _outputImgShadowStateController.sink.add(true);
        break;
      default:
        throw Exception('Wrong event type');
        break;
    }
  }

  void _mapCategoryEventToState<
      T extends BlocEvent<AddSightScreenCategoryEvent, Category>>(
    T blocEvent,
  ) {
    switch (blocEvent.event) {
      case AddSightScreenCategoryEvent.changeCategoryEvent:
        setSelectedCategory(blocEvent.data);
        _outputCategoryStateController.sink.add(selectedCategory);
        break;
      default:
        throw Exception('Wrong event type');
        break;
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

    _inputImgEventController.close();
    _inputCategoryEventController.close();
    _outputImgStateController.close();
    _outputImgShadowStateController.close();
    _outputCategoryStateController.close();
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

  /// Открывает выбор категории
  Future<void> selectCategory(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<Category>(
        builder: (context) => SelectCategoryScreen(
          selectedCategory: selectedCategory,
        ),
      ),
    );
    if (result != null) setSelectedCategory(result);
    inputCategoryEventSink.add(
      _CategoryEvent(
          event: AddSightScreenCategoryEvent.changeCategoryEvent, data: result),
    );
  }

  /// Устанавливает выбранную категорию в качестве текущей
  void setSelectedCategory(Category selectedCategory) {
    this.selectedCategory = selectedCategory;
    if (selectedCategory != null) focusNodes[Field.name].requestFocus();
  }

  /// При тапе на карточке картинки
  void onPointerDownOnImageCard(String imgKey) {
    inputImgEventSink.add(
      _ImageCardEvent(
        event: AddSightScreenImgEvent.pointerDownOnImgEvent,
        data: imgKey,
      ),
    );
  }

  /// При свайпе карточки картинки
  void onPointerMoveOnImageCard(String imgKey) {
    inputImgEventSink.add(
      _ImageCardEvent(
        event: AddSightScreenImgEvent.pointerMoveOnImgEvent,
        data: imgKey,
      ),
    );
  }

  /// При окончании свайпа карточки картинки
  void onPointerUpOnImageCard(String imgKey) {
    inputImgEventSink.add(
      _ImageCardEvent(
        event: AddSightScreenImgEvent.pointerUpOnImgEvent,
        data: imgKey,
      ),
    );
  }

  /// Возвращает тень для карточки картинки,
  /// в зависимости от состояния свайпа
  List<BoxShadow> getBoxShadow(String imgKey) {
    if (this.imgKey != imgKey) return [];

    if (isPointerMoveOnImg) {
      return const [
        BoxShadow(
          // ignore: prefer-trailing-comma
          color: Color.fromRGBO(26, 26, 32, 0.16),
          blurRadius: 16,
          offset: Offset(0, 4), // changes position of shadow
        ),
      ];
    }

    if (isPointerDownOnImg) {
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
    final newImgUrl = (_imgUrls.length + 2).toString();

    inputImgEventSink.add(
      _ImageCardEvent(
        event: AddSightScreenImgEvent.addImgEvent,
        data: newImgUrl,
      ),
    );
  }

  /// При добавлении карточки картинки (временная заглушка)
  Future<void> onAddImageCardDummy(BuildContext context) async {
    // TODO: В дальнейшем, после прохождения 16.1 сделать реализацию
    const barrierLabel = 'barrierLabel';
    await showGeneralDialog(
      barrierLabel: barrierLabel,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 250),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return SelectPictureDialog();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(anim1),
          child: child,
        );
      },
    );
  }

  /// При удалении карточки картинки
  void onDeleteImageCard(String imgUrl) {
    inputImgEventSink.add(
      _ImageCardEvent(
        event: AddSightScreenImgEvent.deleteImgEvent,
        data: imgUrl,
      ),
    );
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
