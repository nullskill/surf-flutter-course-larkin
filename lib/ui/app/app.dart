import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:places/common/error/error_handler.dart';
import 'package:places/data/interactor/filters_interactor.dart';
import 'package:places/data/interactor/location_interactor.dart';
import 'package:places/data/interactor/onboarding_interactor.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/interactor/search_interactor.dart';
import 'package:places/data/interactor/settings_interactor.dart';
import 'package:places/data/repository/database/app_database.dart';
import 'package:places/data/repository/favorites_repository.dart';
import 'package:places/data/repository/location_repository.dart';
import 'package:places/data/repository/place_repository.dart';
import 'package:places/data/repository/search_repository.dart';
import 'package:places/data/repository/search_requests_repository.dart';
import 'package:places/data/repository/visited_repository.dart';
import 'package:places/ui/res/app_routes.dart';
import 'package:places/ui/res/assets.dart';
import 'package:places/ui/res/strings/strings.dart';
import 'package:places/ui/res/themes.dart';
import 'package:places/ui/screens/error_screen.dart';
import 'package:places/ui/screens/map/map_route.dart';
import 'package:places/ui/screens/onboarding_screen.dart';
import 'package:places/ui/screens/settings_screen.dart';
import 'package:places/ui/screens/sight_list/sight_list_route.dart';
import 'package:places/ui/screens/splash_screen.dart';
import 'package:places/ui/screens/visiting/visiting_route.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  AppDatabase initAppDatabase(BuildContext context) => AppDatabase();

  OnboardingInteractor initOnboardingInteractor(BuildContext context) =>
      OnboardingInteractor();

  FiltersInteractor initFiltersInteractor(BuildContext context) =>
      FiltersInteractor();

  LocationRepository initLocationRepository(BuildContext context) =>
      LocationRepository();
  LocationInteractor initLocationInteractor(BuildContext context) =>
      LocationInteractor(context.read<LocationRepository>());

  SearchRepository initSearchRepository(BuildContext context) =>
      SearchRepository();
  SearchRequestsRepository initSearchRequestsRepository(
    BuildContext context,
  ) =>
      SearchRequestsRepository(context.read<AppDatabase>());
  SearchInteractor initSearchInteractor(BuildContext context) =>
      SearchInteractor(
        context.read<SearchRepository>(),
        context.read<SearchRequestsRepository>(),
        context.read<FiltersInteractor>(),
        context.read<LocationInteractor>(),
      );

  PlaceRepository initPlaceRepository(BuildContext context) =>
      PlaceRepository();
  FavoritesRepository initFavoritesRepository(BuildContext context) =>
      FavoritesRepository(context.read<AppDatabase>());
  VisitedRepository initVisitedRepository(BuildContext context) =>
      VisitedRepository(context.read<AppDatabase>());
  PlaceInteractor initPlaceInteractor(BuildContext context) => PlaceInteractor(
        context.read<PlaceRepository>(),
        context.read<FavoritesRepository>(),
        context.read<VisitedRepository>(),
        context.read<SearchInteractor>(),
      );

  WidgetModelDependencies initWmDependencies(BuildContext context) =>
      WidgetModelDependencies(errorHandler: DefaultErrorHandler());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(create: initAppDatabase),
        Provider<OnboardingInteractor>(create: initOnboardingInteractor),
        Provider<LocationRepository>(create: initLocationRepository),
        Provider<LocationInteractor>(create: initLocationInteractor),
        Provider<FiltersInteractor>(create: initFiltersInteractor),
        Provider<SearchRepository>(create: initSearchRepository),
        Provider<SearchRequestsRepository>(
          create: initSearchRequestsRepository,
        ),
        Provider<SearchInteractor>(create: initSearchInteractor),
        Provider<PlaceRepository>(create: initPlaceRepository),
        Provider<FavoritesRepository>(create: initFavoritesRepository),
        Provider<VisitedRepository>(create: initVisitedRepository),
        Provider<PlaceInteractor>(create: initPlaceInteractor),
        Provider<WidgetModelDependencies>(create: initWmDependencies),
        ChangeNotifierProvider<SettingsInteractor>(
          create: (_) => SettingsInteractor(),
        ),
      ],
      child: Consumer<SettingsInteractor>(
        builder: (context, notifier, child) {
          return MaterialApp(
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: AppScrollBehavior(),
                child: child,
              );
            },
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: notifier.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            title: appTitle,
            routes: _routesMap,
            onGenerateRoute: onGenerateRoute,
          );
        },
      ),
    );
  }
}

/// Remove splash afterglow on the lists, 'cause looks weird
class AppScrollBehavior extends ScrollBehavior {
  // ignore: avoid-returning-widgets
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}

final _routesMap = <String, Widget Function(BuildContext)>{
  AppRoutes.home: (_) => const SplashScreen(),
  AppRoutes.settings: (_) => const SettingsScreen(),
  AppRoutes.onboarding: (_) => const OnboardingScreen(),
  AppRoutes.error: (_) => const ErrorScreen(),
};

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  final link = <String, void Function()>{};
  link[settingsAppBarTitle] = AppSettings.openLocationSettings;

  switch (routeSettings.name) {
    case AppRoutes.start:
      return SightListScreenRoute();
    case AppRoutes.map:
      return MapScreenRoute();
    case AppRoutes.visiting:
      return VisitingScreenRoute();
    case AppRoutes.locationError:
      return MaterialPageRoute<ErrorScreen>(
        builder: (context) {
          return ErrorScreen(
            iconName: AppIcons.emptyMap,
            message: locationErrorMessage,
            link: link,
          );
        },
      );
    default:
      throw Exception('Unknown route name: ${routeSettings.name}');
  }
}
