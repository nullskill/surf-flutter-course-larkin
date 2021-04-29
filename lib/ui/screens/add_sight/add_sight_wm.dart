import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/domain/category.dart';
import 'package:places/domain/sight.dart';
import 'package:places/domain/sight_form.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/screens/select_category_screen.dart';
import 'package:places/ui/widgets/select_picture_dialog.dart';
import 'package:places/util/consts.dart';
import 'package:provider/provider.dart';
import 'package:relation/relation.dart';

/// Перечисление координат
enum Coordinate { lat, lng }

/// WM для AddSightScreen
class AddSightWidgetModel extends WidgetModel {
  AddSightWidgetModel(WidgetModelDependencies baseDependencies)
      : super(baseDependencies);

  // ignore: prefer_constructors_over_static_methods
  static AddSightWidgetModel builder(BuildContext context) {
    return AddSightWidgetModel(context.read<WidgetModelDependencies>());
  }

  GlobalKey<FormState> _formKey;

  /// При добавлении картинки
  final Action<BuildContext> onAddImageTap = Action<BuildContext>();

  /// При выборе категории
  final Action onCategoryTap = Action<void>();

  /// Контроллеры текстовых полей
  final nameController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final descriptionController = TextEditingController();
  List<TextEditingController> controllers;

  /// Фокус-ноды
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode latitudeFocusNode = FocusNode();
  final FocusNode longitudeFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  List<FocusNode> focusNodes;
  FocusNode currentFocusNode;

  /// Выбранная категория
  final selectedCategory = StreamedState<Category>();

  /// Список URL картинок места
  final imgUrls = StreamedState<List<String>>();

  /// Ключ "активной" карточки картинки
  final imgKey = StreamedState<String>();

  /// Флаг заполнения всех полей
  final allDone = StreamedState<bool>();

  /// Флаги действий указателя над карточкой картинки
  bool isPointerDownOnImg = false;
  bool isPointerMoveOnImg = false;

  /// Экземпляр формы
  SightForm sightForm = SightForm();

  /// Глобальный ключ для формы
  GlobalKey<FormState> get formKey => _formKey;

  @override
  void onLoad() {
    super.onLoad();

    _formKey = GlobalKey<FormState>();

    focusNodes = <FocusNode>[
      nameFocusNode,
      latitudeFocusNode,
      longitudeFocusNode,
      descriptionFocusNode,
    ];

    controllers = <TextEditingController>[
      nameController,
      latitudeController,
      longitudeController,
      descriptionController,
    ];
  }

  @override
  void onBind() {
    super.onBind();

    for (final focusNode in focusNodes) {
      focusNode.addListener(() => focusNodeListener(focusNode));
    }

    for (final controller in controllers) {
      controller.addListener(controllerListener);
    }

    imgUrls.accept([]);
    allDone.accept(false);

    subscribeHandleError<BuildContext>(onAddImageTap.stream, selectImage);
    subscribe<void>(onCategoryTap.stream, (_) => selectCategory);
  }

  @override
  void dispose() {
    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }
    for (final controller in controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  /// Listener для FocusNode
  void focusNodeListener(FocusNode focusNode) {
    if (focusNode.hasFocus) {
      currentFocusNode = focusNode;
    }
  }

  /// Listener для TextEditingController
  void controllerListener() {
    final bool hasSelectedCategory = selectedCategory.value != null;
    bool _allDone = false;

    if (hasSelectedCategory) {
      _allDone = true;
      for (final controller in controllers) {
        if (controller.text.isEmpty) {
          _allDone = false;
          break;
        }
      }
    }

    if (allDone.value != _allDone) {
      allDone.accept(_allDone);
    }
  }

  /// Возвращает флаг необходимости кнопки очистки поля
  bool hasClearButton(FocusNode focusNode, TextEditingController controller) =>
      currentFocusNode == focusNode && controller.text.isNotEmpty;

  /// Валидация введенной координаты
  String validateCoordinate(String value, Coordinate coordinate) {
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

  /// Перемещает фокус на следующий TextFormField
  void moveFocus(BuildContext context) {
    if (nameFocusNode.hasFocus) {
      latitudeFocusNode.requestFocus();
    } else if (latitudeFocusNode.hasFocus) {
      longitudeFocusNode.requestFocus();
    } else if (longitudeFocusNode.hasFocus) {
      descriptionFocusNode.requestFocus();
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
          selectedCategory: selectedCategory.value,
        ),
      ),
    );
    if (result != null) setSelectedCategory(result);
  }

  /// Устанавливает выбранную категорию в качестве текущей
  void setSelectedCategory(Category selectedCategory) {
    this.selectedCategory.accept(selectedCategory);
    if (selectedCategory != null) nameFocusNode.requestFocus();
  }

  /// При тапе на карточке картинки
  void onPointerDownOnImageCard(String imgKey) {
    this.imgKey.accept(imgKey);
    isPointerDownOnImg = true;
    isPointerMoveOnImg = false;
  }

  /// При свайпе карточки картинки
  void onPointerMoveOnImageCard(String imgKey) {
    this.imgKey.accept(imgKey);
    isPointerDownOnImg = false;
    isPointerMoveOnImg = true;
  }

  /// При окончании свайпа карточки картинки
  void onPointerUpOnImageCard(String imgKey) {
    this.imgKey.accept(imgKey);
    isPointerDownOnImg = false;
    isPointerMoveOnImg = false;
  }

  /// Возвращает тень для карточки картинки,
  /// в зависимости от состояния свайпа
  List<BoxShadow> getBoxShadow(String imgKey) {
    if (this.imgKey.value != imgKey) return [];

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

  /// При добавлении картинки (было)
  Future<void> onAddImageCard() async {
    await imgUrls
        .accept([...imgUrls.value, (imgUrls.value.length + 2).toString()]);
  }

  /// При добавлении картинки (временная заглушка)
  Future<void> selectImage(BuildContext context) async {
    // TODO: В дальнейшем, после прохождения 16.1 сделать реализацию
    const barrierLabel = 'barrierLabel';
    await showGeneralDialog(
      barrierLabel: barrierLabel,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 250),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return const SelectPictureDialog();
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
  Future<void> onDeleteImageCard(String imgUrl) async {
    await imgUrls.accept([...imgUrls.value.where((e) => e != imgUrl)]);
  }

  /// При нажатии на ActionButton
  void onActionButtonPressed(BuildContext context) {
    final FormState formState = _formKey.currentState;

    if (formState.validate()) {
      formState.save();
      sightForm
        ..urls = [tempImgUrl]
        ..type = selectedCategory.value.type;
      context.read<PlaceInteractor>().addNewSight(Sight.fromForm(sightForm));
      debugPrint('sightForm: $sightForm');

      Navigator.pop(context);
    }
  }
}
