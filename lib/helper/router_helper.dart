import 'dart:convert';

import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/address_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/screens/add_new_address_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/screens/address_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/screens/create_account_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/screens/login_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/screens/branch_list.screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/domain/models/category_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/screens/category_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/screen/checkout_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/screen/order_successful_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/dashboard/screens/dashboard_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/product_type_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/screens/home_item_screen.dart';
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
import 'package:universal_html/js.dart';

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
  static const String searchScreen = '/search';
  static const String searchResultScreen = '/search-result';
  static const String categoryScreen = '/category';
  static const String branchListScreen = '/branch-list';
  static const String homeItem = '/home-item';
  static const String detailItem = '/detail-item';
  static const String createAccountScreen = '/create-account';
  static const String addressScreen = '/address';
  static const String addAddressScreen = '/add-address';
  static const String checkoutScreen = '/checkout';
  static const String orderSuccessScreen = '/order-completed';
  static const String paymentScreen = '/payment';

  static HistoryUrlStrategy historyUrlStrategy = HistoryUrlStrategy();
  static String getSplashRoute({RouteAction? action}) => _navigateRoute(splashScreen, route: action);
  static String getOrderDetailsRoute(String? id, {String? phoneNumber}) => _navigateRoute('$orderDetailScreen?id=$id&phone=${Uri.encodeComponent('$phoneNumber')}');
  static String getNotificationRoute() => _navigateRoute(notificationScreen);
  static String getLoginRoute({RouteAction? action}) => _navigateRoute(loginScreen, route: action);
  static String getMainRoute({RouteAction? action}) => _navigateRoute(dashboard, route: action);
  static String getBranchListScreen({RouteAction action = RouteAction.push}) => _navigateRoute(branchListScreen, route: action);
  static String getHomeItem({required ProductType productType}) => _navigateRoute('$homeItem?type=${productType.name}');
  static String getCategoryRoute(CategoryModel categoryModel, {RouteAction? action}) {
    String imageUrl = base64Url.encode(utf8.encode(categoryModel.bannerImage ?? ''));
    // String imageUrl = categoryModel.bannerImage ?? '';
    return _navigateRoute('$categoryScreen?id=${categoryModel.id}&name=${categoryModel.name}&img=$imageUrl', route: action);
  }
  static String getSearchRoute()=> _navigateRoute(searchScreen);
  static String getSearchResultRoute(String text) {
    return _navigateRoute('$searchResultScreen?text=${Uri.encodeComponent(jsonEncode(text))}');
  }
  static String getDashboardRouter(String page, {RouteAction? action}) => _navigateRoute('$dashboardScreen?page=$page', route: action);
  static String getCreateAccountRoute()=> _navigateRoute(createAccountScreen);
  static String getAddressRoute()=> _navigateRoute(addressScreen);
  static String getAddAddressRoute(String page, String action, AddressModel addressModel) {
    String data = base64Url.encode(utf8.encode(jsonEncode(addressModel.toJson())));
    return _navigateRoute('$addAddressScreen?page=$page&action=$action&address=$data');
  }
  static String getCheckoutRoute(double? amount, String page, String? code) {
    String amount0 = base64Url.encode(utf8.encode(amount.toString()));
    return _navigateRoute('$checkoutScreen?amount=$amount0&page=$page&&code=${''}');
  }
  static String getPaymentRoute(String url, {bool fromCheckout = true}) {
    return _navigateRoute('$paymentScreen?url=${Uri.encodeComponent(url)}&from_checkout=$fromCheckout');
  }

  static String getOrderSuccessScreen(String orderId, String statusMessage) => _navigateRoute('$orderSuccessScreen?order_id=$orderId&status=$statusMessage', route: RouteAction.pushReplacement);

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
        SplashScreen(routeTo: path) : (Provider.of<BranchProvider>(context, listen: false).getBranchId() != -1 || isBranchCheck) ?
        route : const BranchListScreen();
  }

  static String? _getPath(GoRouterState state) => '${state.fullPath}?${state.uri.query}';

  static final goRoutes = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: getSplashRoute(),
      errorBuilder: (ctx, _) => const PageNotFoundScreen(),
      routes: [
        GoRoute(path: splashScreen, builder: (context, state) => const SplashScreen()),
        GoRoute(path: onBoardingScreen, builder: (context, state) => OnBoardingScreen()),
        GoRoute(path: welcomeScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const WelcomeScreen())),
        GoRoute(path: loginScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const LoginScreen())),
        GoRoute(path: createAccountScreen, builder: (context, state) => _routeHandler(context,  path: _getPath(state), const CreateAccountScreen())),
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
        GoRoute(path: branchListScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const BranchListScreen())),
        GoRoute(path: homeItem, builder: (context, state) => _routeHandler(context, path: _getPath(state), HomeItemScreen(productType: ProductType.values.byName(state.uri.queryParameters['type']!)))),
        GoRoute(path: addressScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), const AddressScreen())),
        GoRoute(path: addAddressScreen, builder: (context, state) {
          bool isUpdate = state.uri.queryParameters['action'] == 'update';
          AddressModel? addressModel;

          if(isUpdate) {
            String decode = utf8.decode(base64.decode('${state.uri.queryParameters['address']?.replaceAll(' ', '+')}'));
            addressModel = AddressModel.fromJson(jsonDecode(decode));
          }

          return _routeHandler(context, path: _getPath(state), AddNewAddressScreen(
            fromCheckout: state.uri.queryParameters['page'] == 'checkout',
            isEnableUpdate: isUpdate,
            addressModel:  isUpdate ? addressModel : null,
          ));
        }),
        GoRoute(path: checkoutScreen, builder: (context, state) {
          String amount = '${jsonDecode(utf8.decode(base64Decode(state.uri.queryParameters['amount'] ?? '')))}';
          bool fromCart = state.uri.queryParameters['page'] == 'cart';

          return _routeHandler(context, path: _getPath(state), (!fromCart ? const PageNotFoundScreen() : CheckoutScreen(
              amount: double.tryParse(amount),
              fromCart: fromCart,
              cartList: null
          )));
        }),
        GoRoute(path: orderSuccessScreen, builder: (context, state) {
          String? orderId = state.uri.queryParameters['order_id'];
          int status = (state.uri.queryParameters['status'] == 'success' || state.uri.queryParameters['status'] == 'payment-success')
              ? 0 : state.uri.queryParameters['status'] == 'payment-fails'
              ? 1 : state.uri.queryParameters['status'] == 'order-fail'
              ? 2 : 3 ;

          return _routeHandler(context, path: _getPath(state), OrderSuccessfulScreen(orderId: orderId, status: status), isBranchCheck: true);
        })
        // GoRoute(path: paymentScreen, builder: (context, state) => _routeHandler(context, path: _getPath(state), PaymentScreen(), isBranchCheck: true))
      ]
  );
}

class HistoryUrlStrategy extends PathUrlStrategy {
  @override
  void pushState(Object? state, String title, String url) => replaceState(state, title, url);
}