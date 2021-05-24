import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/common/error/error_handler.dart';
import 'package:places/data/interactor/filters_interactor.dart';
import 'package:places/data/interactor/onboarding_interactor.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/data/repository/database/app_database.dart';
import 'package:places/data/repository/favorites_repository.dart';
import 'package:places/data/repository/place_repository.dart';
import 'package:places/data/repository/search_repository.dart';
import 'package:places/data/repository/search_requests_repository.dart';
import 'package:places/data/repository/visited_repository.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screens/error_screen.dart';
import 'package:places/ui/screens/onboarding_screen.dart';
import 'package:places/ui/screens/settings_screen.dart';
import 'package:places/ui/screens/sight_list/sight_list_route.dart';
import 'package:places/ui/screens/splash_screen.dart';
import 'package:places/ui/screens/visiting/visiting_route.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppDatabase initAppDatabase(BuildContext context) => AppDatabase();

    OnboardingInteractor initOnboardingInteractor(BuildContext context) =>
        OnboardingInteractor();

    FiltersInteractor initFiltersInteractor(BuildContext context) =>
        FiltersInteractor();

    SearchRepository initSearchRepository(BuildContext context) =>
        SearchRepository();
    SearchRequestsRepository initSearchRequestsRepository(
            BuildContext context) =>
        SearchRequestsRepository(context.read<AppDatabase>());
    SearchInteractor initSearchInteractor(BuildContext context) =>
        SearchInteractor(
          context.read<SearchRepository>(),
          context.read<SearchRequestsRepository>(),
          context.read<FiltersInteractor>(),
        );

    PlaceRepository initPlaceRepository(BuildContext context) =>
        PlaceRepository();
    FavoritesRepository initFavoritesRepository(BuildContext context) =>
        FavoritesRepository(context.read<AppDatabase>());
    VisitedRepository initVisitedRepository(BuildContext context) =>
        VisitedRepository(context.read<AppDatabase>());
    PlaceInteractor initPlaceInteractor(BuildContext context) =>
        PlaceInteractor(
          context.read<PlaceRepository>(),
          context.read<FavoritesRepository>(),
          context.read<VisitedRepository>(),
          context.read<SearchInteractor>(),
        );

    WidgetModelDependencies initWmDependencies(BuildContext context) =>
        WidgetModelDependencies(errorHandler: DefaultErrorHandler());

    return MultiProvider(
      providers: [
        Provider<AppDatabase>(create: initAppDatabase),
        Provider<OnboardingInteractor>(create: initOnboardingInteractor),
        Provider<FiltersInteractor>(create: initFiltersInteractor),
        Provider<SearchRepository>(create: initSearchRepository),
        Provider<SearchRequestsRepository>(
            create: initSearchRequestsRepository),
        Provider<SearchInteractor>(create: initSearchInteractor),
        Provider<PlaceRepository>(create: initPlaceRepository),
        Provider<FavoritesRepository>(create: initFavoritesRepository),
        Provider<VisitedRepository>(create: initVisitedRepository),
        Provider<PlaceInteractor>(create: initPlaceInteractor),
        Provider<WidgetModelDependencies>(create: initWmDependencies),
        ChangeNotifierProvider<SettingsInteractor>(
            create: (_) => SettingsInteractor()),
      ],
      child: Consumer<SettingsInteractor>(
        builder: (context, notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: notifier.darkTheme ? ThemeMode.dark : ThemeMode.light,
            title: appTitle,
            routes: _routesMap,
            onGenerateRoute: onGenerateRoute,
          );
        },
      ),
    );
  }
}

final _routesMap = <String, Widget Function(BuildContext)>{
  AppRoutes.home: (_) => const SplashScreen(),
  AppRoutes.map: (_) => const Scaffold(),
  AppRoutes.settings: (_) => const SettingsScreen(),
  AppRoutes.onboarding: (_) => const OnboardingScreen(),
  AppRoutes.error: (_) => ErrorScreen(),
};

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AppRoutes.start:
      return SightListScreenRoute();
    case AppRoutes.visiting:
      return VisitingScreenRoute();
    default:
      throw Exception('Unknown route name: ${routeSettings.name}');
  }
}
