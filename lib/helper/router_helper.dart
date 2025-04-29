import 'dart:convert';

import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/screens/login_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/screens/branch_list.screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/screens/category_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/dashboard/screens/dashboard_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/onboarding/screens/onboarding_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/page_not_found/screens/page_not_found_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/search/screens/search_result_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/search/screens/search_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/screens/splash_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/welcome/screens/welcome_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

enum RouteAction{push, pushReplacement, popAndPush, pushNameAndRemoveUntil}

class RouterHelper {
  static const String splashScreen = '/splash';
  static const String onBoardingScreen = '/on_boarding';
  static const String orderDetailScreen = '/order-details';
  static const String notificationScreen = '/notification';
  static const String welcomeScreen = '/welcome';
  static const String loginScreen = '/login';
  static const String dashboard = '/';
  static const String dashboardScreen = '/main';
  static const String homeScreen = '/home';
  static const String searchScreen = '/search';
  static const String searchResultScreen = '/search-result';
  static const String categoryScreen = '/category';
  static const String branchListScreen = '/branch-list';

  static HistoryUrlStrategy historyUrlStrategy = HistoryUrlStrategy();
  static String getSplashRoute({RouteAction? action}) => _navigateRoute(splashScreen, route: action);
  static String getOrderDetailsRoute(String? id, {String? phoneNumber}) => _navigateRoute('$orderDetailScreen?id=$id&phone=${Uri.encodeComponent('$phoneNumber')}');
  static String getNotificationRoute() => _navigateRoute(notificationScreen);
  static String getLoginRoute({RouteAction? action}) => _navigateRoute(loginScreen, route: action);
  static String getMainRoute({RouteAction? action}) => _navigateRoute(dashboard, route: action);
  static String getBranchListScreen({RouteAction action = RouteAction.push}) => _navigateRoute(branchListScreen, route: action);

  static String _navigateRoute(String path, {RouteAction? route = RouteAction.push}) {
    if(route == RouteAction.pushNameAndRemoveUntil) {
      Get.context?.go(path);
    } else if(route == RouteAction.pushReplacement) {
      Get.context?.pushReplacement(path);
    } else {
      Get.context?.push(path);
    }

    return path;
  }

  static Widget _routeHandler(BuildContext context, Widget route, {bool isBranchCheck = false, required String? path}) {
    return Provider.of<SplashProvider>(context, listen: false).configModel == null ?
        SplashScreen(routeTo: path) : (Provider.of<BranchProvider>(context, listen: false).getBranchId() != 1 || isBranchCheck) ?
        route : const BranchListScreen();
  }

  static String? _getPath(GoRouterState state) => '${state.fullPath}?${state.uri.query}';

  static final goRoutes = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: getSplashRoute(),
      errorBuilder: (ctx, _) => const PageNotFoundScreen(),
      routes: [
        GoRoute(path: splashScreen, builder: (context, state) => const SplashScreen()),
        GoRoute(path: onBoardingScreen, builder: (context, state) => const OnBoardingScreen()),
        GoRoute(path: welcomeScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const WelcomeScreen())),
        GoRoute(path: loginScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const LoginScreen())),

        GoRoute(path: dashboardScreen, builder: (context, state) {
          return _routeHandler(context, path: _getPath(state), DashboardScreen(
              pageIndex: state.uri.queryParameters['page'] == 'home'
                  ? 0 : state.uri.queryParameters['page'] == 'favourite'
                  ? 1 : state.uri.queryParameters['page'] == 'cart'
                  ? 2 : state.uri.queryParameters['page'] == 'order'
                  ? 3 : state.uri.queryParameters['page'] == 'menu'
                  ? 4 : 0
          ), isBranchCheck: true);
        }),

        GoRoute(path: homeScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const DashboardScreen(pageIndex: 0), isBranchCheck: true)),
        GoRoute(path: dashboard, builder: (context, state) => _routeHandler(context, path: _getPath(state), const DashboardScreen(pageIndex: 0), isBranchCheck: true)),
        GoRoute(path: searchScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const SearchScreen())),
        GoRoute(path: searchResultScreen, builder: (context, state) => _routeHandler(
            context, path: _getPath(state), SearchResultScreen(searchString: state.uri.queryParameters['text'] ?? ''), isBranchCheck: true)),
        GoRoute(path: categoryScreen, builder: (context, state) {
          String image = utf8.decode(base64Decode(state.uri.queryParameters['img'] ?? ''));

          return _routeHandler(context,  path: '${state.fullPath}?${state.uri.query}', CategoryScreen(
          categoryId: state.uri.queryParameters['id']!,
          categoryName: state.uri.queryParameters['name']!,
          categoryBannerImage: image
          ));
        }),
        GoRoute(path: branchListScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const BranchListScreen()))
      ]
  );
}

class HistoryUrlStrategy extends PathUrlStrategy {
  @override
  void pushState(Object? state, String title, String url) => replaceState(state, title, url);
}