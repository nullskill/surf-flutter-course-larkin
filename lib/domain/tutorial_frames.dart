import 'package:places/domain/tutorial_frame.dart';
import 'package:places/ui/res/assets.dart';

/// Список экземпляров фреймов для онбординга
final tutorialFrames = <TutorialFrame>[
  TutorialFrame(
    iconName: AppIcons.frame1,
    title: 'Добро пожаловать\nв Путеводитель',
    message: 'Ищи новые локации и сохраняй\nсамые любимые.',
  ),
  TutorialFrame(
    iconName: AppIcons.frame2,
    title: 'Построй маршрут\nи отправляйся в путь',
    message: 'Достигай цели максимально\nбыстро и комфортно.',
  ),
  TutorialFrame(
    iconName: AppIcons.frame3,
    title: 'Добавляй места,\nкоторые нашёл сам',
    message: 'Делись самыми интересными\nи помоги нам стать лучше!',
  ),
];
