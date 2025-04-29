import 'dart:io';
import 'dart:ui';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/local/cache_response.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/frequently_bought_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/providers/category_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/providers/banner_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/providers/sorting_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/notification/providers/notification_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order_track/providers/timer_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/providers/profile_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/rate_review/providers/review_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/search/providers/search_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/wishlist/providers/wishlist_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/notification_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/theme/light_theme.dart';
import 'package:flutter/foundation.dart' show PlatformDispatcher, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'di_container.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
late AndroidNotificationChannel channel;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final database = AppDatabase();

Future<void> main() async {

  HttpOverrides.global = MyHttpOverrides();

  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();

  // Firebase crash analytics
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  // };

  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };

  if(defaultTargetPlatform == TargetPlatform.android) {
    // await FirebaseMessaging.instance.requestPermission();
  }

  await di.init();

  String? path;
  int? orderId;

  try {
    path = await initDynamicLinks();
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high
    );


    final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(remoteMessage != null) {
      orderId = remoteMessage.notification!.titleLocKey != null ? int.parse(remoteMessage.notification!.titleLocKey!) : null;
    }
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  } catch(e) {
    debugPrint('error ===> $e');
  }

  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BannerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CartProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WishlistProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SearchProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TimerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BranchProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ReviewProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductSortProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CheckoutProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<FrequentlyBoughtProvider>())
    ],
    child: MyApp(orderId: orderId, route: path)
  ));

}


class MyApp extends StatefulWidget {
  final int? orderId;
  final String? route;

  const MyApp({super.key, required this.orderId, required this.route});

  @override
  State<MyApp> createState ()=> _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<SplashProvider>(builder: (context, splashProvider, child) {
      return MaterialApp.router(
        routerConfig: RouterHelper.goRoutes,
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: light,
        scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
          PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown
        }),
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(MediaQuery.sizeOf(context).width < 380 ? 0.9 : 1)),
            child: Scaffold(
              body: Stack(
                children: [
                  child!
                ],
              ),
            )
        ),
      );
    });
  }
}

Future<String?> initDynamicLinks() async {
  final appLinks = AppLinks();
  final uri = await appLinks.getInitialLink();
  String? path;

  if(uri != null) {
    path = uri.path;
  } else {
    path = null;
  }

  return path;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}
