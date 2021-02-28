// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;

import '../view/home/widgets/search_overlay.dart' as _i3;
import '../view/landing/landing.dart' as _i2;

class AppRouter extends _i1.RootStackRouter {
  AppRouter();

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    LandingScreenRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i2.LandingScreen(),
          transitionsBuilder: _i1.TransitionsBuilders.slideLeft,
          durationInMilliseconds: 350);
    },
    SearchOverlayScreenRoute.name: (entry) {
      return _i1.CustomPage(
          entry: entry,
          child: _i3.SearchOverlayScreen(),
          transitionsBuilder: _i1.TransitionsBuilders.fadeIn);
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig<LandingScreenRoute>(LandingScreenRoute.name,
            path: '/',
            routeBuilder: (match) => LandingScreenRoute.fromMatch(match)),
        _i1.RouteConfig<SearchOverlayScreenRoute>(SearchOverlayScreenRoute.name,
            path: '/search-overlay-screen',
            routeBuilder: (match) => SearchOverlayScreenRoute.fromMatch(match))
      ];
}

class LandingScreenRoute extends _i1.PageRouteInfo {
  const LandingScreenRoute() : super(name, path: '/');

  LandingScreenRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'LandingScreenRoute';
}

class SearchOverlayScreenRoute extends _i1.PageRouteInfo {
  const SearchOverlayScreenRoute()
      : super(name, path: '/search-overlay-screen');

  SearchOverlayScreenRoute.fromMatch(_i1.RouteMatch match)
      : super.fromMatch(match);

  static const String name = 'SearchOverlayScreenRoute';
}
