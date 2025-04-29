import 'package:dio/dio.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/data_sync_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/domain/repositories/auth_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/frequently_bought_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/providers/category_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/domain/repositories/banner_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/domain/repositories/cart_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/domain/repositories/category_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/data_sync_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/repositories/location_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/providers/banner_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/providers/sorting_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/notification/domain/repositories/notification_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/notification/providers/notification_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/repositories/order_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/product_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order_track/providers/timer_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/domain/repositories/profile_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/providers/profile_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/rate_review/providers/review_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/search/domain/repositories/search_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/search/providers/search_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/domain/repositories/splash_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/wishlist/domain/repositories/wishlist_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/dio/dio_client.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/wishlist/providers/wishlist_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => DataSyncRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SplashRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => CategoryRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => BannerRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProductRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => CartRepo(sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => LocationRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SearchRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));
  sl.registerLazySingleton(() => WishlistRepo(dioClient: sl()));

  // Provider
  sl.registerLazySingleton(() => DataSyncProvider());
  sl.registerLazySingleton(() => SplashProvider(splashRepo: sl()));
  sl.registerLazySingleton(() => CategoryProvider(categoryRepo: sl()));
  sl.registerLazySingleton(() => BannerProvider(bannerRepo: sl()));
  sl.registerLazySingleton(() => ProductProvider(productRepo: sl()));
  sl.registerLazySingleton(() => CartProvider(cartRepo: sl()));
  sl.registerLazySingleton(() => OrderProvider(orderRepo: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => AuthProvider(authRepo: sl()));
  sl.registerLazySingleton(() => LocationProvider(locationRepo: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileProvider(profileRepo: sl()));
  sl.registerLazySingleton(() => NotificationProvider(notificationRepo: sl()));
  sl.registerLazySingleton(() => WishlistProvider(wishlistRepo: sl()));
  sl.registerLazySingleton(() => SearchProvider(searchRepo: sl()));
  sl.registerLazySingleton(() => TimerProvider());
  sl.registerLazySingleton(() => BranchProvider(splashRepo: sl()));
  sl.registerLazySingleton(() => ReviewProvider(productRepo: sl()));
  sl.registerLazySingleton(() => ProductSortProvider());
  sl.registerLazySingleton(() => CheckoutProvider(orderRepo: sl()));
  sl.registerLazySingleton(() => FrequentlyBoughtProvider(productRepo: sl()));

  // External
  final sharedPreference = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreference);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}