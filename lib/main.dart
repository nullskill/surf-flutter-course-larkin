import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/common/error/error_handler.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/data/repository/place_repository.dart';
import 'package:places/data/repository/search_repository.dart';
import 'package:places/data/repository/visiting_repository.dart';
import 'package:places/redux/middleware/sight_search_middleware.dart';
import 'package:places/redux/reducer/reducer.dart';
import 'package:places/redux/state/app_state.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screens/error_screen.dart';
import 'package:places/ui/screens/onboarding_screen.dart';
import 'package:places/ui/screens/settings_screen.dart';
import 'package:places/ui/screens/sight_list/sight_list_screen.dart';
import 'package:places/ui/screens/splash_screen.dart';
import 'package:places/ui/screens/visiting/visiting_screen.dart';
import 'package:places/util/consts.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store<AppState>(reducer, initialState: AppState(), middleware: [
    SightSearchMiddleware(SearchInteractor(SearchRepository())),
  ]);

  if (isReleaseMode) {
    debugPrint = (message, {wrapWidth}) {};
  }
  runApp(
    DevicePreview(
      enabled: !isReleaseMode,
      builder: (_) => App(store: store),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key key, this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    SearchRepository initSearchRepository(BuildContext context) =>
        SearchRepository();
    SearchInteractor initSearchInteractor(BuildContext context) =>
        SearchInteractor(context.read<SearchRepository>());

    PlaceRepository initPlaceRepository(BuildContext context) =>
        PlaceRepository();
    PlaceInteractor initPlaceInteractor(BuildContext context) =>
        PlaceInteractor(
            context.read<PlaceRepository>(), context.read<SearchInteractor>());

    VisitingRepository initVisitingRepository(BuildContext context) =>
        VisitingRepository();

    WidgetModelDependencies initWmDependencies(BuildContext context) =>
        WidgetModelDependencies(errorHandler: DefaultErrorHandler());

    return MultiProvider(
      providers: [
        Provider<SearchRepository>(create: initSearchRepository),
        Provider<SearchInteractor>(create: initSearchInteractor),
        Provider<PlaceRepository>(create: initPlaceRepository),
        Provider<PlaceInteractor>(create: initPlaceInteractor),
        Provider<VisitingRepository>(create: initVisitingRepository),
        Provider(create: initWmDependencies),
        ChangeNotifierProvider<SettingsInteractor>(
            create: (_) => SettingsInteractor()),
      ],
      child: Consumer<SettingsInteractor>(
        builder: (context, notifier, child) {
          return StoreProvider(
            store: store,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: DevicePreview.locale(context),
              builder: DevicePreview.appBuilder,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: notifier.darkTheme ? ThemeMode.dark : ThemeMode.light,
              title: appTitle,
              routes: _routesMap,
            ),
          );
        },
      ),
    );
  }
}

final _routesMap = <String, Widget Function(BuildContext)>{
  AppRoutes.home: (_) => const SplashScreen(),
  AppRoutes.start: (_) => const SightListScreen(),
  AppRoutes.map: (_) => const Scaffold(),
  AppRoutes.visiting: (_) => const VisitingScreen(),
  AppRoutes.settings: (_) => const SettingsScreen(),
  AppRoutes.onboarding: (_) => const OnboardingScreen(),
  AppRoutes.error: (_) => ErrorScreen(), // analyzer breaks with const
};
