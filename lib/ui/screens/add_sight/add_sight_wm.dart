import 'package:flutter/material.dart' hide Action, TextEditingAction;
import 'package:image_picker/image_picker.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/domain/category.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/sight_form.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/screens/select_category_screen.dart';
import 'package:places/ui/widgets/select_picture_dialog.dart';
import 'package:relation/relation.dart';

/// WM для AddSightScreen
class AddSightWidgetModel extends WidgetModel {
  AddSightWidgetModel(
    WidgetModelDependencies baseDependencies, {
    @required this.placeInteractor,
    @required this.navigator,
  }) : super(baseDependencies);

  final PlaceInteractor placeInteractor;
  final NavigatorState navigator;

  /// Выбиратель картинок
  final imagePicker = ImagePicker();

  /// Список картинок места
  final images = <String>[];

  // Fields

  /// Данные полей формы
  List<FieldData> _fields;

  /// Фокус-ноды
  final nameFocusNode = FocusNode();
  final latitudeFocusNode = FocusNode();
  final longitudeFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();

  // Actions

  /// Экшены контроллеров текстовых полей
  final nameEditingAction = TextEditingAction();
  final latitudeEditingAction = TextEditingAction();
  final longitudeEditingAction = TextEditingAction();
  final descriptionEditingAction = TextEditingAction();

  /// При добавлении картинки
  final addImageAction = Action<BuildContext>();

  /// При удалении картинки
  final removeImageAction = Action<int>();

  /// При выборе категории
  final selectCategoryAction = Action<BuildContext>();

  /// При тапе на ActionButton
  final actionButtonAction = Action<void>();

  /// При тапе на кнопке Назад
  final backButtonAction = Action<void>();

  /// Перемещает фокус на следующий TextFormField
  final moveFocusAction = Action<BuildContext>();

  /// При тапе на пунтке в диалоге выбора фото
  final getImageAction = Action<ImageSource>();

  // StreamedStates

  /// Стейт поля Name
  final nameFieldState = StreamedState<FieldData>();

  /// Стейт поля Latitude
  final latitudeFieldState = StreamedState<FieldData>();

  /// Стейт поля Longitude
  final longitudeFieldState = StreamedState<FieldData>();

  /// Стейт поля Description
  final descriptionFieldState = StreamedState<FieldData>();

  /// Выбранная категория
  final selectedCategoryState = StreamedState<Category>();

  /// Список URL картинок места
  final imagesState = StreamedState<List<String>>(const []);

  /// Флаг заполнения всех полей
  final isAllDoneState = StreamedState<bool>(false);

  // FormState

  /// Экземпляр формы
  SightForm sightForm = SightForm();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Глобальный ключ для формы
  GlobalKey<FormState> get formKey => _formKey;

  @override
  void onLoad() {
    super.onLoad();

    _fields = <FieldData>[
      FieldData(
        field: Field.name,
        focusNode: nameFocusNode,
        action: nameEditingAction,
        state: nameFieldState,
        validator: (value) => value.isEmpty ? addSightIsEmptyName : null,
      ),
      FieldData(
        field: Field.latitude,
        focusNode: latitudeFocusNode,
        action: latitudeEditingAction,
        state: latitudeFieldState,
        validator: (value) => _validateCoordinate(value, _Coordinate.lat),
      ),
      FieldData(
        field: Field.longitude,
        focusNode: longitudeFocusNode,
        action: longitudeEditingAction,
        state: longitudeFieldState,
        validator: (value) => _validateCoordinate(value, _Coordinate.lng),
      ),
      FieldData(
        field: Field.description,
        focusNode: descriptionFocusNode,
        action: descriptionEditingAction,
        state: descriptionFieldState,
        validator: (value) => value.isEmpty ? addSightIsEmptyDescription : null,
      ),
    ];
  }

  @override
  void onBind() {
    super.onBind();

    for (final field in _fields) {
      field.focusNode.addListener(() => _focusNodeListener(field));
      field.state.accept(field);
      subscribe<String>(field.action.stream, (_) => _refreshFieldState(field));
    }

    subscribe<BuildContext>(addImageAction.stream, _addImage);
    subscribe<int>(removeImageAction.stream, _removeImage);
    subscribe<BuildContext>(selectCategoryAction.stream, _selectCategory);
    subscribe<BuildContext>(moveFocusAction.stream, _moveFocus);
    subscribe<void>(actionButtonAction.stream, (_) => _saveForm());
    subscribe<void>(backButtonAction.stream, (_) => navigator.pop());
    subscribe<ImageSource>(getImageAction.stream, _getImage);
  }

  @override
  void dispose() {
    for (final field in _fields) {
      field.focusNode.dispose();
    }

    super.dispose();
  }

  /// Listener для FocusNode
  void _focusNodeListener(FieldData field) {
    field.hasFocus = field.focusNode.hasFocus;
    _setFieldHasClearButton(field);
    field.state.accept(field);
  }

  /// Обновляет состояния поля
  void _refreshFieldState(FieldData field) {
    final bool textIsNotEmpty = field.action.value.isNotEmpty;
    if (field.hasText != textIsNotEmpty) {
      field.hasText = textIsNotEmpty;
      _setFieldHasClearButton(field);
      field.state.accept(field);
    }
    _checkFormIsCompleted();
  }

  /// Проверка необходимости флага для кнопки очистки
  void _setFieldHasClearButton(FieldData field) {
    field.hasClearButton = field.hasFocus && field.hasText;
  }

  /// Проверка заполненности формы
  void _checkFormIsCompleted() {
    bool _isAllDone = selectedCategoryState.value != null;

    if (_isAllDone) {
      for (final field in _fields) {
        if (!field.hasText) {
          _isAllDone = false;
        }
      }
    }

    if (isAllDoneState.value != _isAllDone) {
      isAllDoneState.accept(_isAllDone);
    }
  }

  /// Валидация введенной координаты
  String _validateCoordinate(String value, _Coordinate coordinate) {
    final lat = RegExp(r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)$');
    final lng = RegExp(r'^[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$');

    if (value.isEmpty && coordinate == _Coordinate.lat) {
      return addSightIsEmptyLatitude;
    }
    if (value.isEmpty && coordinate == _Coordinate.lng) {
      return addSightIsEmptyLongitude;
    }
    if (double.tryParse(value) == null) return addSightWrongEntry;
    if (coordinate == _Coordinate.lat && !lat.hasMatch(value)) {
      return addSightWrongEntry;
    }
    if (coordinate == _Coordinate.lng && !lng.hasMatch(value)) {
      return addSightWrongEntry;
    }

    return null;
  }

  /// Перемещает фокус на следующий TextFormField
  void _moveFocus(BuildContext context) {
    if (nameFocusNode.hasFocus) {
      FocusScope.of(context).requestFocus(latitudeFocusNode);
    } else if (latitudeFocusNode.hasFocus) {
      FocusScope.of(context).requestFocus(longitudeFocusNode);
    } else if (longitudeFocusNode.hasFocus) {
      FocusScope.of(context).requestFocus(descriptionFocusNode);
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  /// Добавляет новую картинку (временная реализация)
  void _addImage(BuildContext context) {
    const barrierLabel = 'barrierLabel';

    final Future<String> selectPictureDialog = showGeneralDialog(
      barrierLabel: barrierLabel,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 250),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return SelectPictureDialog(getImageAction: getImageAction);
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

    doFutureHandleError<String>(selectPictureDialog, (file) {
      if (file != null) {
        images.insert(0, file);
        imagesState.accept(images);
      }
    }, onError: (e) {
      debugPrint('Error while adding new picture: $e');
    });
  }

  /// Получает фото с камеры или картинку из галереи
  void _getImage(ImageSource imageSource) {
    doFutureHandleError<PickedFile>(imagePicker.getImage(source: imageSource),
        (image) => navigator.pop(image?.path));
  }

  /// Удаляет картинку
  void _removeImage(int index) {
    images.removeAt(index);
    imagesState.accept(images);
  }

  /// Открывает выбор категории
  Future<void> _selectCategory(BuildContext context) async {
    final result = await navigator.push(
      MaterialPageRoute<Category>(
        builder: (context) => SelectCategoryScreen(
          selectedCategory: selectedCategoryState.value,
        ),
      ),
    );
    if (result != null) _setSelectedCategory(result);
  }

  /// Устанавливает выбранную категорию в качестве текущей
  void _setSelectedCategory(Category selectedCategory) {
    selectedCategoryState.accept(selectedCategory);
    nameFocusNode.requestFocus();
  }

  /// Сохранение данных формы
  void _saveForm() {
    final FormState formState = _formKey.currentState;

    if (formState.validate()) {
      _saveFields();
      placeInteractor.addNewSight(Sight.fromForm(sightForm));
      debugPrint('Form successfully saved: $sightForm');

      navigator.pop();
    } else {
      debugPrint('Form is not validated!');
    }
  }

  /// Сохраняет значения полей в [sightForm]
  void _saveFields() {
    sightForm
      ..name = nameEditingAction.value
      ..lat = double.tryParse(latitudeEditingAction.value)
      ..lng = double.tryParse(longitudeEditingAction.value)
      ..details = descriptionEditingAction.value
      ..urls = images
      ..type = selectedCategoryState.value.type;
  }
}

/// Перечисление координат
enum _Coordinate { lat, lng }

/// Перечисление полей формы
enum Field { name, latitude, longitude, description }

/// Данные поля формы
class FieldData {
  FieldData({
    @required this.field,
    @required this.focusNode,
    @required this.action,
    @required this.state,
    this.validator,
    this.hasFocus = false,
    this.hasText = false,
    this.hasClearButton = false,
  });

  final Field field;
  final FocusNode focusNode;
  final TextEditingAction action;
  final StreamedState<FieldData> state;
  // Don't know how to change validator to Action -> StreamedState
  final String Function(String) validator;
  bool hasFocus;
  bool hasText;
  bool hasClearButton;
}
